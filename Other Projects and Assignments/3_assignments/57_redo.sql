SELECT
    utm_source,
    COUNT(DISTINCT website_session_id) as 'sessions',
    COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END) as 'mobile_sessions',
    COUNT(DISTINCT CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END)*100/
    COUNT(DISTINCT website_session_id) as 'pct_mobile'
FROM website_sessions
WHERE utm_campaign='nonbrand' AND created_at >'2012-08-22' AND created_at <'2012-11-30'
GROUP BY 1
;