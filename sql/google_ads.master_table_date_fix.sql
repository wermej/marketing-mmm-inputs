create or replace view google_ads.master_table_date_fix as (
WITH cleaned AS (
    SELECT *
        , REPLACE(ad_date, '/', '-') AS val
        , SPLIT_PART(REPLACE(ad_date, '/', '-'), '-', 1)::int AS p1
        , SPLIT_PART(REPLACE(ad_date, '/', '-'), '-', 2)::int AS p2
        , SPLIT_PART(REPLACE(ad_date, '/', '-'), '-', 3)::int AS p3
    FROM google_ads.master_table
)
SELECT
    CASE
        -- 11 is month in first position → MM-DD-YYYY
        WHEN p1 = 11 THEN TO_DATE(val, 'MM-DD-YYYY')

        -- 11 is month in second position → DD-MM-YYYY
        WHEN p2 = 11 THEN TO_DATE(val, 'DD-MM-YYYY')

        -- fallback (optional)
        ELSE NULL
    END AS date
	, campaign_name
	, clicks
	, impressions
	, cost
	, leads
	, conversions
	, conversion_rate
	, sale_amount
	, location
	, trim(lower(device)) as device
	, keyword
FROM cleaned
order by 1 desc
);