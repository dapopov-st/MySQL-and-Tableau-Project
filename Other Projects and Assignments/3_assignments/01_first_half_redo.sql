USE mavenfuzzyfactory;
-- 21. Finding top traffic sources
SELECT
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id)
FROM website_sessions
WHERE website_sessions.created_at < '2012-04-12'
GROUP bY 1,2,3
ORDER BY 4 DESC;

-- +------------+--------------+-------------------------+------------------------------------+
-- | utm_source | utm_campaign | http_referer            | COUNT(DISTINCT website_session_id) |
-- +------------+--------------+-------------------------+------------------------------------+
-- | gsearch    | nonbrand     | https://www.gsearch.com |                               3611 |
-- | NULL       | NULL         | NULL                    |                                 28 |
-- | NULL       | NULL         | https://www.gsearch.com |                                 27 |
-- | gsearch    | brand        | https://www.gsearch.com |                                 26 |
-- | NULL       | NULL         | https://www.bsearch.com |                                  7 |
-- | bsearch    | brand        | https://www.bsearch.com |                                  7 |
-- +------------+--------------+-------------------------+------------------------------------+


-- 23. Traffic source conversion rates (from gsearch nonbrand sessions to orders)
SELECT
    COUNT(DISTINCT website_sessions.website_session_id) as sessions,
    COUNT(DISTINCT orders.order_id) as orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) as 'conversion rate'
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.utm_source='gsearch' AND website_sessions.utm_campaign='nonbrand'
AND website_sessions.created_at < '2012-04-14'
;

-- +----------+--------+-----------------+
-- | sessions | orders | conversion rate |
-- +----------+--------+-----------------+
-- |     3891 |    112 |          0.0288 |
-- +----------+--------+-----------------+

-- Video 25: For primary product ids 1-4, how many orders had 1/2 product(s) purchased

SELECT
    primary_product_id,
    COUNT(DISTINCT CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) as one_item_orders,
    COUNT(DISTINCT CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) as two_item_orders,
    COUNT(DISTINCT order_id) as total_orders
FROM
    orders
-- WHERE order_id BETWEEN 31000 AND 32000
GROUP BY 1;

-- Video 26: Traffic Source Trending: Bid down gsearch nonbrand on 2012-04-15, try to 
-- pull trended sessions by volume

SELECT
    MIN(DATE(created_at)),
    COUNT(DISTINCT website_session_id)
FROM
    website_sessions
WHERE created_at<'2012-05-10' AND created_at > '2012-03-19' 
    AND utm_source='gsearch' AND utm_campaign='nonbrand'
GROUP BY YEAR(created_at), WEEK(created_at);
-- Can do a group by even if don't have it in select statement, but be very careful with it

-- +-----------------------+------------------------------------+
-- | MIN(DATE(created_at)) | COUNT(DISTINCT website_session_id) |
-- +-----------------------+------------------------------------+
-- | 2012-03-19            |                                893 |
-- | 2012-03-25            |                                957 |
-- | 2012-04-01            |                               1147 |
-- | 2012-04-08            |                                988 |
-- | 2012-04-15            |                                622 |
-- | 2012-04-22            |                                592 |
-- | 2012-04-29            |                                681 |
-- | 2012-05-06            |                                401 |
-- +-----------------------+------------------------------------+


-- Conversion rates from session to order split by device type so that appropriate
-- bids can be placed at device type level
SELECT
    website_sessions.device_type,
    COUNT(DISTINCT website_sessions.website_session_id) as sessions,
    COUNT(DISTINCT orders.order_id) as orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
FROM
    website_sessions
LEFT JOIN
    orders
ON website_sessions.website_session_id=orders.website_session_id
WHERE website_sessions.created_at<'2012-05-11' 
    AND utm_source='gsearch' AND utm_campaign='nonbrand'
GROUP BY 1
;

-- +-------------+----------+--------+----------------------------+
-- | device_type | sessions | orders | session_to_order_conv_rate |
-- +-------------+----------+--------+----------------------------+
-- | desktop     |     3909 |    146 |                     0.0373 |
-- | mobile      |     2491 |     24 |                     0.0096 |
-- +-------------+----------+--------+----------------------------+

