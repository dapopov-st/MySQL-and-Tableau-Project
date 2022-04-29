SELECT 
    device_type,
    utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) AS 'sessions',
    COUNT(DISTINCT orders.order_id) AS 'orders',
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS 'conversion_rate'
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE 
website_sessions.created_at >'2012-08-22' AND website_sessions.created_at <'2012-09-19' AND
website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1, 2
;