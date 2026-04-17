-- Initial Data Exploration: Google Ads Dataset

-- Objective:
-- Evaluate data quality, understand metric definitions, and identify fields requiring transformation
-- before building model-ready inputs.

-- Dataset:
-- google_ads.master_table

-- Key Fields:
-- ad_id
-- campaign_name
-- clicks
-- impressions
-- cost
-- leads
-- conversions
-- conversion_rate
-- sale_amount
-- ad_date
-- location
-- device
-- keyword

-- Observations:

-- 1. Conversion rate is inconsistent
--    - Does not reliably equal conversions / clicks
--    - Present even when base metrics are null
--    → Treated as unreliable and not included

-- 2. Leads and conversions lack clear definitions
--    - Relationship between fields is unclear
--    - Not used as core metrics in final dataset

-- 3. Campaign and keyword fields are inconsistent
--    - Variations, misspellings, and low differentiation
--    → Not used for segmentation

-- 4. Device field is consistent and usable
--    → Retained as a key dimension

-- 5. Missing values present in core metrics
--    - clicks, impressions, cost
--    → Addressed via daily average imputation

-- Outcome:
-- Focused final dataset on:
-- - date
-- - device
-- - clicks, impressions, cost
-- Removed unreliable or low-signal fields


-- Data Assessment: Meta & TikTok Dataset

-- Objective:
-- Evaluate suitability for multi-source integration and geographic analysis

-- Observations:

-- 1. No significant missing values in core metrics
--    - clicks, impressions, cost are complete

-- 2. Includes geographic dimension (country)
--    → Used as basis for cross-platform alignment

-- 3. Campaign_type provides consistent segmentation
--    → Retained for breakdowns (Display, Search, etc.)

-- 4. Schema is consistent across platforms
--    → Enables straightforward splitting by source

-- Outcome:
-- Dataset used primarily for:
-- - multi-source integration
-- - geographic allocation (proxy for Google Ads)
-- Minimal cleaning required