-- 61. Analyzing channel portfolio trends
-- Weekly session volume for gsearch and bsearch nonbrand broken down by device since Nov. 4
-- Include comparison metric to show bsearch as percent of gsearch

SELECT
    MIN(DATE(created_at)) as week_start_date,
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' AND device_type='desktop' THEN website_session_id ELSE NULL END) AS "g_dtop_sessions",
    COUNT(DISTINCT CASE WHEN utm_source='bsearch' AND device_type='desktop' THEN website_session_id ELSE NULL END) AS "b_dtop_sessions",
    COUNT(DISTINCT CASE WHEN utm_source='bsearch' AND device_type='desktop' THEN website_session_id ELSE NULL END)*100.0/
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' AND device_type='desktop' THEN website_session_id ELSE NULL END) AS "b_pct_of_g_dtop",
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' AND device_type='mobile' THEN website_session_id ELSE NULL END) AS "g_mob_sessions",
    COUNT(DISTINCT CASE WHEN utm_source='bsearch' AND device_type='mobile' THEN website_session_id ELSE NULL END) AS "b_mob_sessions",
    COUNT(DISTINCT CASE WHEN utm_source='bsearch' AND device_type='mobile' THEN website_session_id ELSE NULL END)*100.0/
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' AND device_type='mobile' THEN website_session_id ELSE NULL END) AS "b_pct_of_g_mob"
FROM
    website_sessions
WHERE
    created_at >'2012-11-03' AND created_at <'2012-12-22' 
    AND website_sessions.utm_campaign =  'nonbrand' AND website_sessions.utm_source IN ('bsearch','gsearch')
GROUP BY YEARWEEK(created_at)
;