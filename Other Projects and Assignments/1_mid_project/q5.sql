-- Session to order conversion rates by month for the first 8 months
USE mavenfuzzyfactory;
SELECT
    YEAR(website_sessions.created_at) as yr,
    MONTH(website_sessions.created_at) as mn,
    COUNT(CASE WHEN orders.order_id IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END)/COUNT(website_sessions.website_session_id) as session_to_order_conv_rate

FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id =  website_sessions.website_session_id
WHERE  (website_sessions.created_at > '2012-03-19' AND website_sessions.created_at < '2012-11-27')
GROUP BY 1,2
; -- notice if change second date to 2013, will see a clear upward trend


-- Version 2: Notice that since we have left join, do not need the CASE WHEN
SELECT
    YEAR(website_sessions.created_at) as yr,
    MONTH(website_sessions.created_at) as mn,
    COUNT(orders.order_id)/COUNT(website_sessions.website_session_id) as session_to_order_conv_rate

FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id =  website_sessions.website_session_id
WHERE  (website_sessions.created_at > '2012-03-19' AND website_sessions.created_at < '2012-11-27')
GROUP BY 1,2
; 

