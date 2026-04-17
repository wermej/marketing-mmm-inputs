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