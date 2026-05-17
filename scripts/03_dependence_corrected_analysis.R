# ==========================================================
# Dependence-Corrected Aggregation of AI Recommendations
# ==========================================================
#
# PURPOSE:
# Applies dependence-aware weighting and diversity bonuses
# to heterogeneous AI-generated AI project recommendations.
#
# NOTE:
# Heuristic and exploratory workflow. Adjusts for repeated
# recommendations from the same AI system and rewards
# cross-model diversity.
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
# Base Weights (Borda-Style)
# ----------------------------------------------------------
weights <- c(
  "Hit" = 1,
  "FreshHit" = 2,
  "Final" = 3,
  "FreshFinal" = 4
)
df <- df %>% mutate(BaseWeight = weights[Category])

# ----------------------------------------------------------
# Dependence Correction
# ----------------------------------------------------------
# Down-weight repeated recommendations from the same AI
df_corrected <- df %>%
  group_by(AI, Project) %>%
  mutate(
    RepetitionIndex = row_number(),
    DependencePenalty = sqrt(RepetitionIndex),
    CorrectedWeight = BaseWeight / DependencePenalty
  ) %>%
  ungroup()

# ----------------------------------------------------------
# Cross-Model Diversity Bonus
# ----------------------------------------------------------
diversity <- df_corrected %>%
  group_by(Project) %>%
  summarise(UniqueAIs = n_distinct(AI))

summary_scores <- df_corrected %>%
  group_by(Project) %>%
  summarise(CorrectedScore = sum(CorrectedWeight)) %>%
  left_join(diversity, by = "Project") %>%
  mutate(
    DiversityBonus = log(1 + UniqueAIs),
    FinalScore = CorrectedScore * DiversityBonus,
    Probability = FinalScore / sum(FinalScore),
    Percentage = round(100 * Probability, 2)
  ) %>%
  arrange(desc(FinalScore))

print(summary_scores)

# ----------------------------------------------------------
# Export Results
# ----------------------------------------------------------
write.csv(
  summary_scores,
  "outputs/dependence_corrected_scores.csv",
  row.names = FALSE
)

# ----------------------------------------------------------
# Visualization: Final Scores
# ----------------------------------------------------------
p <- ggplot(summary_scores,
            aes(x = reorder(Project, FinalScore),
                y = FinalScore)) +
  geom_col(fill = "firebrick") +
  coord_flip() +
  labs(
    title = "Dependence-Corrected Recommendation Scores",
    x = "Project",
    y = "Final Score"
  ) +
  theme_minimal()

ggsave("outputs/dependence_corrected_plot.png", plot = p, width = 8, height = 5)

cat("\nPlot exported to outputs/dependence_corrected_plot.png\n")

# ----------------------------------------------------------
# Cross-Model Support Table
# ----------------------------------------------------------
cross_support <- df_corrected %>%
  group_by(Project) %>%
  summarise(
    SupportingAIs = paste(unique(AI), collapse = ", "),
    NumAIs = n_distinct(AI)
  ) %>%
  arrange(desc(NumAIs))

print(cross_support)

# ----------------------------------------------------------
# Interpretation
# ----------------------------------------------------------
cat("\n====================================\n")
cat("INTERPRETATION\n")
cat("====================================\n\n")

cat(
  "Repeated recommendations from the same AI system are down-weighted,\n",
  "and projects supported across multiple AI systems receive a diversity bonus.\n",
  "This is a heuristic, reproducible, and transparent framework.\n"
)

# ----------------------------------------------------------
# Session Info
# ----------------------------------------------------------
sessionInfo()