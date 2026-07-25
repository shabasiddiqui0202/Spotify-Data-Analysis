-- Advance sql Projects --Spotify Datasets

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


--EDA

select count(*) from spotify;

SELECT DISTINCT album_type FROM spotify;

select duration_min from spotify;

select Max(duration_min) from spotify;

select Min(duration_min) from spotify;

select * from spotify where duration_min =0;

delete from spotify where duration_min=0;

select * from spotify where duration_min =0;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

-- -------------------------------
--Data Analysis -Easy category
-- -------------------------------


--Q. Retrieve the names of all tracks that have more than 1 billion streams.

select distinct track from spotify where stream > 1000000000;

--Q. List all albums along with their respective artists.

select distinct album , artist from spotify order by 1;

--Q. Get the total number of comments for tracks where licensed = TRUE.

select sum(comments) from spotify where licensed = 'true';

--Q. Find all tracks that belong to the album type single.

select track from spotify where album_type='single';

--Q. Count the total number of tracks by each artist.

select artist , count(track) from spotify group by artist; 


-- -------------------------------
--Data Analysis -Mid category
-- -------------------------------

-- Q.Calculate the average danceability of tracks in each album.

select album , avg(danceability) from spotify group by album ; 

--Q. Find the top 5 tracks with the highest energy values.

SELECT track, energy FROM spotify ORDER BY energy DESC LIMIT 5;

--Q. List all tracks along with their views and likes where official_video = TRUE.

select track , views , likes from spotify where official_video = 'true';

--Q. For each album, calculate the total views of all associated tracks.

select album , sum(views) from spotify group by album;

--Q. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT track
FROM spotify
WHERE stream > views;


--Q. Find the top 3 most-viewed tracks for each artist using window functions.

SELECT artist, track, views
FROM (
    SELECT artist,
           track,
           views,
           ROW_NUMBER() OVER(
               PARTITION BY artist
               ORDER BY views DESC
           ) AS rn
    FROM spotify
) t
WHERE rn <= 3;

--Q. Write a query to find tracks where the liveness score is above the average.

SELECT track FROM spotify where liveness >
( 
  select avg(liveness) from spotify 
   
   ) ;


--Q. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.


WITH energy_diff AS (
SELECT album,
MAX(energy) AS max_energy,
MIN(energy) AS min_energy
FROM spotify
GROUP BY album
)
SELECT album,
max_energy - min_energy AS difference
FROM energy_diff;



--Query optimization

Explain analyze --et 3.195ms pt 0.086ms

SELECT artist, track, views
FROM spotify
WHERE artist = 'Gorillaz'
AND most_played_on = 'Youtube'
ORDER BY stream DESC
LIMIT 25;

create index artist_index on spotify (artist);