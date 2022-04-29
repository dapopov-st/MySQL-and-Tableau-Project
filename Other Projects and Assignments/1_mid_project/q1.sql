-- 1. Monthly trends for gsearch sessions and orders
USE mavenfuzzyfactory;
SELECT YEAR(website_sessions.created_at) AS yr,
       MONTH(website_sessions.created_at) AS mn,
       COUNT(DISTINCT orders.order_id) AS orders_for_week,
       COUNT(DISTINCT website_sessions.website_session_id) AS sessions_for_week
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.utm_source = 'gsearch' AND
    (website_sessions.created_at > '2012-03-19' AND website_sessions.created_at < '2012-11-27')
GROUP BY 1,2
;

-- 2. Monthly trends for gsearch sessions and orders, splitting out nonbrand and brand compaigns separately
SELECT YEAR(website_sessions.created_at) AS yr,
       MONTH(website_sessions.created_at) AS mn,
       COUNT(DISTINCT orders.order_id) AS orders_for_week,
       COUNT(DISTINCT website_sessions.website_session_id) AS sessions_for_week
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.utm_source = 'gsearch' AND
    (website_sessions.created_at > '2012-03-19' AND website_sessions.created_at < '2012-11-27')
GROUP BY 1,2
;




-- USE mavenfuzzyfactory;
-- SELECT MIN(DATE(orders.created_at)) AS week_start_date,
--         COUNT(DISTINCT orders.order_id) AS orders_for_week,
--         COUNT(DISTINCT website_sessions.website_session_id) AS sessions_for_week
-- FROM website_sessions
-- LEFT JOIN orders
-- ON orders.website_session_id = website_sessions.website_session_id
-- WHERE website_sessions.utm_source = 'gsearch' AND
--     (website_sessions.created_at > '2012-03-19' AND website_sessions.created_at < '2012-11-27')
-- GROUP BY YEARWEEK(orders.created_at);