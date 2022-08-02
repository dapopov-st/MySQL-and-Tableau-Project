-- 4. Monthly trends for gsearch traffic (not orders) alongside other channels
-- Note: When utm_source, utm_campaign, and http_referer are null, it's direct type-in traffic
-- When utm_source and utm_campaign are null but http_referer is not, it's organic search traffic
USE mavenfuzzyfactory;
SELECT YEAR(website_sessions.created_at) AS yr,
       MONTH(website_sessions.created_at) AS mn,
       COUNT(DISTINCT CASE WHEN website_sessions.utm_source='gsearch' THEN website_sessions.website_session_id ELSE NULL END) as gsearch_sessions_paid,
       COUNT(DISTINCT CASE WHEN website_sessions.utm_source='bsearch' THEN website_sessions.website_session_id ELSE NULL END) as bsearch_sessions_paid,
       COUNT(DISTINCT CASE WHEN website_sessions.utm_source is NULL AND website_sessions.utm_campaign is NULL AND website_sessions.http_referer is NULL THEN website_sessions.website_session_id ELSE NULL END) as direct_search,
       COUNT(DISTINCT CASE WHEN website_sessions.utm_source is NULL AND website_sessions.utm_campaign is NULL AND website_sessions.http_referer is NOT NULL THEN website_sessions.website_session_id ELSE NULL END) as organic_search
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE -- website_sessions.utm_source = 'gsearch' AND
    (website_sessions.created_at > '2012-03-19' AND website_sessions.created_at < '2012-11-27')
GROUP BY 1,2
;

