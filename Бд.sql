CREATE TABLE IF NOT EXISTS Genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Artist_Genres (
    artist_id INT REFERENCES Artists(id),
    genre_id INT REFERENCES Genres(id),
    PRIMARY KEY (artist_id, genre_id)
);

CREATE TABLE IF NOT EXISTS Albums (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    release_year INT
);

CREATE TABLE IF NOT EXISTS Album_Artists (
    album_id INT REFERENCES Albums(id),
    artist_id INT REFERENCES Artists(id),
    PRIMARY KEY (album_id, artist_id)
);

CREATE TABLE IF NOT EXISTS Tracks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration TIME,
    album_id INT REFERENCES Albums(id)
);

CREATE TABLE IF NOT EXISTS Compilation (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    release_year INT
);

CREATE TABLE IF NOT EXISTS Artists_Tracks (
    id SERIAL PRIMARY KEY,
    artist_id INT REFERENCES Artists(id),
    track_id INT REFERENCES Tracks(id)
);

CREATE TABLE IF NOT EXISTS Compilation_Tracks (
    id SERIAL PRIMARY KEY,
    compilation_id INT REFERENCES Compilation(id),
    track_id INT REFERENCES Tracks(id)
);

INSERT INTO Genres (name) VALUES
('Pop'), ('Rock'), ('Jazz');

INSERT INTO Artists (name) VALUES
('Artist One'), ('Artist Two'), ('Artist Three'), ('SoloArtist');

INSERT INTO Artist_Genres (artist_id, genre_id) VALUES
(1, 1), (1, 2),
(2, 3),
(3, 1),
(4, 2), (4, 3);

INSERT INTO Albums (name, release_year) VALUES
('Album 2019', 2019),
('Album 2020', 2020),
('Album 2018', 2018),
('Album 2021', 2021);

INSERT INTO Album_Artists (album_id, artist_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(2, 4);

INSERT INTO Tracks (title, duration, album_id) VALUES
('Track A', '00:03:45', 1),
('Track B', '00:04:20', 2),
('Track C', '00:05:10', 3),
('Track D', '00:02:50', 4),
('Track E', '00:04:00', 1),
('Track F', '00:03:30', 2);

INSERT INTO Artists_Tracks (artist_id, track_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(4, 6);

INSERT INTO Compilation (name, release_year) VALUES
('Compilation 2019', 2019),
('Compilation 2020', 2020),
('Compilation 2021', 2021),
('Exclusive Collection', 2020);

INSERT INTO Compilation_Tracks (compilation_id, track_id) VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 5),
(3, 4),
(4, 6);

SELECT g.name AS genre, COUNT(DISTINCT ag.artist_id) AS artist_count
FROM Genres g
LEFT JOIN Artist_Genres ag ON g.id = ag.genre_id
GROUP BY g.name;

SELECT COUNT(*) AS tracks_count
FROM Tracks t
JOIN Albums a ON t.album_id = a.id
WHERE a.release_year BETWEEN 2019 AND 2020;

SELECT a.name AS album_name, 
       AVG(EXTRACT(EPOCH FROM t.duration) / 60) AS avg_duration_minutes
FROM Tracks t
JOIN Albums a ON t.album_id = a.id
GROUP BY a.name;

SELECT a.name
FROM Artists a
LEFT JOIN Artists_Tracks at ON a.id = at.artist_id
LEFT JOIN Tracks t ON at.track_id = t.id
LEFT JOIN Albums al ON t.album_id = al.id
GROUP BY a.id, a.name
HAVING COUNT(CASE WHEN al.release_year = 2020 THEN 1 END) = 0;

SELECT DISTINCT c.name
FROM "Compilation" c
JOIN Compilation_Tracks ct ON c.id = ct.compilation_id
JOIN Tracks t ON ct.track_id = t.id
JOIN Artists_Tracks at ON t.id = at.track_id
JOIN Artists a ON at.artist_id = a.id
WHERE a.name = 'Artist One';