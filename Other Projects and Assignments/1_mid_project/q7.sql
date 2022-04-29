-- 7. For the landing page test, show a full conversion funnel from pages to orders (Use Jun 19-Jul 28)

USE mavenfuzzyfactory;

-- i.) Find out when /lander-1 was first launched for gsearch+nonbrand
-- ii.) Find out when /home was stopped for gsearch+nonbrand
-- iii.) Compute conv rates for the period of time when /home and /lander-1 were jointly operated
-- iv.) Count the number of sessions since /home was stopped (/lander-1 was the only one in operation)
-- v.) Multiply the difference in conv. rates from iii.) by the number of sessions from iv.)




DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT 
    website_sessions.website_session_id,
    -- website_pageviews.pageview_url,
    MIN(website_pageviews.website_pageview_id) AS first_pageview_id
FROM website_sessions
LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at > '2012-06-18' AND website_sessions.created_at < '2012-07-28'
    AND website_sessions.utm_source='gsearch' AND website_sessions.utm_campaign='nonbrand'
GROUP BY 1;


-- BRING IN THE URLs
DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT 
    temp1.website_session_id,
    -- MIN(website_pageviews.pageview_url) AS first_url,
    website_pageviews.pageview_url,
    website_pageviews.created_at,
    temp1.first_pageview_id
FROM temp1
LEFT JOIN website_pageviews
    ON temp1.website_session_id = website_pageviews.website_session_id
;
-- GROUP BY 1,3;

-- Get session id's that started at /home
DROP TABLE IF EXISTS temp3_home;
CREATE TEMPORARY TABLE temp3_home
SELECT 
    temp2.website_session_id,
    temp2.first_pageview_id
FROM
    temp2
WHERE temp2.pageview_url='/home'
;

DROP TABLE IF EXISTS temp3_lander1;
CREATE TEMPORARY TABLE temp3_lander1
SELECT 
    temp2.website_session_id,
    temp2.first_pageview_id
FROM
    temp2
WHERE temp2.pageview_url='/lander-1'
;

-- Add more pages
SELECT DISTINCT pageview_url FROM website_pageviews;


DROP TABLE IF EXISTS temp4_home;
CREATE TEMPORARY TABLE temp4_home
SELECT 
    temp3_home.website_session_id,
    temp3_home.first_pageview_id,
    website_pageviews.pageview_url
FROM temp3_home
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = temp3_home.website_session_id
WHERE website_pageviews.pageview_url 
IN ('/home', '/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/thank-you-for-your-order')
;


DROP TABLE IF EXISTS temp4_lander1;
CREATE TEMPORARY TABLE temp4_lander1
SELECT 
    temp3_lander1.website_session_id,
    temp3_lander1.first_pageview_id,
    website_pageviews.pageview_url
FROM temp3_lander1
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = temp3_lander1.website_session_id
WHERE website_pageviews.pageview_url 
IN ('/lander-1', '/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/thank-you-for-your-order')
;


-- Analyze conversion funnel from /home to /thank-you-for-your-order
SELECT
    COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/products' THEN temp4_home.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/home' THEN temp4_home.website_session_id ELSE NULL END) AS products_cvr,
    COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/the-original-mr-fuzzy' THEN temp4_home.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/products' THEN temp4_home.website_session_id ELSE NULL END) AS fuzzy_cvr,
    COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/cart' THEN temp4_home.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/the-original-mr-fuzzy' THEN temp4_home.website_session_id ELSE NULL END) AS cart_cvr,
    COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/shipping' THEN temp4_home.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/cart' THEN temp4_home.website_session_id ELSE NULL END) AS shipping_cvr,
    COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/billing' THEN temp4_home.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/shipping' THEN temp4_home.website_session_id ELSE NULL END) AS billing_cvr,
    COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/thank-you-for-your-order' THEN temp4_home.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_home.pageview_url='/billing' THEN temp4_home.website_session_id ELSE NULL END) AS thankyou_cvr
FROM temp4_home
;

