-- 6. Estimate the revenue earned by the gsearch lander test
-- 6. How much extra revenue was earned by switching to lander-1

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
-- WHERE website_sessions.created_at < '2012-11-27'
WHERE website_sessions.created_at < '2012-07-28'
    AND website_sessions.utm_source='gsearch' AND website_sessions.utm_campaign='nonbrand'
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

-- Want min and max website SESSION ids!!!
SELECT 
    MIN(website_sessions.website_session_id)
FROM temp1
LEFT JOIN website_sessions
    ON website_sessions.website_session_id = temp1.website_session_id
LEFT JOIN website_pageviews
    ON website_pageviews.website_pageview_id = temp1.first_pageview_id
WHERE  website_pageviews.pageview_url='/lander-1'
;
-- 11683 (min session id!)

SELECT 
    MAX(website_sessions.website_session_id),
    MAX(website_sessions.created_at)
FROM temp1
LEFT JOIN website_sessions
    ON website_sessions.website_session_id = temp1.website_session_id
LEFT JOIN website_pageviews
    ON website_pageviews.website_pageview_id = temp1.first_pageview_id
WHERE  website_pageviews.pageview_url='/home'
;
-- 17145 (max session id!) at 2012-07-27 22:44:32  

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
WHERE website_pageviews.pageview_url IN ('/lander-1','/home')
;


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