-- Conclusion: Mobile site is not up to par

-- 30 Trending W/ Granular Segments
SELECT
    MIN(DATE(website_sessions.created_at)) as week_start_date,
    COUNT(DISTINCT CASE WHEN website_sessions.device_type='desktop' THEN website_sessions.website_session_id ELSE NULL END) AS 'dtop_sessions',
    COUNT(DISTINCT CASE WHEN website_sessions.device_type='mobile' THEN website_sessions.website_session_id ELSE NULL END) AS 'mob_sessions',
    COUNT(DISTINCT website_sessions.website_session_id) as tot_sessions
    -- COUNT(DISTINCT website_sessions.website_session_id) as sessions,
    -- COUNT(DISTINCT orders.order_id) as orders,
    -- COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
FROM
    website_sessions
LEFT JOIN
    orders
ON website_sessions.website_session_id=orders.website_session_id
WHERE website_sessions.created_at<'2012-06-09' AND website_sessions.created_at>'2012-04-15'
    AND utm_source='gsearch' AND utm_campaign='nonbrand'
GROUP BY YEAR(website_sessions.created_at),WEEK(website_sessions.created_at)
;

-- 33. Finding Top Website Pages
DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT
    MIN(website_pageview_id) as min_pageview_id,
    website_session_id
FROM website_pageviews 
WHERE created_at < '2012-06-09'
GROUP BY 2;

DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT
    temp1.min_pageview_id,
    temp1.website_session_id,
    website_pageviews.pageview_url 
FROM temp1
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = temp1.website_session_id
;

SELECT 
    temp2.pageview_url,
    COUNT(DISTINCT temp2.min_pageview_id) as num_pageviews

FROM temp2
GROUP BY 1
ORDER BY 2 DESC
;

-- 33. Finding Top pageview urls done simply
SELECT
    pageview_url,
    COUNT(DISTINCT website_pageview_id)
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY 1
ORDER BY 2 DESC
;

-- 36. Finding Top Entry Pages
DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT
    MIN(website_pageview_id) as min_pageview_id,
    website_session_id
FROM website_pageviews 
WHERE created_at < '2012-06-12'
GROUP BY 2;

DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT
    temp1.min_pageview_id,
    temp1.website_session_id,
    website_pageviews.pageview_url 
FROM temp1
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = temp1.min_pageview_id
;

SELECT 
    temp2.pageview_url,
    COUNT(DISTINCT temp2.min_pageview_id) as num_pageviews

FROM temp2
GROUP BY 1
ORDER BY 2 DESC
;

-- +--------------+---------------+
-- | pageview_url | num_pageviews |
-- +--------------+---------------+
-- | /home        |         10711 |
-- +--------------+---------------+

-- 39. Calculating Bounce Rates

SELECT
    pageview_url,
    COUNT(DISTINCT website_pageview_id)
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY 1
ORDER BY 2 DESC
;

-- 36. Finding Top Entry Pages
-- First get the min pageview id using the two standard queries below
DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT
    MIN(website_pageview_id) as min_pageview_id,
    website_session_id
FROM website_pageviews 
WHERE created_at < '2012-06-14'
GROUP BY 2;

DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT
    temp1.min_pageview_id,
    temp1.website_session_id,
    website_pageviews.pageview_url 
FROM temp1
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = temp1.min_pageview_id
WHERE website_pageviews.pageview_url='/home'
;

-- Get all sessions with count of num_pageviews, 
-- careful to join on website_pageviews.website_session_id = temp2.website_session_id
DROP TABLE IF EXISTS all_sessions;
CREATE TEMPORARY TABLE all_sessions
SELECT
    temp2.website_session_id,
    temp2.pageview_url,
    COUNT(DISTINCT website_pageviews.website_pageview_id) as num_pageviews
FROM temp2
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = temp2.website_session_id 
GROUP BY 1,2;


