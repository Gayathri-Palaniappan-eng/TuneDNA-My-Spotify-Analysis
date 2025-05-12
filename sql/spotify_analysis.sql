CREATE DATABASE TuneDB;

CREATE SCHEMA TuneDB.music_schema;

CREATE or REPLACE TABLE music_schema.tracks (
    playlist string,
    track_name string,
    artist string

);

CREATE or REPLACE TABLE music_schema.tracks_features (
    track_name string,
    danceability float,
    energy float,
    valence float,
    tempo float


);

-- Check for Null or Blank Values
-- Tracks Table

select 
    count(*) as total_rows,
    sum(case when playlist is null or trim(playlist) = '' then 1 else 0 end) as null_playlist,
    sum(case when track_name is null or trim(track_name) = '' then 1 else 0 end) as track_name,
    sum(case when artist is null or trim(artist) = '' then 1 else 0 end) as artist
from music_schema.tracks;



-- Check for Null or Blank Values
-- Features Table

select
    count(*) as total_rows,
    sum(case when track_name is null or trim(track_name) = '' then 1 else 0 end) as null_track_name,
    sum(case when danceability is null then 1 else 0 end) as null_danceability,
    sum(case when energy is null then 1 else 0 end) as null_energy,
    sum(case when valence is null then 1 else 0 end) as null_valence,
    sum(case when tempo is null then 1 else 0 end) as null_tempo
from music_schema.tracks_features;


-- Check for duplicates

select track_name,count(*)
from music_schema.tracks
group by track_name
having count(*) >1;

-- Add a New Column for Cleaned Track Name

Alter TABLE music_schema.tracks
add column cleaned_track_name string;

-- Update the new column with cleaned track names

update music_schema.tracks
set cleaned_track_name = regexp_replace(
REGEXP_REPLACE(
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(
                        REGEXP_REPLACE(track_name, '\\s*\\(.*?\\)', ''),   -- Remove ( ... )
                        '- [^0-9].*$', ''                                  -- Remove "- Remix" type text
                    ),
                    '[.,?]', ''                                            -- Remove . , ?
                ),
                '[\u0027\u2019]', ' '                                      -- Replace ' and ’ with space
            ),
            '-', ''                                                        -- Remove all hyphens
        ),
        '\\s+', ' '

);



-- Add a new column for cleaned track name in tracks_features table

alter table music_schema.tracks_features
add column cleaned_features_track_name string;

-- Update the new column with cleaned features track names

update music_schema.tracks_features
set cleaned_features_track_name = regexp_replace(
    regexp_replace(track_name, '_+', ' '),'\\s*From.*$',''

);

-- Joining Both Tables for Analysis

create or replace table music_schema.music_analysis as
select t.playlist,
f.cleaned_features_track_name,
t.artist,
f.danceability,
f.energy,
f.valence,
f.tempo
from music_schema.tracks t
inner join music_schema.tracks_features f
on t.cleaned_track_name = f.cleaned_features_track_name;


select * from music_schema.tracks;
select * from music_schema.tracks_features;
select * from music_schema.music_analysis;

--Average Danceability & Energy per playlist

select playlist, 
round(avg(danceability),3) as avg_danceability, 
round(avg(energy),3) as avg_energy
from music_schema.music_analysis
group by playlist;

--Playlist with most danceable songs

select playlist,count(*) as danceable_songs
from music_schema.music_analysis
where danceability > 0.7
group by playlist
order by danceable_songs desc;

--classify songs by Mood (Happy, Neutral, sad)

select cleaned_features_track_name, artist,
case
    when valence > 0.7 then 'Happy'
    when valence between 0.3 and 0.7 then 'Neutral'
    else 'sad'
end as mood_category
from music_schema.music_analysis;

-- count of songs by Mood

select mood_category, count(mood_category)
from
(select cleaned_features_track_name, artist,
case
    when valence > 0.7 then 'Happy'
    when valence between 0.3 and 0.7 then 'Neutral'
    else 'sad'
end as mood_category
from music_schema.music_analysis)
as mood_category
group by mood_category;


-- Fastest & Slowest Songs Based on Tempo

select cleaned_features_track_name, artist, tempo
from music_schema.music_analysis
order by tempo desc
limit 5;


select cleaned_features_track_name, artist, tempo
from music_schema.music_analysis
order by tempo asc
limit 5;


-- High Energy

select cleaned_features_track_name, artist, energy, playlist
from music_schema.music_analysis
where energy > 0.1
order by energy desc;













