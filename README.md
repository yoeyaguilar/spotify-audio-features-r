# The Sound of Genre: Visualizing Spotify's Audio DNA

Using R, tidyverse, and ggplot2 to explore 114,000 Spotify tracks across 114 genres — finding the audio fingerprints that make each genre sound distinct.

## What's in here

- **`explore_data.R`** — Initial data loading and exploration (rows, columns, unique genres, summary statistics).
- **`make_charts.R`** — Builds three themed visualizations: genre fingerprints (bar chart), mood map (energy vs. valence scatter), and popular-vs-obscure track comparison (density plots).

## Findings

1. **Every genre has a distinct audio fingerprint.** Classical lives in a near-pure-acoustic, low-energy bubble. Metal is the energy outlier. Hip-hop leads on danceability.
2. **Mood maps to energy and emotion.** Plotting energy against valence reveals four mood quadrants; each genre clusters into a recognizable emotional signature.
3. **Hits favor energy and movement, not happiness.** Popular tracks skew toward higher energy and danceability. But valence (positivity) shows almost no difference between popular and obscure tracks — the idea that "happy songs sell" turns out to be wrong.

Full writeup with charts on my [Projects page](https://www.yoeyaguilar.com/projects.html).

## How to run it

You'll need R (4.0+) and the tidyverse package:

​```r
install.packages("tidyverse")
​```

Then download the dataset from Kaggle and place `spotify_tracks.csv` in this folder:

[Spotify Tracks Dataset on Kaggle](https://www.kaggle.com/datasets/maharshipandya/-spotify-tracks-dataset)

Then in RStudio:

​```r
source("explore_data.R")   # data exploration
source("make_charts.R")    # generates 3 PNG charts
​```

## Data source

[Spotify Tracks Dataset on Kaggle](https://www.kaggle.com/datasets/maharshipandya/-spotify-tracks-dataset) by Maharshi Pandya.

## About me

I'm Joe — a Data Science BS graduate (summa cum laude, University of Phoenix) starting a Master of Computer Science in Data Science at the University of Illinois Urbana-Champaign in Fall 2026. More projects at [yoeyaguilar.com](https://www.yoeyaguilar.com).