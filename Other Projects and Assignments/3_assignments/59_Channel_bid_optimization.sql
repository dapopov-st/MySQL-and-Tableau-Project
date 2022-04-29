-- 59. Cross-channel bid optimization
-- created_at >'2012-08-22' AND created_at <'2012-09-18', nonbrand
-- Conversion rates from session to order, slice by device type
-- device_type, utm_source, sessions, orders, conv_rate

SELECT
    website_sessions.device_type,
    website_sessions.utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) as "sessions",
    COUNT(DISTINCT orders.order_id) as 'orders',
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) as 'conv_rate'
FROM website_sessions
LEFT JOIN orders
    ON website_sessions.website_session_id=orders.website_session_id
WHERE website_sessions.created_at >'2012-08-22' AND website_sessions.created_at <'2012-09-19'
AND website_sessions.utm_campaign =  'nonbrand' AND website_sessions.utm_source IN ('bsearch','gsearch')
GROUP BY 1,2
;

-- +-------------+------------+----------+--------+-----------+
-- | device_type | utm_source | sessions | orders | conv_rate |
-- +-------------+------------+----------+--------+-----------+
-- | desktop     | bsearch    |     1161 |     44 |    0.0379 |
-- | desktop     | gsearch    |     3010 |    135 |    0.0449 |
-- | mobile      | bsearch    |      130 |      1 |    0.0077 |
-- | mobile      | gsearch    |     1017 |     13 |    0.0128 |
-- +-------------+------------+----------+--------+-----------+