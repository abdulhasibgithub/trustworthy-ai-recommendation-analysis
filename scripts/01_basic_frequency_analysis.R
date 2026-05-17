# ==========================================================
# Basic Frequency Analysis of AI Recommendations
# ==========================================================
#
# PURPOSE:
# Simple frequency-based aggregation of project
# recommendations from heterogeneous AI systems.
#
# NOTE:
# This script performs ONLY raw frequency analysis.
# No dependence correction is applied here.
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
# Raw Recommendation Vector
# ----------------------------------------------------------
hits <- c(
  # Google AI Mode
  "C1", "C2", "B2", "B2", "B2",
  "B2", "B1", "A1", "B2",
  "C2", "B2", "C2", "A1", "C2",
  "A1", "A1", "B2", "A1",

  # Google Gemini
  "B1", "B2", "B2", "B2",
  "B2", "B1", "D2", "C1",

  # ChatGPT
  "C2", "B2",
  "A2", "C2"
)


# ----------------------------------------------------------
# Frequency Table
# ----------------------------------------------------------
freq_table <- table(hits) %>%
  sort(decreasing = TRUE)
print(freq_table)


# ----------------------------------------------------------
# Convert to Data Frame
# ----------------------------------------------------------
freq_df <- as.data.frame(freq_table)
colnames(freq_df) <- c("Project", "Frequency")

# Add percentage for interpretability
freq_df$Percentage <- round(
  100 * freq_df$Frequency / sum(freq_df$Frequency),
  2
)

print(freq_df)


# ----------------------------------------------------------
# Export Results
# ----------------------------------------------------------
write.csv(
  freq_df,
  "outputs/basic_frequency_results.csv",
  row.names = FALSE
)


# ----------------------------------------------------------
# Simple Visualization using ggplot2
# ----------------------------------------------------------
p <- ggplot(freq_df,
            aes(x = reorder(Project, Frequency),
                y = Frequency)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Basic Frequency of AI Recommendations",
    x = "Project",
    y = "Frequency"
  ) +
  theme_minimal()

# Save plot
ggsave(
  "outputs/basic_frequency_plot.png",
  plot = p,
  width = 8,
  height = 5
)

cat("\nPlot exported to outputs/basic_frequency_plot.png\n")


# ----------------------------------------------------------
# Interpretation
# ----------------------------------------------------------
cat("\n====================================\n")
cat("INTERPRETATION\n")
cat("====================================\n\n")

cat(
  "This script performs simple frequency-based\n",
  "aggregation of AI-generated project recommendations.\n\n"
)

cat(
  "No dependence correction or uncertainty adjustment\n",
  "is applied at this stage.\n"
)


# ----------------------------------------------------------
# Session Info for Reproducibility
# ----------------------------------------------------------
sessionInfo()