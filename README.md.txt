# Trustworthy Aggregation of AI-Generated Recommendations

## Overview

This repository contains a reproducible computational workflow for analyzing heterogeneous AI-generated recommendations for interdisciplinary PhD projects.  
It demonstrates exploratory **frequency analysis**, **weighted aggregation**, and **dependence-aware correction with diversity bonuses**.  

The workflow emphasizes:
- reproducibility,  
- methodological transparency,  
- uncertainty-aware reasoning,  
- and interpretability.

This work was developed in the context of evaluating recommendations from multiple AI systems (Google AI Mode, Google Gemini, ChatGPT) and mapping them against KEMAI project options (A1–D2).

---

## Repository Structure

---

## Scripts Description

### `01_basic_frequency_analysis.R`
- Performs simple frequency-based aggregation of AI recommendations.  
- Produces `basic_frequency_results.csv` and a basic plot.  
- No weighting or dependence correction is applied.

### `02_weighted_borda_analysis.R`
- Applies weighted Borda-style aggregation according to recommendation category.  
- Produces `weighted_borda_scores.csv` and a corresponding plot.  
- Prepares for downstream dependence correction.

### `03_dependence_corrected_analysis.R`
- Applies **dependence-aware weighting** to discount repeated recommendations from the same AI source.  
- Adds a **cross-model diversity bonus** to favor projects supported by multiple independent AI systems.  
- Produces `dependence_corrected_scores.csv`, final plots, and a cross-model support table.  
- Includes interpretation and methodological reflection.  

---

## Methodology Overview

1. **Raw Frequency Analysis**  
   Simple count of recommendations per project across AI systems.

2. **Weighted Borda Aggregation**  
   Categories `Hit`, `FreshHit`, `Final`, `FreshFinal` receive increasing weights.  
   Weighted scores are normalized to probabilities.

3. **Dependence Correction & Diversity Bonus**  
   - Down-weight repeated outputs from the same AI (`CorrectedWeight = BaseWeight / sqrt(repetition_index)`)  
   - Reward projects supported across multiple AI systems (`DiversityBonus = log(1 + UniqueAIs)`)

4. **Visualization & Interpretation**  
   - Bar plots and probability distributions of final scores.  
   - Interpretive summary highlighting heuristic, exploratory, and reproducible aspects.  

---

## Outputs

All results are reproducible and stored in the `outputs/` folder:

- **CSV tables**: raw frequencies, weighted scores, dependence-corrected scores  
- **Plots**: frequency plots, weighted Borda plots, dependence-corrected plots  
- **Cross-model support table**: shows which AI systems supported each project  

---

## Limitations

- AI outputs are **not statistically independent**.  
- Weighting schemes and diversity bonuses are **heuristic**.  
- Sample size is small and exploratory.  
- This workflow demonstrates **methodological rigor and transparency** rather than formal statistical inference.  

---

## Reproducibility

- R scripts are modular, executable, and produce all outputs automatically.  
- Session information is included at the end of each script.  
- The workflow is designed for transparency and interpretability.  

---

## Author

**Abdul Hasib**  
Assistant Professor of Chemistry, Bangladesh  

Research Interests:  
- Trustworthy AI  
- Uncertainty-aware computational systems  
- Interpretable modeling  
- Data-driven scientific reasoning  
- Reproducible computational workflows in R/Python  

---

## Recommended Citation

Hasib, A. (2026). Trustworthy AI Recommendation Analysis (v1.0.0). Zenodo. https://doi.org/10.5281/zenodo.20257172

## DOI

This repository is archived on Zenodo:

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20257172.svg)](https://doi.org/10.5281/zenodo.20257172) 

