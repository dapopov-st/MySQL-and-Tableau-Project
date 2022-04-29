-- Weekly trended session volume for gsearch nonbrand and bsearch
-- 2012-08-22 AND 2012-11-29

SELECT
    MIN(DATE(created_at)) AS 'week_start_date',
    COUNT(CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS 'gsearch_sessions',
    COUNT(CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS 'bsearch_sessions'
FROM website_sessions

WHERE created_at BETWEEN '2012-08-22' AND '2012-11-29'
GROUP BY YEARWEEK(created_at)
;