-- Bounce rate (using different approach than the course: don't need HAVING in the above query)
SELECT 
    COUNT(DISTINCT CASE WHEN all_sessions.num_pageviews=1 
    THEN all_sessions.website_session_id ELSE NULL END)/COUNT(DISTINCT all_sessions.website_session_id)
    AS bounce_rate
FROM all_sessions
;

-- +-------------+
-- | bounce_rate |
-- +-------------+
-- |      0.5918 |
-- +-------------+
-- ON website_pageviews.website_pageview_id = temp2.min_pageview_id
--  THIS WAS THE DETERMINIG FACTOR ALLOWING COUNTS > 1 !!!
-- Because website_pageviews table is at a pageview level, we can have
-- one website session spanning multiple pageviews.  
-- If we join ON website_pageviews.website_session_id = temp2.website_session_id,
-- it will be one-to-one join, and we will always have a count of 1 for num_pageviews
-- WHERE temp2.pageview_url='/home' -- just in case, although not necessary here


-- 41. Analyzing Landing Page Tests (results of 50/50 test for /lander-1 against /home)

-- i.) Find out when /lander-1 started
-- ii.) Conduct tests as above, but with /home and /lander-1 in the specified range

SELECT
    MIN(created_at)
FROM website_pageviews
WHERE pageview_url='/lander-1';

-- +---------------------+
-- | MIN(created_at)     |
-- +---------------------+
-- | 2012-06-19 01:35:54 |
-- +---------------------+

DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT
    MIN(website_pageviews.website_pageview_id) as min_pageview_id,
    website_pageviews.website_session_id
FROM website_pageviews 
LEFT JOIN website_sessions
ON website_sessions.website_session_id=website_pageviews.website_session_id
WHERE website_pageviews.created_at < '2012-07-28' AND website_pageviews.created_at > '2012-06-19 01:35:54'
AND website_sessions.utm_campaign='nonbrand' AND website_sessions.utm_source='gsearch'
GROUP BY 2;

DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT
    temp1.min_pageview_id,
    temp1.website_session_id,
    website_pageviews.pageview_url 
FROM temp1
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = temp1.min_pageview_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1') 
;

DROP TABLE IF EXISTS all_sessions;
CREATE TEMPORARY TABLE all_sessions
SELECT 
    temp2.website_session_id,
    temp2.pageview_url, 
    COUNT(DISTINCT website_pageviews.website_pageview_id) AS num_pageviews
FROM temp2
LEFT JOIN website_pageviews
    ON website_pageviews.website_session_id = temp2.website_session_id
GROUP BY 1,2
;


SELECT 
    all_sessions.pageview_url as landing_page,
    COUNT(DISTINCT all_sessions.website_session_id) as total_sessions,
    COUNT(DISTINCT CASE WHEN all_sessions.num_pageviews=1
    THEN all_sessions.website_session_id ELSE NULL END) as bounced_sessions,
    COUNT(DISTINCT CASE WHEN all_sessions.num_pageviews=1
    THEN all_sessions.website_session_id ELSE NULL END)/COUNT(DISTINCT all_sessions.website_session_id)
    AS bounce_rate
FROM all_sessions
GROUP BY 1
;

-- +--------------+----------------+------------------+-------------+
-- | landing_page | total_sessions | bounced_sessions | bounce_rate |
-- +--------------+----------------+------------------+-------------+
-- | /home        |           2260 |             1319 |      0.5836 |
-- | /lander-1    |           2313 |             1231 |      0.5322 |
-- +--------------+----------------+------------------+-------------+

-- 43. Landing Page Trend Analysis: Weekly trends on /home and /lander-1 since June 1, 2012

-- Reuse the first three tables above after correcting for start and end dates
-- In the final table, group by week_start_date column. 
-- 2nd column is overall bounce rates, 3rd and 4th home and lander session counts

DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT
    MIN(website_pageviews.website_pageview_id) as min_pageview_id,
    website_pageviews.website_session_id
FROM website_pageviews 
LEFT JOIN website_sessions
ON website_sessions.website_session_id=website_pageviews.website_session_id
WHERE website_pageviews.created_at < '2012-08-31' AND website_pageviews.created_at >= '2012-06-01'
AND website_sessions.utm_campaign='nonbrand' AND website_sessions.utm_source='gsearch'
GROUP BY 2;

DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT
    temp1.min_pageview_id,
    temp1.website_session_id,
    website_pageviews.pageview_url 
