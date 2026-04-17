# Marketing MMM Inputs Project

## Goal
Build a clean, standardized dataset from messy marketing data to support marketing mix modeling (MMM).

## Overview
This project focuses on transforming inconsistent, multi-source marketing data into a unified, model-ready dataset. It demonstrates data cleaning, imputation, schema standardization, and handling of missing dimensions across platforms.

## Key Concepts Demonstrated
- Working with imperfect and inconsistent datasets
- Validating and reconstructing metrics
- Building reliable inputs rather than focusing on end analysis
- Standardizing data across multiple marketing sources (Google, Meta, TikTok)

## Data Sources
- Google Ads dataset (used for data cleaning and imputation)
- Multi-platform dataset (Meta and TikTok, including geographic data)

## Methodology

### Data Cleaning & Imputation (Google Ads)
A separate dataset was used for Google Ads to demonstrate data cleaning and imputation techniques, including handling missing values and reconstructing reliable base metrics.

### Multi-Source Integration
Data from Google, Meta, and TikTok were standardized into a unified structure despite differences in schema and dimensional granularity.

### Geographic Allocation (Google Ads)
The Google Ads dataset does not include geographic information. To enable country-level analysis across platforms, Google metrics were allocated using daily country-level spend share derived from Meta and TikTok data.

For dates with no Meta or TikTok data (two cases), Google metrics were distributed evenly across countries as a fallback when no signal was available.

### Assumptions & Limitations
- Geographic allocation for Google Ads is a proxy method and does not represent true performance.
- In production scenarios, more stable distributions (e.g., multi-day or monthly averages) would be used to reduce volatility.
- Differences in source data structure and granularity may impact direct comparability across platforms.

### Data Validation
- Allocation weights were validated to ensure daily shares sum to 1
- Total Google metrics reconcile before and after geographic allocation

## Output
The final output is a unified, daily dataset at the country level, with standardized metrics across platforms (clicks, impressions, cost), suitable for use as input into marketing mix models.