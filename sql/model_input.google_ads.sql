-- File: model_input.google_ads.sql
-- Purpose: Clean and standardize Google Ads dataset
-- Input: google_ads.master_table_date_fix
-- Output: model_input.google_ads
-- Notes: Missing values imputed using daily averages; unreliable fields excluded

create or replace view model_input.google_ads as (
-- find avg metrics by date, device for imputation
with clicks as (
	select date, device
		, avg(clicks) as avg_clicks
	from google_ads.master_table_date_fix
	where clicks is not null
	group by 1,2
), impressions as (
	select date, device
		, avg(impressions) as avg_imps
	from google_ads.master_table_date_fix
	where impressions is not null
	group by 1,2
), cost_cte as (
	select date, device
		, avg(cost) as avg_cost
	from google_ads.master_table_date_fix
	where cost is not null
	group by 1,2
), base as (
	select mt.date, mt.device
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
	left join clicks c on mt.date = c.date and mt.device = c.device
	left join impressions i on mt.date = i.date and mt.device = i.device
	left join cost_cte cc on mt.date = cc.date and mt.device = cc.device
)
select date, device
	, round(sum(clicks)::numeric,2) as clicks
	, round(sum(impressions)::numeric,2) as impressions
	, round(sum(cost)::numeric,2) as cost
from base
group by 1,2
order by 1 desc,2
);