-- 83. Cross-sell analysis
-- First get website_pageviews with col containing 'Pre_cross_sell' and "Post_cross_sell"
DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT
    *,
    CASE
        WHEN created_at BETWEEN '2013-08-25' AND '2013-09-25' THEN 'Pre_cross_sell'
        ELSE 'Post_cross_sell'
    END AS "pre_post"
FROM website_pageviews
WHERE
    pageview_url IN ("/cart","/shipping")
    AND created_at BETWEEN '2013-08-25' AND '2013-10-25'
;

-- Second,  deterimine how far the session continued (cols of 0/1's then max by website_session_id)

DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT 
    *,
    CASE WHEN pageview_url='/cart' THEN 1 ELSE 0 END AS "to_cart",
    CASE WHEN pageview_url='/shipping' THEN 1 ELSE 0 END AS "to_shipping"
FROM temp1
;

DROP TABLE IF EXISTS temp3;
CREATE TEMPORARY TABLE temp3
SELECT 
    website_session_id,
    pre_post,
    MAX(to_cart) AS "to_cart",
    MAX(to_shipping) AS "to_shipping"
FROM temp2
GROUP BY 1,2
;

-- CHECK: All sessions made it to cart
select COUNT(CASE WHEN to_cart=1 then website_session_id else NULL END) from temp3;
-- +------------------------------------------------------------------+
-- | COUNT(CASE WHEN to_cart=1 then website_session_id else NULL END) |
-- +------------------------------------------------------------------+
-- |                                                             3805 |
-- +------------------------------------------------------------------+


-- Third, join to orders on website_sessions_id to get the remaining cols (avg prods per order,
-- average order value, revenue per cart session)
SELECT
    temp3.pre_post AS "time_period",
    COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) AS "cart_sessions",
    COUNT(CASE WHEN temp3.to_shipping=1 then temp3.website_session_id else NULL END) AS 'clickthroughs',
    COUNT(CASE WHEN temp3.to_shipping=1 then temp3.website_session_id else NULL END) /
    COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) AS "cart_ctr",
    AVG(orders.items_purchased) AS "products_per_order",
    SUM(orders.price_usd) AS "revenue",
    AVG(orders.price_usd) AS "aov",
    SUM(orders.price_usd)/COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) as 'rev_per_cart_session'

FROM 
    temp3
LEFT JOIN
    orders
    ON temp3.website_session_id = orders.website_session_id

GROUP BY 1
ORDER BY 1 DESC
;



-- +-----------------+---------------+---------------+----------+--------------------+----------+-----------+----------------------+
-- | time_period     | cart_sessions | clickthroughs | cart_ctr | products_per_order | revenue  | aov       | rev_per_cart_session |
-- +-----------------+---------------+---------------+----------+--------------------+----------+-----------+----------------------+
-- | Pre_cross_sell  |          1829 |          1227 |   0.6709 |             1.0000 | 33473.49 | 51.418571 |            18.301525 |
-- | Post_cross_sell |          1976 |          1353 |   0.6847 |             1.0447 | 36402.99 | 54.251848 |            18.422566 |
-- +-----------------+---------------+---------------+----------+--------------------+----------+-----------+----------------------+

