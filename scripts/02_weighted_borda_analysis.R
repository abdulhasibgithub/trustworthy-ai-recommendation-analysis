# ==========================================================
# Weighted Borda-Style Aggregation of AI Recommendations
# ==========================================================
#
# PURPOSE:
# Applies weighted aggregation to heterogeneous AI-generated
# project recommendations using a Borda-inspired scheme.
#
# NOTE:
# Base weights are assigned according to recommendation
# category. This is exploratory and heuristic.
#
# Author: Abdul Hasib
# ==========================================================


# ----------------------------------------------------------
# Load Libraries
# ----------------------------------------------------------
library(dplyr)
library(ggplot2)


# ----------------------------------------------------------
# Ensure output folder exists
# ----------------------------------------------------------
if (!dir.exists("outputs")) dir.create("outputs")


# ----------------------------------------------------------
# Raw Recommendation Dataset
# ----------------------------------------------------------
df <- tribble(
  ~AI, ~Category, ~Project,

  # Google AI Mode
  "GoogleAI", "Hit", "C1",
  "GoogleAI", "Hit", "C2",
  "GoogleAI", "Hit", "B2",
  "GoogleAI", "Final", "B2",
  "GoogleAI", "FreshHit", "B1",
  "GoogleAI", "FreshFinal", "B2",

  # Google Gemini
  "Gemini", "Hit", "B1",
  "Gemini", "Hit", "B2",
  "Gemini", "Hit", "B2",
  "Gemini", "Final", "B2",

  # ChatGPT
  "ChatGPT", "Hit", "C2",
  "ChatGPT", "Final", "B2",
  "ChatGPT", "Hit", "A2",
  "ChatGPT", "Final", "C2"
)


# ----------------------------------------------------------
# Define Base Weights (Borda-Style)
# ----------------------------------------------------------
# Higher-priority categories receive higher weights

weights <- c(
  "Hit" = 1,
  "FreshHit" = 2,
  "Final" = 3,
  "FreshFinal" = 4
)

df <- df %>%
  mutate(BaseWeight = weights[Category])


# ----------------------------------------------------------
# Weighted Aggregation
# ----------------------------------------------------------
# Sum of weights per project

weighted_scores <- df %>%
  group_by(Project) %>%
  summarise(
    WeightedScore = sum(BaseWeight)
  ) %>%
  arrange(desc(WeightedScore))

# Calculate normalized probabilities
weighted_scores <- weighted_scores %>%
  mutate(
    Probability = WeightedScore / sum(WeightedScore),
    Percentage = round(100 * Probability, 2)
  )

print(weighted_scores)


# ----------------------------------------------------------
# Export Results
# ----------------------------------------------------------
write.csv(
  weighted_scores,
  "outputs/weighted_borda_scores.csv",
  row.names = FALSE
)


# ----------------------------------------------------------
# Visualization: Weighted Scores
# ----------------------------------------------------------
p <- ggplot(weighted_scores,
            aes(x = reorder(Project, WeightedScore),
                y = WeightedScore)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Weighted Borda-Style Scores of AI Recommendations",
    x = "Project",
    y = "Weighted Score"
  ) +
  theme_minimal()

# Save plot
ggsave(
  "outputs/weighted_borda_plot.png",
  plot = p,
  width = 8,
  height = 5
)

cat("\nPlot exported to outputs/weighted_borda_plot.png\n")


# ----------------------------------------------------------
# Interpretation
# ----------------------------------------------------------
cat("\n====================================\n")
cat("INTERPRETATION\n")
cat("====================================\n\n")

cat(
  "This script applies a simple Borda-inspired weighting scheme\n",
  "to aggregate AI-generated project recommendations.\n",
  "Higher-priority recommendation categories contribute more to the\n",
  "weighted score. Probabilities are normalized across projects.\n\n"
)

cat(
  "Dependence correction for repeated AI outputs is not applied here.\n",
  "This is a heuristic, exploratory analysis intended to demonstrate\n",
  "weighted aggregation methodology.\n"
)


# ----------------------------------------------------------
# Session Info for Reproducibility
# ----------------------------------------------------------
sessionInfo()