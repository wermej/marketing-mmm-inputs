create or replace view model_input.facebook_ads as (
select date, country, campaign_type
		, sum(coalesce(clicks,0)) as clicks
		, sum(coalesce(impressions,0)) as impressions
		, sum(coalesce(ad_spend,0)) as cost
from facebook_ads.master_table
group by 1,2,3
order by 1 desc
);