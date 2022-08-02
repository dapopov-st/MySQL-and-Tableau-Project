-- 59 Comparing channel characteristics
-- created_at >'2012-08-22' AND created_at <'2012-11-30', nonbrand
-- utm_source, sessions, mobile_sessions, pct_mobile

SELECT
    utm_source,
    COUNT(DISTINCT website_session_id) as "sessions",
    COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END) as "mobile_sessions",
    COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id)  as "pct_mobile"
FROM
    website_sessions
WHERE created_at >'2012-08-22' AND created_at <'2012-11-30' AND
    utm_campaign='nonbrand' AND
    utm_source IN ('gsearch','bsearch')
GROUP BY 1
;

-- +------------+----------+-----------------+------------+
-- | utm_source | sessions | mobile_sessions | pct_mobile |
-- +------------+----------+-----------------+------------+
-- | bsearch    |     6522 |             562 |     0.0862 |
-- | gsearch    |    20079 |            4923 |     0.2452 |
-- +------------+----------+-----------------+------------+