# ==========================================================
# Visualization Pipeline for AI Recommendation Analysis
# ==========================================================
#
# PURPOSE:
# Generate reproducible plots for all stages of the AI recommendation
# analysis workflow:
#   - Basic frequency
#   - Weighted Borda aggregation
#   - Dependence-corrected aggregation
#   - Probability distributions
#
# NOTE:
# This script reads CSV outputs from previous scripts (01-03)
# and creates publication-style PNG plots.
#
# Author: Abdul Hasib
# ==========================================================

# ----------------------------------------------------------
# Load Libraries
# ----------------------------------------------------------
library(dplyr)
library(ggplot2)
library(readr)

# ----------------------------------------------------------
# Ensure output folder exists
# ----------------------------------------------------------
if (!dir.exists("outputs")) dir.create("outputs")

# ----------------------------------------------------------
# Load Result CSVs
# ----------------------------------------------------------
freq_df <- read_csv("outputs/basic_frequency_results.csv")
weighted_df <- read_csv("outputs/weighted_borda_scores.csv")
corrected_df <- read_csv("outputs/dependence_corrected_scores.csv")

# ----------------------------------------------------------
# 1. Basic Frequency Plot
# ----------------------------------------------------------
p1 <- ggplot(freq_df, aes(x = reorder(Project, Frequency), y = Frequency)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Basic Frequency of AI Recommendations", x = "Project", y = "Frequency") +
  theme_minimal()

ggsave("outputs/basic_frequency_plot.png", plot = p1, width = 8, height = 5)

# ----------------------------------------------------------
# 2. Weighted Borda Scores Plot
# ----------------------------------------------------------
p2 <- ggplot(weighted_df, aes(x = reorder(Project, WeightedScore), y = WeightedScore)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(title = "Weighted Borda Scores of AI Recommendations", x = "Project", y = "Weighted Score") +
  theme_minimal()

ggsave("outputs/weighted_borda_plot.png", plot = p2, width = 8, height = 5)

# ----------------------------------------------------------
# 3. Dependence-Corrected Scores Plot
# ----------------------------------------------------------
p3 <- ggplot(corrected_df, aes(x = reorder(Project, FinalScore), y = FinalScore)) +
  geom_col(fill = "firebrick") +
  coord_flip() +
  labs(title = "Dependence-Corrected Recommendation Scores", x = "Project", y = "Final Score") +
  theme_minimal()

ggsave("outputs/dependence_corrected_plot.png", plot = p3, width = 8, height = 5)

# ----------------------------------------------------------
# 4. Dependence-Corrected Probabilities Plot
# ----------------------------------------------------------
p4 <- ggplot(corrected_df, aes(x = reorder(Project, Probability), y = Probability)) +
  geom_col(fill = "purple") +
  coord_flip() +
  labs(title = "Dependence-Corrected Recommendation Probabilities", x = "Project", y = "Probability") +
  theme_minimal()

ggsave("outputs/dependence_corrected_probability_plot.png", plot = p4, width = 8, height = 5)

# ----------------------------------------------------------
# 5. Optional: Cross-Model Support Plot
# ----------------------------------------------------------
cross_support <- corrected_df %>%
  select(Project, Probability) %>%
  arrange(desc(Probability))

# Example: simple barplot for cross-model support
p5 <- ggplot(cross_support, aes(x = reorder(Project, Probability), y = Probability)) +
  geom_col(fill = "orange") +
  coord_flip() +
  labs(title = "Cross-Model Support Summary", x = "Project", y = "Normalized Support") +
  theme_minimal()

ggsave("outputs/cross_model_support_plot.png", plot = p5, width = 8, height = 5)

# ----------------------------------------------------------
# Completion Message
# ----------------------------------------------------------
cat("\nAll plots saved in the outputs/ folder.\n")
cat("- basic_frequency_plot.png\n")
cat("- weighted_borda_plot.png\n")
cat("- dependence_corrected_plot.png\n")
cat("- dependence_corrected_probability_plot.png\n")
cat("- cross_model_support_plot.png\n\n")

# ----------------------------------------------------------
# Session Info for Reproducibility
# ----------------------------------------------------------
sessionInfo()