-- Analyze conversion funnel from /lander-1 to /thank-you-for-your-order
SELECT
    COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/products' THEN temp4_lander1.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/lander-1' THEN temp4_lander1.website_session_id ELSE NULL END) AS products_cvr,
    COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/the-original-mr-fuzzy' THEN temp4_lander1.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/products' THEN temp4_lander1.website_session_id ELSE NULL END) AS fuzzy_cvr,
    COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/cart' THEN temp4_lander1.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/the-original-mr-fuzzy' THEN temp4_lander1.website_session_id ELSE NULL END) AS cart_cvr,
    COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/shipping' THEN temp4_lander1.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/cart' THEN temp4_lander1.website_session_id ELSE NULL END) AS shipping_cvr,
    COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/billing' THEN temp4_lander1.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/shipping' THEN temp4_lander1.website_session_id ELSE NULL END) AS billing_cvr,
    COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/thank-you-for-your-order' THEN temp4_lander1.website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN temp4_lander1.pageview_url='/billing' THEN temp4_lander1.website_session_id ELSE NULL END) AS thankyou_cvr
FROM temp4_lander1
;

-- Home cvrs
-- +--------------+-----------+----------+--------------+-------------+--------------+
-- | products_cvr | fuzzy_cvr | cart_cvr | shipping_cvr | billing_cvr | thankyou_cvr |
-- +--------------+-----------+----------+--------------+-------------+--------------+
-- |       0.4194 |    0.7277 |   0.4333 |       0.6762 |      0.8404 |       0.4358 |
-- +--------------+-----------+----------+--------------+-------------+--------------+
-- Lander-1 cvrs
-- +--------------+-----------+----------+--------------+-------------+--------------+
-- | products_cvr | fuzzy_cvr | cart_cvr | shipping_cvr | billing_cvr | thankyou_cvr |
-- +--------------+-----------+----------+--------------+-------------+--------------+
-- |       0.4676 |    0.7135 |   0.4508 |       0.6638 |      0.8528 |       0.4772 |
-- +--------------+-----------+----------+--------------+-------------+--------------+
-- iii.

-- TODO: Add counts
DROP TABLE IF EXISTS temp4;
CREATE TEMPORARY TABLE temp4
SELECT 
    temp3.pageview_url,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT temp3.website_session_id) as cvr,
    COUNT(DISTINCT orders.order_id) as "tot_orders",
    COUNT(DISTINCT temp3.website_session_id) as "tot_sessions"
FROM temp3
LEFT JOIN orders
    ON orders.website_session_id = temp3.website_session_id
WHERE temp3.website_session_id >11682 AND temp3.website_session_id < 17145
GROUP BY 1
;

-- +--------------+--------+------------+--------------+
-- | pageview_url | cvr    | tot_orders | tot_sessions |
-- +--------------+--------+------------+--------------+
-- | /home        | 0.0319 |         72 |         2260 |
-- | /lander-1    | 0.0406 |         94 |         2314 |
-- +--------------+--------+------------+--------------+

-- /home phased out on gsearch nonbrand after 17145
SELECT 
    COUNT(DISTINCT website_sessions.website_session_id)
FROM website_sessions
WHERE 
    website_sessions.website_session_id > 17145
AND website_sessions.created_at < '2012-11-27'
AND website_sessions.utm_campaign='nonbrand'
AND website_sessions.utm_source='gsearch'
;

-- +-----------------------------------------------------+
-- | COUNT(DISTINCT website_sessions.website_session_id) |
-- +-----------------------------------------------------+
-- |                                               22972 |
-- +-----------------------------------------------------+



SELECT ((0.0406-0.0319)*22972);
-- +-------------------------+
-- | ((0.0406-0.0319)*22972) |
-- +-------------------------+
-- |                199.8564 |
-- +-------------------------+

-- There has been about 4 months since  2012-07-27 22:44:32 (last session was routed to /home)
-- Thus about 200/4 = 50 orders/month extra at $50/order => $2500 extra revenue/month