FROM temp1
LEFT JOIN website_pageviews
ON website_pageviews.website_pageview_id = temp1.min_pageview_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1') 
;

DROP TABLE IF EXISTS all_sessions;
CREATE TEMPORARY TABLE all_sessions
SELECT 
    temp2.website_session_id,
    temp2.pageview_url, 
    COUNT(DISTINCT website_pageviews.website_pageview_id) AS num_pageviews
FROM temp2
LEFT JOIN website_pageviews
    ON website_pageviews.website_session_id = temp2.website_session_id
GROUP BY 1,2
;

SELECT
    MIN(DATE(website_pageviews.created_at)) as week_start_date,
    COUNT(DISTINCT CASE WHEN all_sessions.num_pageviews=1
    THEN all_sessions.website_session_id ELSE NULL END)/COUNT(DISTINCT all_sessions.website_session_id)
    AS bounce_rate,
    COUNT(DISTINCT CASE WHEN all_sessions.pageview_url='/home' THEN all_sessions.website_session_id ELSE NULL END) as home_sessions,
    COUNT(DISTINCT CASE WHEN all_sessions.pageview_url='/lander-1' THEN all_sessions.website_session_id ELSE NULL END) as lander_sessions
FROM 
    all_sessions
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = all_sessions.website_session_id
    
GROUP BY WEEK(website_pageviews.created_at)
;

-- +-----------------+-------------+---------------+-----------------+
-- | week_start_date | bounce_rate | home_sessions | lander_sessions |
-- +-----------------+-------------+---------------+-----------------+
-- | 2012-06-01      |      0.6067 |           178 |               0 |
-- | 2012-06-03      |      0.5851 |           793 |               0 |
-- | 2012-06-10      |      0.6176 |           876 |               0 |
-- | 2012-06-17      |      0.5577 |           492 |             349 |
-- | 2012-06-24      |      0.5833 |           370 |             386 |
-- | 2012-07-01      |      0.5813 |           393 |             388 |
-- | 2012-07-08      |      0.5663 |           390 |             410 |
-- | 2012-07-15      |      0.5424 |           427 |             423 |
-- | 2012-07-22      |      0.5132 |           403 |             392 |
-- | 2012-07-29      |      0.4981 |            34 |             994 |
-- | 2012-08-05      |      0.5381 |             0 |            1089 |
-- | 2012-08-12      |      0.5120 |             0 |             996 |
-- | 2012-08-19      |      0.5015 |             0 |            1013 |
-- | 2012-08-26      |      0.5398 |             0 |             830 |
-- +-----------------+-------------+---------------+-----------------+


-- 46. Building Conversion Funnels
-- gsearch nonbrand between 2012-08-05 and 2012-09-05
-- Sessions from lander-1 (sessions) to_products, to_mr_fuzzy, to_cart, to_shipping, to_billing, to_thankyou
-- Then conv rates for the above

-- First, get all sessions satisfying the conditions above
DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT 
    website_pageviews.website_session_id,
    website_pageviews.pageview_url
FROM website_sessions
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.utm_source='gsearch' AND website_sessions.utm_campaign='nonbrand' 
    AND website_pageviews.pageview_url IN ('/lander-1','/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/thank-you-for-your-order')
    AND website_sessions.created_at < '2012-09-05' AND website_sessions.created_at >'2012-08-05'
;

-- Make columns with 1's/0's for each type of page->can group by website_session_id and take MAX of these later
DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT
    temp1.website_session_id,
    CASE WHEN temp1.pageview_url='/lander-1' THEN 1 ELSE 0 END AS lander1_page,
    CASE WHEN temp1.pageview_url='/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN temp1.pageview_url='/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
    CASE WHEN temp1.pageview_url='/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN temp1.pageview_url='/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN temp1.pageview_url='/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN temp1.pageview_url='/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM temp1
;
DROP TABLE IF EXISTS temp3;
CREATE TEMPORARY TABLE temp3
SELECT 
    temp2.website_session_id,
    MAX(temp2.lander1_page) AS to_lander1,
    MAX(temp2.products_page) AS to_products,
    MAX(temp2.mrfuzzy_page) AS to_mrfuzzy,
    MAX(temp2.cart_page) AS to_cart,
    MAX(temp2.shipping_page) AS to_shipping,
    MAX(temp2.billing_page) AS to_billing,
    MAX(temp2.thankyou_page) AS to_thankyou
    
