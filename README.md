# TuneDNA-My-Spotify-Analysis
TuneDNA : Decoding my Spotify Playlists &amp; Analyzing my Personality Traits with Data

> **"What does my music say about me?"**
This project explores the emotional and sonic patterns in my personal Spotify playlists using **Python**, **Snowflake SQL**, and **Tableau**, aiming to decode personality traits through music.

**Tech Stack**
- **Spotify API** for playlist data
- **Python** for data extraction & preprocessing
- **Snowflake** for cloud-based SQL analysis
- **Tableau Public** for interactive dashboards


**Dataset**
- `tracks.csv`: Playlist name, track name, artist
- `track_features.csv`: Audio features (valence, energy, danceability, tempo)

**Python: Data Extraction**
  1.Fetched tracks from my own playlists using spotipy  
  2. Extracted features like:
      danceability, energy, valence, tempo, etc.
  3. Merged and saved as spotify_tracks.csv and audio_features.csv

**Snowflake: SQL Analysis**
  1.Loaded two tables:
      spotify_tracks → playlist name, track name, artist
      audio_features → track name, valence, energy, danceability, tempo
  4. Joined tables on track_name
  5.Classified moods:
      Happy: valence > 0.7
      Sad: valence < 0.3
      Neutral: in-between
  6.Analyzed mood, energy, tempo

**Tableau: Dashboards**
   * Built interactive visuals like:
      1.Pie Chart: Mood Distribution
      2.Bar Chart: Top 10 Happiest Songs
      3.Scatterplot: Energy vs Danceability
      4.Scatterplot: Tempo vs Valence Chart

**Challenges Faced**
  * Spotify API Restrictions
    1.Couldn’t fetch data for Global Top 50 (not publicly exposed via API)
    2.API only works with user-authenticated playlists
  
  * Deprecated Function in spotipy
    1.sp.audio_features(track_ids) sometimes returned None
    2.Solved by librosa extracting audio features from download youtube songs.
  
  * Matching Tracks Between Tables
    1.Needed to clean track_name (lowercase, strip spaces) for joins
    2.Still had mismatches due to special characters or duplicates
  
  * Tableau Limitations (Public Edition)
    1.Couldn’t connect Snowflake directly in Tableau Public
    2.Had to export CSV from Snowflake and use as data source in Tableau


**Key Visualizations**
- Mood Breakdown (Pie Chart)
- Energy vs Danceability (Scatter)
- Tempo vs Valence with mood lines
- Top 10 happiest songs

**Tableau Dashboard**
🔗  
(*Hosted on Tableau Public*)

**SQL Queries** 
- Join and Clean Tracks
- Mood Classification
- Top Songs by Valence

**Insights** 
- Most songs had a **low valence**, suggesting sad/reflective mood.
- Energy levels and danceability correlated moderately.
- Happy songs were underrepresented—time to update the playlist!

  **How to Reproduce** 
    **Prerequisites** 
      1.Python 3.x
      2.Spotify Developer Account
      3.Snowflake Account
      4.Tableau Desktop or Tableau Public
  
  **Steps** 
    1.Clone this repo:
        git clone https://github.com/your-username/tuneDNA.git
        cd tuneDNA
    2.Install dependencies:
        pip install spotipy pandas
    3.Run the Python script to fetch playlist data:
        python notebooks/spotify_data_extract.py
    4.Upload the CSVs to Snowflake and run SQL queries
    5.Export result as CSV and build dashboards in Tableau.


**Final Thoughts** 
  This was a passion project that helped me practice:
    1.Working with APIs
    2.Data cleaning and joining 
    3.SQL-based data storytelling
    4.Building visually appealing dashboards
  And it helped me understand how my music taste reflects different aspects of my personality. 

  
  
