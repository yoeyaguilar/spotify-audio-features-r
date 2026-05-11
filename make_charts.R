library(tidyverse)

# Load Data
df <- read_csv("spotify_tracks.csv")

# ==== Chart 1: Genre Fingerprints ====

# Pick 6 contrasting genres
selected_genres <- c("classical", "hip-hop", "edm", "country", "metal", "jazz")

# Filter the data and reshape it for plotting
chart1_data <- df |>
  filter(track_genre %in% selected_genres) |>
  group_by(track_genre) |>
  summarise(
    Danceability = mean(danceability),
    Energy = mean(energy),
    Valence = mean(valence),
    Acousticness = mean(acousticness)
  ) |>
  pivot_longer(
    cols = -track_genre,
    names_to = "feature",
    values_to = "value"
  )

print(chart1_data)

# Plot Chart 1
chart1 <- ggplot(chart1_data, aes(x = track_genre, y = value, fill = feature)) +
  geom_col(position = "dodge", width = 0.8) +
  scale_fill_manual(values = c(
    "Danceability" = "#C8A15C",
    "Energy" = "#E31837",
    "Valence" = "#FFFFFF",
    "Acousticness" = "#888888"
  )) +
  labs(
    title = "Genre Fingerprints: How 6 Genres Sound, by the Numbers",
    subtitle = "Average audio feature values across 1,000 tracks per genre",
    x = NULL,
    y = "Average value (0-1 scale)",
    fill = NULL,
    caption = "Source: Spotify Tracks Dataset (Kaggle)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.background = element_rect(fill = "#000000", color = NA),
    panel.background = element_rect(fill = "#111111", color = NA),
    panel.grid.major = element_line(color = "#333333", linewidth = 0.3),
    panel.grid.minor = element_blank(),
    plot.title = element_text(color = "#FFFFFF", face = "bold", size = 14),
    plot.subtitle = element_text(color = "#C8A15C", size = 11),
    plot.caption = element_text(color = "#888888", size = 9),
    axis.text = element_text(color = "#C8A15C"),
    axis.title = element_text(color = "#C8A15C"),
    legend.text = element_text(color = "#C8A15C"),
    legend.position = "top", 
    legend.background = element_rect(fill = "#000000", color = NA)
  )

# Display it (will appear in the Plots pane)
print(chart1)

# Save to file
ggsave("chart1_genre_fingerprints.png", chart1,
       width = 10, height = 6, dpi = 150,
       bg = "#000000")

cat("Saved: chart1_genre_fingerprints.png\n")


# ==== Chart 2: The Mood Map

# Sample down to make the chart readable
set.seed(42) # reproducibility

chart2_data <- df |>
  filter(track_genre %in% selected_genres) |>
  group_by(track_genre) |>
  slice_sample(n = 500) |>
  ungroup()

chart2 <- ggplot(chart2_data, aes(x = energy, y = valence, color = track_genre)) +
  geom_point(alpha = 0.4, size = 1.2) +
  scale_color_manual(values = c(
    "classical" = "#FFFFFF",
    "country" = "#C8A15C",
    "edm" = "#E31837",
    "hip-hop" = "#9b59b6",
    "jazz" = "#3498db",
    "metal" = "#e67e22"
  )) +
  geom_vline(xintercept = 0.5, color = "#444444", linetype = "dashed", linewidth = 0.4) +
  geom_hline(yintercept = 0.5, color = "#444444", linetype = "dashed", linewidth = 0.4) +
  annotate("text", x = 0.01, y = 0.99, label = "CALM / CONTENT",
           color = "#999999", size = 3.2, hjust = 0, fontface = "bold") +
  annotate("text", x = 0.99, y = 0.99, label = "HAPPY / UPBEAT",
           color = "#999999", size = 3.2, hjust = 1, fontface = "bold") +
  annotate("text", x = 0.01, y = 0.01, label = "SAD / MELANCHOLY",
           color = "#999999", size = 3.2, hjust = 0, fontface = "bold") +
  annotate("text", x = 0.99, y = 0.01, label = "ANGRY / INTENSE",
           color = "#999999", size = 3.2, hjust = 1, fontface = "bold") +
  labs(
    title = "The Mood Map: Energy vs Valence by Genre",
    subtitle = "500 tracks per genre. Each dot is one song.",
    x = "Energy (0 = calm, 1 = intense)",
    y = "Valence (0 = sad, 1 = happy)",
    color = "Genre",
    caption = "Source: Spotify Tracks Dataset (Kaggle)"
  ) +
  guides(color = guide_legend(override.aes = list(alpha = 1, size = 3))) +
  theme_minimal(base_size = 12) +
  theme(
    plot.background = element_rect(fill = "#000000", color = NA),
    panel.background = element_rect(fill = "#111111", color = NA),
    panel.grid.major = element_line(color = "#222222", linewidth = 0.3),
    panel.grid.minor = element_blank(),
    plot.title = element_text(color = "#FFFFFF", face = "bold", size = 14),
    plot.subtitle = element_text(color = "#C8A15C", size = 11),
    plot.caption = element_text(color = "#888888", size = 9),
    axis.text = element_text(color = "#C8A15C"),
    axis.title = element_text(color = "#C8A15C"),
    legend.text = element_text(color = "#C8A15C"),
    legend.title = element_text(color = "#FFFFFF"),
    legend.position = "right",
    legend.background = element_rect(fill = "#000000", color = NA)
  )

