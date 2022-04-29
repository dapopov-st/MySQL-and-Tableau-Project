-- 6. Estimate the revenue earned by the gsearch lander test
-- 6. How much extra revenue was earned by billing-2

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
    MIN(website_pageviews.website_pageview_id) AS first_pageview_id
FROM website_sessions
LEFT JOIN website_pageviews
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at > '2012-09-10' AND website_sessions.created_at < '2012-11-10'
    -- AND website_sessions.utm_source='gsearch' AND website_sessions.utm_campaign='nonbrand'
GROUP BY 1;


-- BRING IN THE URLs
DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT 
    temp1.website_session_id,
    MIN(website_pageviews.pageview_url),
    temp1.first_pageview_id
FROM temp1
LEFT JOIN website_pageviews
    ON temp1.website_session_id = website_pageviews.website_session_id

GROUP BY 1,3;



DROP TABLE IF EXISTS temp3;
CREATE TEMPORARY TABLE temp3
SELECT 
    temp2.website_session_id,
    temp2.first_pageview_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at
FROM temp2
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = temp2.website_session_id
WHERE website_pageviews.pageview_url IN ('/billing','/billing-2')
;


-- iii.

-- TODO: Add counts
DROP TABLE IF EXISTS temp4;
CREATE TEMPORARY TABLE temp4
SELECT 
    temp3.pageview_url,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT temp3.website_session_id) as cvr,
    COUNT(DISTINCT orders.order_id) as "tot_orders",
    COUNT(DISTINCT temp3.website_session_id) as "tot_sessions",
    SUM(orders.price_usd)/COUNT(DISTINCT temp3.website_session_id) AS revenue_per_billing_page_seen
FROM temp3
LEFT JOIN orders
    ON orders.website_session_id = temp3.website_session_id
WHERE temp3.created_at > '2012-09-10' AND temp3.created_at < '2012-11-10'
GROUP BY 1
;
-- +--------------+--------+------------+--------------+-------------------------------+
-- | pageview_url | cvr    | tot_orders | tot_sessions | revenue_per_billing_page_seen |
-- +--------------+--------+------------+--------------+-------------------------------+
-- | /billing     | 0.4566 |        300 |          657 |                     22.826484 |
-- | /billing-2   | 0.6269 |        410 |          654 |                     31.339297 |
-- +--------------+--------+------------+--------------+-------------------------------+


-- select 31.339297 -22.826484;
-- +----------------------+
-- | 31.339297 -22.826484 |
-- +----------------------+
-- |             8.512813 |
-- +----------------------+

SELECT
    COUNT(website_session_id) as billing_sessions_past_month
FROM website_pageviews
WHERE website_pageviews.pageview_url IN ('/billing','/billing-2')
AND created_at BETWEEN '2012-10-27' AND '2012-11-27';

-- +-----------------------------+
-- | billing_sessions_past_month |
-- +-----------------------------+
-- |                        1194 |
-- +-----------------------------+

select 1194*8.512813;
-- +---------------+
-- | 1194*8.512813 |
-- +---------------+
-- |  10164.298722 |
-- +---------------+

-- About $10164.30 extra revenue past month
