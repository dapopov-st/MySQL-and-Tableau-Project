SELECT
    YEAR(orders.created_at) AS 'year',
    QUARTER(orders.created_at) AS 'quarter',
    -- COUNT(DISTINCT orders.order_id),
    COUNT(CASE WHEN website_sessions.http_referer IS NULL AND website_sessions.utm_source IS NULL THEN orders.order_id ELSE NULL END) AS "direct_type_in",
    COUNT(CASE WHEN website_sessions.http_referer IS NOT NULL AND website_sessions.utm_source IS NULL THEN orders.order_id ELSE NULL END) AS "organic",
    COUNT(CASE WHEN website_sessions.utm_source='gsearch' AND website_sessions.utm_campaign='nonbrand'THEN orders.order_id ELSE NULL END) AS "gsearch_nonbrand",
    COUNT(CASE WHEN website_sessions.utm_source='bsearch' AND website_sessions.utm_campaign='nonbrand'THEN orders.order_id ELSE NULL END) AS "bsearch_nonbrand",
    COUNT(CASE WHEN website_sessions.utm_campaign='brand'THEN orders.order_id ELSE NULL END) AS "brand_overall"
FROM 
    orders
INNER JOIN 
    website_sessions
ON orders.website_session_id = website_sessions.website_session_id
WHERE orders.created_at < '2015-03-20'
GROUP BY 1,2
;