-- File: daily_dist_nov2024.sql
-- Purpose: Create unified daily dataset across Google, Meta, and TikTok
-- Input: cleaned Google Ads data and platform datasets
-- Output: model_input.daily_dist_nov2024
-- Notes: Google data lacks geo; allocated using Meta/TikTok daily country spend share (proxy method)

create or replace view model_input.daily_dist_nov2024 as (
with base as (	
	select generate_series(
		'2024-11-01'::date
		, '2024-11-30'::date
		, interval '1 day'
	)::date as date
		, country
	from utility.country_table
), meta as (
	select b.date
		, b.country
		, f.campaign_type
		, sum(coalesce(f.clicks,0)) as clicks
		, sum(coalesce(f.impressions,0)) as impressions
		, sum(coalesce(f.cost,0)) as cost
	from base b
	left join model_input.facebook_ads f
	on b.date = f.date and b.country = f.country
	group by 1,2,3
), tiktok as (
		select b.date
		, b.country
		, t.campaign_type
		, sum(coalesce(t.clicks,0)) as clicks
		, sum(coalesce(t.impressions,0)) as impressions
		, sum(coalesce(t.cost,0)) as cost
	from base b
	left join model_input.tiktok_ads t
	on b.date = t.date and b.country = t.country
	group by 1,2,3
), share_base as (
select b.date
		, b.country
		, sum(coalesce(f.cost,0)+coalesce(t.cost,0)) as country_cost
	from base b
	left join model_input.facebook_ads f on b.date = f.date and b.country = f.country
	left join model_input.tiktok_ads t	on b.date = t.date and b.country = t.country
	group by 1,2
	order by 1 desc
), daily as (
	select date
		, sum(country_cost) as daily_cost
	from share_base
	group by 1
), country_share as (
	select sb.date
		, sb.country
		, d.daily_cost
		, case when d.daily_cost = 0 then 1.0/count(*) over (partition by sb.date)
			else sb.country_cost / nullif(d.daily_cost,0) 
		  end as country_pct
	from share_base sb
	left join daily d on sb.date = d.date
), google as (
	select b.date
		, b.country
		, g.device
		, sum(coalesce(g.clicks,0) * coalesce(cs.country_pct,0)) as clicks
		, sum(coalesce(g.impressions,0) * coalesce(cs.country_pct,0)) as impressions
		, sum(coalesce(g.cost,0) * coalesce(cs.country_pct,0)) as cost
	from base b
	left join model_input.google_ads g 
	on b.date = g.date
	left join country_share cs
	on b.date = cs.date and b.country = cs.country
	group by 1,2,3
)
select b.date
	, b.country
	-- META
	, sum(coalesce(fdis.clicks,0)) as clicks_meta_display
	, sum(coalesce(fdis.impressions,0)) as imps_meta_display
	, sum(coalesce(fdis.cost,0)) as cost_meta_display
	, sum(coalesce(fsho.clicks,0)) as clicks_meta_shopping
	, sum(coalesce(fsho.impressions,0)) as imps_meta_shopping
	, sum(coalesce(fsho.cost,0)) as cost_meta_shopping
	, sum(coalesce(fsrc.clicks,0)) as clicks_meta_search
	, sum(coalesce(fsrc.impressions,0)) as imps_meta_search
	, sum(coalesce(fsrc.cost,0)) as cost_meta_search
	, sum(coalesce(fvid.clicks,0)) as clicks_meta_video
	, sum(coalesce(fvid.impressions,0)) as imps_meta_video
	, sum(coalesce(fvid.cost,0)) as cost_meta_video
	-- TIKTOK
	, sum(coalesce(tdis.clicks,0)) as clicks_ttk_display
	, sum(coalesce(tdis.impressions,0)) as imps_ttk_display
	, sum(coalesce(tdis.cost,0)) as cost_ttk_display
	, sum(coalesce(tsho.clicks,0)) as clicks_ttk_shopping
	, sum(coalesce(tsho.impressions,0)) as imps_ttk_shopping
	, sum(coalesce(tsho.cost,0)) as cost_ttk_shopping
	, sum(coalesce(tsrc.clicks,0)) as clicks_ttk_search
	, sum(coalesce(tsrc.impressions,0)) as imps_ttk_search
	, sum(coalesce(tsrc.cost,0)) as cost_ttk_search
	, sum(coalesce(tvid.clicks,0)) as clicks_ttk_video
	, sum(coalesce(tvid.impressions,0)) as imps_ttk_video
	, sum(coalesce(tvid.cost,0)) as cost_ttk_video
	-- GOOGLE
	, sum(coalesce(gdtp.clicks,0)) as clicks_ggl_desktop
	, sum(coalesce(gdtp.impressions,0)) as imps_ggl_desktop
	, sum(coalesce(gdtp.cost,0)) as cost_ggl_desktop
	, sum(coalesce(gmob.clicks,0)) as clicks_ggl_mobile
	, sum(coalesce(gmob.impressions,0)) as imps_ggl_mobile
	, sum(coalesce(gmob.cost,0)) as cost_ggl_mobile
	, sum(coalesce(gtab.clicks,0)) as clicks_ggl_tablet
	, sum(coalesce(gtab.impressions,0)) as imps_ggl_tablet
	, sum(coalesce(gtab.cost,0)) as cost_ggl_tablet
from base b

left join meta fdis on b.date = fdis.date and b.country = fdis.country and fdis.campaign_type = 'Display'
left join meta fsho on b.date = fsho.date and b.country = fsho.country and fsho.campaign_type = 'Shopping'
left join meta fsrc on b.date = fsrc.date and b.country = fsrc.country and fsrc.campaign_type = 'Search'
left join meta fvid on b.date = fvid.date and b.country = fvid.country and fvid.campaign_type = 'Video'

left join tiktok tdis on b.date = tdis.date and b.country = tdis.country and tdis.campaign_type = 'Display'
left join tiktok tsho on b.date = tsho.date and b.country = tsho.country and tsho.campaign_type = 'Shopping'
left join tiktok tsrc on b.date = tsrc.date and b.country = tsrc.country and tsrc.campaign_type = 'Search'
left join tiktok tvid on b.date = tvid.date and b.country = tvid.country and tvid.campaign_type = 'Video'

left join google gdtp on b.date = gdtp.date and b.country = gdtp.country and gdtp.device = 'desktop'
left join google gmob on b.date = gmob.date and b.country = gmob.country and gmob.device = 'mobile'
left join google gtab on b.date = gtab.date and b.country = gtab.country and gtab.device = 'tablet'
group by 1,2
order by 1 desc, 2
);