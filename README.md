# Marketing MMM Inputs Project

## Goal
Build a clean, standardized dataset from messy marketing data to support marketing mix modeling (MMM).

## Overview
This project transforms inconsistent, multi-source marketing data into a unified, model-ready dataset. It focuses on data cleaning, imputation, schema standardization, and handling missing dimensions across platforms.

---

## Key Concepts Demonstrated
- Working with imperfect and inconsistent datasets
- Diagnosing and resolving data quality issues
- Validating and reconstructing unreliable metrics
- Standardizing data across multiple marketing sources (Google, Meta, TikTok)

---

## Data Sources
- Google Ads dataset (raw data ingested from CSV into a base table, then used for data cleaning and imputation)
- Multi-platform dataset (Meta and TikTok, including geographic data)

---

## Scope
This project uses data from November 2024 only.

The date range was intentionally limited to:
- Align multiple datasets to a consistent time period
- Simplify development and validation of transformations
- Focus on data preparation logic rather than data volume

The same pipeline can be extended to longer time horizons in a production setting.

---

## Data Issues Identified

The Google Ads dataset contains several inconsistencies and missing values:

- Conversion rate is not reliably derived from clicks and conversions
- Missing values in core metrics (clicks, impressions, cost)
- Inconsistent or low-signal fields (campaign_name, keyword)
- Ambiguous definitions for leads and conversions

These issues required validation and reconstruction of key metrics before building model inputs.

---

## Methodology

### Data Cleaning & Imputation (Google Ads)
A separate dataset was used for Google Ads to demonstrate data cleaning and imputation techniques.

Missing values in core metrics (clicks, impressions, cost) were imputed using daily averages:
- Daily averages were calculated per metric
- Null values were replaced with the corresponding daily average

Unreliable or low-signal fields were excluded from the final dataset.

---

### Multi-Source Integration
Data from Google, Meta, and TikTok were standardized into a unified structure despite differences in schema and dimensional granularity.

---

### Geographic Allocation (Google Ads)
The Google Ads dataset does not include geographic information. To enable country-level analysis across platforms, Google metrics were allocated using daily country-level spend share derived from Meta and TikTok data.

For dates with no Meta or TikTok data (two cases), Google metrics were distributed evenly across countries as a fallback when no signal was available.

---

### Assumptions & Limitations
- Geographic allocation for Google Ads is a proxy method and does not represent true performance.
- In production scenarios, more stable distributions (e.g., multi-day or monthly averages) would be used to reduce volatility.
- Differences in source data structure and granularity may impact direct comparability across platforms.

---

### Data Validation
- Allocation weights were validated to ensure daily shares sum to 1
- Total Google metrics reconcile before and after geographic allocation

---

## Output
The final output is a unified, daily dataset at the country level, with standardized metrics across platforms (clicks, impressions, cost), suitable for use as input into marketing mix models.

---

## Reproducibility
SQL scripts for data exploration, transformation, and final dataset creation are available in the `/sql` directory.

---

## Additional Notes
In prior work, normalized metrics such as GRPs (impressions relative to population) were used. Population data was not available for this dataset, so normalization was not applied here.