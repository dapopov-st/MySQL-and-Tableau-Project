-- 80. Building product-level conversion funnels

-- seems that need billing-2, othewise billing is unreachable
DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT
    *
FROM website_pageviews
WHERE pageview_url IN ('/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/billing-1','/billing-2','/thank-you-for-your-order','/the-forever-love-bear')
    AND created_at BETWEEN '2013-01-06' AND'2013-04-10'
; -- Assuming they have to go to products first to select their product

-- LEFT JOIN website_sessions TO temp1 
-- and add col's of 0's and 1's to website sessions for reaching each of the benchmarks
-- after group by website_sessions.website_session_id

-- ... THEN will be able to use CASE statements to make lovebear and mrfuzzy col entries
DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT 
    website_sessions.website_session_id,
    MAX(CASE WHEN temp1.pageview_url='/products' THEN 1 ELSE 0 END) as "to_products",
    MAX(CASE WHEN temp1.pageview_url='/the-original-mr-fuzzy' THEN 1 ELSE 0 END) as "to_mrfuzzy",
    MAX(CASE WHEN temp1.pageview_url='/cart' THEN 1 ELSE 0 END) as "to_cart",
    MAX(CASE WHEN temp1.pageview_url='/shipping' THEN 1 ELSE 0 END) as "to_shipping",
    MAX(CASE WHEN temp1.pageview_url='/billing' OR temp1.pageview_url='/billing-1' OR temp1.pageview_url='/billing-2' THEN 1 ELSE 0 END) as "to_billing",
    MAX(CASE WHEN temp1.pageview_url='/thank-you-for-your-order' THEN 1 ELSE 0 END) as "to_thankyou",
    MAX(CASE WHEN temp1.pageview_url='/the-forever-love-bear' THEN 1 ELSE 0 END) as "to_lovebear"

FROM temp1
LEFT JOIN website_sessions
ON website_sessions.website_session_id=temp1.website_session_id
GROUP BY 1
;

-- select * from temp2 where to_mrfuzzy=1 and to_lovebear=1;
-- Empty set (0.01 sec)
-- Thus no products make it to both
-- Make product seen column
DROP TABLE IF EXISTS temp3;
CREATE TEMPORARY TABLE temp3
SELECT 
    *,
    CASE 
        WHEN temp2.to_mrfuzzy = 1 THEN "mrfuzzy"
        WHEN temp2.to_lovebear = 1 THEN "lovebear"
        ELSE NULL END
    AS "product_seen"
FROM temp2
;

-- Now make the counts table, then click through rates
SELECT 
    product_seen,
    COUNT(DISTINCT temp3.website_session_id) as 'sessions',
    COUNT(DISTINCT CASE WHEN temp3.to_cart=1 THEN temp3.website_session_id ELSE NULL END) as 'to_cart',
    COUNT(DISTINCT CASE WHEN temp3.to_shipping=1 THEN temp3.website_session_id ELSE NULL END) as 'to_shipping',
    COUNT(DISTINCT CASE WHEN temp3.to_billing=1 THEN temp3.website_session_id ELSE NULL END) as 'to_billing',
    COUNT(DISTINCT CASE WHEN temp3.to_thankyou=1 THEN temp3.website_session_id ELSE NULL END) as 'to_thankyou'
FROM temp3
WHERE product_seen IS NOT NULL
GROUP BY 1
;

-- +--------------+----------+---------+-------------+------------+-------------+
-- | product_seen | sessions | to_cart | to_shipping | to_billing | to_thankyou |
-- +--------------+----------+---------+-------------+------------+-------------+
-- | lovebear     |     1599 |     877 |         603 |        488 |         301 |
-- | mrfuzzy      |     6979 |    3034 |        2081 |       1708 |        1086 |
-- +--------------+----------+---------+-------------+------------+-------------+
SELECT 
    product_seen,
    COUNT(DISTINCT CASE WHEN temp3.to_cart=1 THEN temp3.website_session_id ELSE NULL END)/
    COUNT(DISTINCT temp3.website_session_id) as 'product_page_click_rt',
    COUNT(DISTINCT CASE WHEN temp3.to_shipping=1 THEN temp3.website_session_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN temp3.to_cart=1 THEN temp3.website_session_id ELSE NULL END)
     as 'cart_click_rt',
    COUNT(DISTINCT CASE WHEN temp3.to_billing=1 THEN temp3.website_session_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN temp3.to_shipping=1 THEN temp3.website_session_id ELSE NULL END)
     as 'shipping_click_rt',
    COUNT(DISTINCT CASE WHEN temp3.to_thankyou=1 THEN temp3.website_session_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN temp3.to_billing=1 THEN temp3.website_session_id ELSE NULL END)
    as 'billing_click_rt'
FROM temp3
WHERE product_seen IS NOT NULL
GROUP BY 1
;

-- +--------------+-----------------------+---------------+-------------------+------------------+
-- | product_seen | product_page_click_rt | cart_click_rt | shipping_click_rt | billing_click_rt |
-- +--------------+-----------------------+---------------+-------------------+------------------+
-- | lovebear     |                0.5485 |        0.6876 |            0.8093 |           0.6168 |
-- | mrfuzzy      |                0.4347 |        0.6859 |            0.8208 |           0.6358 |
-- +--------------+-----------------------+---------------+-------------------+------------------+