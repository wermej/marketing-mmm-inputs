-- File: google_ads.master_table.sql
-- Purpose: Create base table from raw Google Ads CSV
-- Input: data/GoogleAds_DataAnalytics_Sales_Uncleaned.csv
-- Output: google_ads.master_table
-- Notes: Represents raw ingestion step prior to cleaning and transformation

CREATE TABLE IF NOT EXISTS google_ads.master_table
(
    ad_id text COLLATE pg_catalog."default",
    campaign_name text COLLATE pg_catalog."default",
    clicks integer,
    impressions integer,
    cost numeric,
    leads integer,
    conversions integer,
    conversion_rate numeric,
    sale_amount numeric,
    ad_date text COLLATE pg_catalog."default",
    location text COLLATE pg_catalog."default",
    device text COLLATE pg_catalog."default",
    keyword text COLLATE pg_catalog."default"
)
