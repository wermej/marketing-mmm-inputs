-- File: model_input.daily_dist_qa.sql
-- Purpose: Validate integrity of final dataset
-- Input: model_input.daily_dist_nov2024
-- Notes: Confirms totals reconcile and allocation logic preserves overall metrics

-- GOOGLE
with clicks as (
	select date, avg(clicks) as avg_clicks
	from google_ads.master_table_date_fix
	where clicks is not null
	group by 1
), impressions as (
	select date, avg(impressions) as avg_imps
	from google_ads.master_table_date_fix
	where impressions is not null
	group by 1
), cost_cte as (
	select date, avg(cost) as avg_cost
	from google_ads.master_table_date_fix
	where cost is not null
	group by 1
), base as (
	select mt.date
		, case 
			when mt.clicks is null then c.avg_clicks
			else mt.clicks
			end as clicks
		, case
			when mt.impressions is null then i.avg_imps
			else mt.impressions
			end as impressions
		, case
			when mt.cost is null then cc.avg_cost
			else mt.cost
			end as cost
	from google_ads.master_table_date_fix mt
	left join clicks c on mt.date = c.date
	left join impressions i on mt.date = i.date
	left join cost_cte cc on mt.date = cc.date
)
select 'original' as source, min(date) as date_min, max(date) as date_max
	, round(sum(coalesce(clicks,0))::numeric,0) as clicks
	, round(sum(coalesce(impressions,0))::numeric,0) as imps 
	, round(sum(coalesce(cost,0))::numeric,0) as cost
	from base
union all
select 'view', min(date) as date_min, max(date) as date_max
	, round(sum(clicks_ggl_desktop)+sum(clicks_ggl_mobile)+sum(clicks_ggl_tablet),0)
	, round(sum(imps_ggl_desktop)+sum(imps_ggl_mobile)+sum(imps_ggl_tablet),0)
	, round(sum(cost_ggl_desktop)+sum(cost_ggl_mobile)+sum(cost_ggl_tablet),0)
from model_input.daily_dist_nov2024
  -- source     date_min	date_max	clicks	imps	    cost
  -- original	2024-11-01	2024-11-30	361278	11761083	559216
  -- view	    2024-11-01	2024-11-30	361215	11761057	559216

-- META
select 'original' as source, min(date) as date_min, max(date) as date_max
	, sum(coalesce(clicks,0)) as clicks, sum(coalesce(impressions,0)) as imps
	, sum(coalesce(ad_spend,0)) as cost
from facebook_ads.master_table
union all
select 'view', min(date) as date_min, max(date) as date_max
	, round(sum(clicks_meta_display)+sum(clicks_meta_shopping)+sum(clicks_meta_search)+sum(clicks_meta_video),0)
	, round(sum(imps_meta_display)+sum(imps_meta_shopping)+sum(imps_meta_search)+sum(imps_meta_video),0)
	, round(sum(cost_meta_display)+sum(cost_meta_shopping)+sum(cost_meta_search)+sum(cost_meta_video),2)
from model_input.daily_dist_nov2024
  -- source	    date_min	date_max	clicks	imps	cost
  -- original	2024-11-02	2024-11-29	123855	4894382	184041.45
  -- view	    2024-11-01	2024-11-30	123855	4894382	184041.45

-- TIKTOK
select 'original' as source, min(date) as date_min, max(date) as date_max
	, sum(coalesce(clicks,0)) as clicks, sum(coalesce(impressions,0)) as imps
	, sum(coalesce(ad_spend,0)) as cost
from tiktok_ads.master_table
union all
select 'view', min(date) as date_min, max(date) as date_max
	, round(sum(clicks_ttk_display)+sum(clicks_ttk_shopping)+sum(clicks_ttk_search)+sum(clicks_ttk_video),0)
	, round(sum(imps_ttk_display)+sum(imps_ttk_shopping)+sum(imps_ttk_search)+sum(imps_ttk_video),0)
	, round(sum(cost_ttk_display)+sum(cost_ttk_shopping)+sum(cost_ttk_search)+sum(cost_ttk_video),2)
from model_input.daily_dist_nov2024
  -- source	    date_min	date_max	clicks	imps	cost
  -- original	2024-11-01	2024-11-30	193892  3267793 206298.37
  -- view	    2024-11-01	2024-11-30	193892  3267793 206298.37