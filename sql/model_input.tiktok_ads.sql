-- File: model_input.tiktok_ads.sql
-- Purpose: Create standardized TikTok dataset
-- Input: data/global_ads_performance_dataset.csv
-- Output: model_input.tiktok_ads
-- Notes: Aggregated by date and country; aligned to unified schema

create or replace view model_input.tiktok_ads as (
select date, country, campaign_type
		, sum(coalesce(clicks,0)) as clicks
		, sum(coalesce(impressions,0)) as impressions
		, sum(coalesce(ad_spend,0)) as cost
from tiktok_ads.master_table
group by 1,2,3
order by 1 desc
);