print(chart2)

ggsave("chart2_mood_map.png", chart2,
       width = 10, height = 7, dpi = 150,
       bg = "#000000")

cat("Saved: chart2_mood_map.png\n")

# ==== Chart 3: What Makes a Hit? ====

# Categorize tracks by popularity tier
chart3_data <- df |>
  filter(popularity >= 70 | popularity < 30) |>
  mutate(tier = if_else(popularity >= 70, "Popular (70+)", "Obscure (under 30)")) |>
  select(tier, danceability, energy, valence, acousticness) |>
  pivot_longer(
    cols = c(danceability, energy, valence, acousticness),
    names_to = "feature",
    values_to = "value"
  ) |>
  mutate(
    feature = str_to_title(feature),
    feature = factor(feature, levels = c("Danceability", "Energy", "Valence", "Acousticness"))
  )

chart3 <- ggplot(chart3_data, aes(x = value, fill = tier, color = tier)) +
  geom_density(alpha = 0.4, linewidth = 0.6) +
  facet_wrap(~ feature, scales = "free_y", ncol = 2) +
  scale_fill_manual(values = c(
    "Popular (70+)"      = "#C8A15C",
    "Obscure (under 30)" = "#888888"
  )) +
  scale_color_manual(values = c(
    "Popular (70+)"      = "#C8A15C",
    "Obscure (under 30)" = "#888888"
  )) +
  labs(
    title = "What Makes a Hit? Popular vs. Obscure Tracks",
    subtitle = "Distribution of audio features for popular (70+) vs. obscure (under 30) tracks",
    x = "Feature value (0-1 scale)",
    y = "Density",
    fill = NULL,
    color = NULL,
    caption = "Source: Spotify Tracks Dataset (Kaggle)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.background = element_rect(fill = "#000000", color = NA),
    panel.background = element_rect(fill = "#111111", color = NA),
    panel.grid.major = element_line(color = "#222222", linewidth = 0.3),
    panel.grid.minor = element_blank(),
    plot.title = element_text(color = "#FFFFFF", face = "bold", size = 14),
    plot.subtitle = element_text(color = "#C8A15C", size = 11),
    plot.caption = element_text(color = "#888888", size = 9),
    axis.text = element_text(color = "#C8A15C"),
    axis.title = element_text(color = "#C8A15C"),
    legend.text = element_text(color = "#C8A15C"),
    legend.position = "top",
    legend.background = element_rect(fill = "#000000", color = NA),
    strip.text = element_text(color = "#FFFFFF", face = "bold"),
    strip.background = element_rect(fill = "#222222", color = NA)
  )

print(chart3)

ggsave("chart3_what_makes_a_hit.png", chart3,
       width = 10, height = 7, dpi = 150,
       bg = "#000000")

cat("Saved: chart3_what_makes_a_hit.png\n")