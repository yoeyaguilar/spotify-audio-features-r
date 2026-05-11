library(tidyverse)

# Load the data
df <- read.csv("spotify_tracks.csv")

# Quick Summary
cat("Rows:", nrow(df), "\n")
cat("Columns:", ncol(df), "\n\n")

# Glimpse - show column names, types, & first few values
glimpse(df)

# How many unique genres? 
print(n_distinct(df$track_genre))

# What are the top 10 genres by row count? 
print(
  df |>
    count(track_genre, sort = TRUE) |>
    head(10)
)
# Range and mean of key audio features
print(
  df |> 
    summarise(
      pop_min = min(popularity),
      pop_max = max(popularity),
      pop_mean = round(mean(popularity), 1),
      danceability_mean = round(mean(danceability), 3),
      energy_mean = round(mean(energy), 3),
      valence_mean = round(mean(valence), 3)
  )
)