FROM temp2 
GROUP BY 1;

-- Make the table with total counts


SELECT  -- MUST BE ELSE NULL, NOT ELSE 0!!! Otherwise, will count 1 or 0, and all cols will have same count.
    COUNT(CASE WHEN temp3.to_lander1=1 THEN temp3.website_session_id ELSE NULL END) as 'sessions',
    COUNT(CASE WHEN temp3.to_products=1 THEN temp3.website_session_id ELSE NULL END) as 'to_products',
    COUNT(CASE WHEN temp3.to_mrfuzzy=1 THEN temp3.website_session_id ELSE NULL END) as 'to_mrfuzzy',
    COUNT(CASE WHEN temp3.to_cart=1 THEN temp3.website_session_id ELSE NULL END) as 'to_cart',
    COUNT(CASE WHEN temp3.to_shipping=1 THEN temp3.website_session_id ELSE NULL END) as 'to_shipping',
    COUNT(CASE WHEN temp3.to_billing=1 THEN temp3.website_session_id ELSE NULL END) as 'to_billing',
    COUNT(CASE WHEN temp3.to_thankyou=1 THEN temp3.website_session_id ELSE NULL END) as 'to_thankyou'
FROM temp3
-- GROUP BY temp3.website_session_id
;
-- +----------+-------------+------------+---------+-------------+------------+-------------+
-- | sessions | to_products | to_mrfuzzy | to_cart | to_shipping | to_billing | to_thankyou |
-- +----------+-------------+------------+---------+-------------+------------+-------------+
-- |     4494 |        2116 |       1567 |     682 |         454 |        360 |         157 |
-- +----------+-------------+------------+---------+-------------+------------+-------------+

SELECT 
    COUNT(CASE WHEN temp3.to_products=1 THEN temp3.website_session_id ELSE NULL END)/
    COUNT(CASE WHEN temp3.to_lander1=1 THEN temp3.website_session_id ELSE NULL END) AS "lander_click_rt",
    COUNT(CASE WHEN temp3.to_mrfuzzy=1  THEN temp3.website_session_id ELSE NULL END)/
    COUNT(CASE WHEN temp3.to_products=1 THEN temp3.website_session_id ELSE NULL END) AS "mrfuzzy_click_rt",
    COUNT(CASE WHEN temp3.to_cart=1 THEN temp3.website_session_id ELSE NULL END)/
    COUNT(CASE WHEN temp3.to_mrfuzzy=1 THEN temp3.website_session_id ELSE NULL END) AS "product_click_rt",
    COUNT(CASE WHEN temp3.to_shipping=1 THEN temp3.website_session_id ELSE NULL END)/
    COUNT(CASE WHEN temp3.to_cart=1 THEN temp3.website_session_id ELSE NULL END) AS "shipping_click_rt",
    COUNT(CASE WHEN temp3.to_billing=1 THEN temp3.website_session_id ELSE NULL END)/
    COUNT(CASE WHEN temp3.to_shipping=1 THEN temp3.website_session_id ELSE NULL END) AS "billing_click_rt",
    COUNT(CASE WHEN temp3.to_thankyou=1 THEN temp3.website_session_id ELSE NULL END)/
    COUNT(CASE WHEN temp3.to_billing=1 THEN temp3.website_session_id ELSE NULL END) AS "thankyou_click_rt"

FROM 
    temp3
;

-- +-----------------+------------------+------------------+-------------------+------------------+-------------------+
-- | lander_click_rt | mrfuzzy_click_rt | product_click_rt | shipping_click_rt | billing_click_rt | thankyou_click_rt |
-- +-----------------+------------------+------------------+-------------------+------------------+-------------------+
-- |          0.4709 |           0.7405 |           0.4352 |            0.6657 |           0.7930 |            0.4361 |
-- +-----------------+------------------+------------------+-------------------+------------------+-------------------+

-- 49 Analyzing Conversion Funnel Tests
