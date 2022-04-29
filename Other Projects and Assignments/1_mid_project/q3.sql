-- 3. Monthly trends for sessions and orders for gsearch  split by device type for nonbrand

USE mavenfuzzyfactory;
SELECT YEAR(website_sessions.created_at) AS yr,
       MONTH(website_sessions.created_at) AS mn,
       COUNT(DISTINCT CASE WHEN website_sessions.device_type='mobile' THEN order_id ELSE NULL END) as mobile_ordrs_for_wk,
       COUNT(DISTINCT CASE WHEN website_sessions.device_type='desktop' THEN order_id ELSE NULL END) as dsktop_ordrs_for_wk,
       -- COUNT(DISTINCT orders.order_id) AS total_ordrs_for_week,
       COUNT(DISTINCT CASE WHEN website_sessions.device_type='mobile' THEN website_sessions.website_session_id ELSE NULL END) as mobile_sessions_for_wk,
       COUNT(DISTINCT CASE WHEN website_sessions.device_type='desktop' THEN website_sessions.website_session_id ELSE NULL END) as dsktop_sessions_for_wk
       -- COUNT(DISTINCT website_sessions.website_session_id) AS total_sessions_for_wk
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.utm_source = 'gsearch' AND
    website_sessions.utm_campaign='nonbrand' AND
    (website_sessions.created_at > '2012-03-19' AND website_sessions.created_at < '2012-11-27')
GROUP BY 1,2
;