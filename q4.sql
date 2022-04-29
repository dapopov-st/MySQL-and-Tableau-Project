SELECT
    YEAR(website_sessions.created_at) AS 'year',
    QUARTER(website_sessions.created_at) AS 'quarter',
    COUNT(CASE WHEN website_sessions.http_referer IS NULL AND website_sessions.utm_source IS NULL THEN orders.order_id ELSE NULL END)/COUNT(CASE WHEN website_sessions.http_referer IS NULL AND website_sessions.utm_source IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS "direct_type_in_cvr",
    COUNT(CASE WHEN website_sessions.http_referer IS NOT NULL AND website_sessions.utm_source IS NULL THEN orders.order_id ELSE NULL END)/COUNT(CASE WHEN website_sessions.http_referer IS NOT NULL AND website_sessions.utm_source IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS "organic_cvr",
    COUNT(CASE WHEN website_sessions.utm_source='gsearch' AND website_sessions.utm_campaign='nonbrand'THEN orders.order_id ELSE NULL END)/COUNT(CASE WHEN website_sessions.utm_source='gsearch' AND website_sessions.utm_campaign='nonbrand'THEN website_sessions.website_session_id ELSE NULL END) AS "gsearch_nonbrand_cvr",
    COUNT(CASE WHEN website_sessions.utm_source='bsearch' AND website_sessions.utm_campaign='nonbrand'THEN orders.order_id ELSE NULL END)/COUNT(CASE WHEN website_sessions.utm_source='bsearch' AND website_sessions.utm_campaign='nonbrand'THEN website_sessions.website_session_id ELSE NULL END) AS "bsearch_nonbrand_cvr",
    COUNT(CASE WHEN website_sessions.utm_campaign='brand'THEN orders.order_id ELSE NULL END)/COUNT(CASE WHEN website_sessions.utm_campaign='brand'THEN website_sessions.website_session_id ELSE NULL END) AS "brand_overall_cvr"
FROM 
    website_sessions
LEFT JOIN 
    orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2015-03-20'
GROUP BY 1,2
;

-- +------+---------+--------------------+-------------+----------------------+----------------------+-------------------+
-- | year | quarter | direct_type_in_cvr | organic_cvr | gsearch_nonbrand_cvr | bsearch_nonbrand_cvr | brand_overall_cvr |
-- +------+---------+--------------------+-------------+----------------------+----------------------+-------------------+
-- | 2012 |       1 |             0.0000 |      0.0000 |               0.0323 |                 NULL |            0.0000 |
-- | 2012 |       2 |             0.0536 |      0.0359 |               0.0284 |                 NULL |            0.0526 |
-- | 2012 |       3 |             0.0443 |      0.0498 |               0.0383 |               0.0408 |            0.0602 |
-- | 2012 |       4 |             0.0537 |      0.0539 |               0.0436 |               0.0497 |            0.0531 |
-- | 2013 |       1 |             0.0614 |      0.0751 |               0.0612 |               0.0692 |            0.0703 |
-- | 2013 |       2 |             0.0736 |      0.0760 |               0.0685 |               0.0693 |            0.0679 |
-- | 2013 |       3 |             0.0719 |      0.0734 |               0.0640 |               0.0694 |            0.0703 |
-- | 2013 |       4 |             0.0646 |      0.0697 |               0.0629 |               0.0600 |            0.0804 |
-- | 2014 |       1 |             0.0765 |      0.0754 |               0.0694 |               0.0704 |            0.0837 |
-- | 2014 |       2 |             0.0738 |      0.0799 |               0.0702 |               0.0695 |            0.0805 |
-- | 2014 |       3 |             0.0702 |      0.0731 |               0.0703 |               0.0698 |            0.0755 |
-- | 2014 |       4 |             0.0747 |      0.0783 |               0.0782 |               0.0844 |            0.0813 |
-- | 2015 |       1 |             0.0776 |      0.0822 |               0.0861 |               0.0847 |            0.0851 |
-- +------+---------+--------------------+-------------+----------------------+----------------------+-------------------+