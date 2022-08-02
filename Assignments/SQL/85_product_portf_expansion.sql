-- 83. Cross-sell analysis
-- First get website_sessions with col containing 'Pre_cross_sell' and "Post_cross_sell"
DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT
    orders.order_id,orders.items_purchased,orders.price_usd,
    website_sessions.website_session_id,
    CASE
        WHEN website_sessions.created_at BETWEEN '2013-11-12' AND '2013-12-12' THEN 'Pre_Birthday_Bear'
        ELSE 'Post_Birthday_Bear'

    END AS "pre_post"
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY orders.order_id,website_sessions.website_session_id,pre_post
;


-- DROP TABLE IF EXISTS temp2;
-- CREATE TEMPORARY TABLE temp2
-- SELECT
--     MAX(CASE WHEN temp1.order_id IS NOT NULL THEN temp1.order_id ELSE 0 END),
--     MAX(CASE WHEN temp1.website_session_id  IS NOT NULL THEN temp1.website_session_id  ELSE 0 END),
--     MAX(CASE WHEN temp1.items_purchased  IS NOT NULL THEN temp1.items_purchased  ELSE 0 END),


-- FROM temp1
-- GROUP BY 




SELECT
    temp1.pre_post AS "time_period",
    -- COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) AS "cart_sessions",
    -- COUNT(CASE WHEN temp3.to_shipping=1 then temp3.website_session_id else NULL END) AS 'clickthroughs',
    COUNT(CASE WHEN temp1.order_id IS NOT NULL then temp1.order_id else NULL END) /
    COUNT(CASE WHEN temp1.website_session_id IS NOT NULL then temp1.website_session_id else NULL END) AS "conv_rate",
    -- SUM(orders.price_usd) AS "revenue",
    AVG(temp1.price_usd) AS "aov",
    AVG(temp1.items_purchased) AS "products_per_order",
    SUM(temp1.price_usd)/COUNT(CASE WHEN temp1.website_session_id IS NOT NULL then temp1.website_session_id else NULL END) as 'rev_per_cart_session'

FROM 
    temp1
GROUP BY 1
ORDER BY 1 DESC
;

-- My numbers seem to be different to 3rd decimal place, check dates
-- Or most likely because I'm using website_sessions directly without using website_sessions
-- Could make a difference around midnight
-- +--------------------+-----------+-----------+--------------------+----------------------+
-- | time_period        | conv_rate | aov       | products_per_order | rev_per_cart_session |
-- +--------------------+-----------+-----------+--------------------+----------------------+
-- | Pre_Birthday_Bear  |    0.0609 | 54.222491 |             1.0464 |             3.301369 |
-- | Post_Birthday_Bear |    0.0704 | 56.916582 |             1.1231 |             4.005036 |
-- +--------------------+-----------+-----------+--------------------+----------------------+

-- Yes! See the same analysis done with the website_sessions table!
-- +--------------------+-----------+-----------+--------------------+----------------------+
-- | time_period        | conv_rate | aov       | products_per_order | rev_per_cart_session |
-- +--------------------+-----------+-----------+--------------------+----------------------+
-- | Pre_Birthday_Bear  |    0.0608 | 54.226502 |             1.0464 |             3.298677 |
-- | Post_Birthday_Bear |    0.0702 | 56.931319 |             1.1234 |             3.998763 |
-- +--------------------+-----------+-----------+--------------------+----------------------+

-- Second,  deterimine how far the session continued (cols of 0/1's then max by website_session_id)

-- DROP TABLE IF EXISTS temp2;
-- CREATE TEMPORARY TABLE temp2
-- SELECT 
--     *,
--     CASE WHEN pageview_url='/cart' THEN 1 ELSE 0 END AS "to_cart",
--     CASE WHEN pageview_url='/shipping' THEN 1 ELSE 0 END AS "to_shipping"
-- FROM temp1
-- ;

-- DROP TABLE IF EXISTS temp3;
-- CREATE TEMPORARY TABLE temp3
-- SELECT 
--     website_session_id,
--     pre_post,
--     MAX(to_cart) AS "to_cart",
--     MAX(to_shipping) AS "to_shipping"
-- FROM temp2
-- GROUP BY 1,2
-- ;

-- -- CHECK: All sessions made it to cart
-- select COUNT(CASE WHEN to_cart=1 then website_session_id else NULL END) from temp3;
-- -- +------------------------------------------------------------------+
-- -- | COUNT(CASE WHEN to_cart=1 then website_session_id else NULL END) |
-- -- +------------------------------------------------------------------+
-- -- |                                                             3805 |
-- -- +------------------------------------------------------------------+


-- -- Third, join to orders on website_sessions_id to get the remaining cols (avg prods per order,
-- -- average order value, revenue per cart session)
-- SELECT
--     temp3.pre_post AS "time_period",
--     -- COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) AS "cart_sessions",
--     -- COUNT(CASE WHEN temp3.to_shipping=1 then temp3.website_session_id else NULL END) AS 'clickthroughs',
--     COUNT(CASE WHEN temp3.to_shipping=1 then temp3.website_session_id else NULL END) /
--     COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) AS "conv_rate",
--     -- SUM(orders.price_usd) AS "revenue",
--     AVG(orders.price_usd) AS "aov",
--     AVG(orders.items_purchased) AS "products_per_order",
--     SUM(orders.price_usd)/COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) as 'rev_per_cart_session'

-- FROM 
--     temp3
-- LEFT JOIN
--     orders
--     ON temp3.website_session_id = orders.website_session_id

-- GROUP BY 1
-- ORDER BY 1 DESC
-- ;



-- -- +-----------------+---------------+---------------+----------+--------------------+----------+-----------+----------------------+
-- -- | time_period     | cart_sessions | clickthroughs | cart_ctr | products_per_order | revenue  | aov       | rev_per_cart_session |
-- -- +-----------------+---------------+---------------+----------+--------------------+----------+-----------+----------------------+
-- -- | Pre_cross_sell  |          1829 |          1227 |   0.6709 |             1.0000 | 33473.49 | 51.418571 |            18.301525 |
-- -- | Post_cross_sell |          1976 |          1353 |   0.6847 |             1.0447 | 36402.99 | 54.251848 |            18.422566 |
-- -- +-----------------+---------------+---------------+----------+--------------------+----------+-----------+----------------------+







-- -- 83. Cross-sell analysis
-- -- First get website_sessions with col containing 'Pre_cross_sell' and "Post_cross_sell"
-- DROP TABLE IF EXISTS temp1;
-- CREATE TEMPORARY TABLE temp1
-- SELECT
--     orders.order_id,orders.items_purchased,orders.price_usd,
--     website_sessions.website_session_id,
--     CASE
--         WHEN website_sessions.created_at BETWEEN '2013-11-12' AND '2013-12-12' THEN 'Pre_Birthday_Bear'
--         ELSE 'Post_Birthday_Bear'

--     END AS "pre_post"
-- FROM website_sessions
-- LEFT JOIN orders
-- ON orders.website_session_id = website_sessions.website_session_id
-- WHERE
--     website_sessions.created_at BETWEEN '2013-11-12' AND '2014-01-12'
-- GROUP BY orders.order_id,website_sessions.website_session_id,pre_post
-- ;


-- -- DROP TABLE IF EXISTS temp2;
-- -- CREATE TEMPORARY TABLE temp2
-- -- SELECT
-- --     MAX(CASE WHEN temp1.order_id IS NOT NULL THEN temp1.order_id ELSE 0 END),
-- --     MAX(CASE WHEN temp1.website_session_id  IS NOT NULL THEN temp1.website_session_id  ELSE 0 END),
-- --     MAX(CASE WHEN temp1.items_purchased  IS NOT NULL THEN temp1.items_purchased  ELSE 0 END),


-- -- FROM temp1
-- -- GROUP BY 




-- SELECT
--     temp1.pre_post AS "time_period",
--     -- COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) AS "cart_sessions",
--     -- COUNT(CASE WHEN temp3.to_shipping=1 then temp3.website_session_id else NULL END) AS 'clickthroughs',
--     COUNT(CASE WHEN temp1.order_id IS NOT NULL then temp1.order_id else NULL END) /
--     COUNT(CASE WHEN temp1.website_session_id IS NOT NULL then temp1.website_session_id else NULL END) AS "conv_rate",
--     -- SUM(orders.price_usd) AS "revenue",
--     AVG(temp1.price_usd) AS "aov",
--     AVG(temp1.items_purchased) AS "products_per_order",
--     SUM(temp1.price_usd)/COUNT(CASE WHEN temp1.website_session_id IS NOT NULL then temp1.website_session_id else NULL END) as 'rev_per_cart_session'

-- FROM 
--     temp1
-- GROUP BY 1
-- ORDER BY 1 DESC
-- ;

-- -- My numbers seem to be different to 3rd decimal place, check dates
-- -- Or most likely because I'm using website_sessions directly without using website_sessions
-- -- Could make a difference around midnight
-- -- +--------------------+-----------+-----------+--------------------+----------------------+
-- -- | time_period        | conv_rate | aov       | products_per_order | rev_per_cart_session |
-- -- +--------------------+-----------+-----------+--------------------+----------------------+
-- -- | Pre_Birthday_Bear  |    0.0609 | 54.222491 |             1.0464 |             3.301369 |
-- -- | Post_Birthday_Bear |    0.0704 | 56.916582 |             1.1231 |             4.005036 |
-- -- +--------------------+-----------+-----------+--------------------+----------------------+


-- -- Second,  deterimine how far the session continued (cols of 0/1's then max by website_session_id)

-- -- DROP TABLE IF EXISTS temp2;
-- -- CREATE TEMPORARY TABLE temp2
-- -- SELECT 
-- --     *,
-- --     CASE WHEN pageview_url='/cart' THEN 1 ELSE 0 END AS "to_cart",
-- --     CASE WHEN pageview_url='/shipping' THEN 1 ELSE 0 END AS "to_shipping"
-- -- FROM temp1
-- -- ;

-- -- DROP TABLE IF EXISTS temp3;
-- -- CREATE TEMPORARY TABLE temp3
-- -- SELECT 
-- --     website_session_id,
-- --     pre_post,
-- --     MAX(to_cart) AS "to_cart",
-- --     MAX(to_shipping) AS "to_shipping"
-- -- FROM temp2
-- -- GROUP BY 1,2
-- -- ;

-- -- -- CHECK: All sessions made it to cart
-- -- select COUNT(CASE WHEN to_cart=1 then website_session_id else NULL END) from temp3;
-- -- -- +------------------------------------------------------------------+
-- -- -- | COUNT(CASE WHEN to_cart=1 then website_session_id else NULL END) |
-- -- -- +------------------------------------------------------------------+
-- -- -- |                                                             3805 |
-- -- -- +------------------------------------------------------------------+


-- -- -- Third, join to orders on website_sessions_id to get the remaining cols (avg prods per order,
-- -- -- average order value, revenue per cart session)
-- -- SELECT
-- --     temp3.pre_post AS "time_period",
-- --     -- COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) AS "cart_sessions",
-- --     -- COUNT(CASE WHEN temp3.to_shipping=1 then temp3.website_session_id else NULL END) AS 'clickthroughs',
-- --     COUNT(CASE WHEN temp3.to_shipping=1 then temp3.website_session_id else NULL END) /
-- --     COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) AS "conv_rate",
-- --     -- SUM(orders.price_usd) AS "revenue",
-- --     AVG(orders.price_usd) AS "aov",
-- --     AVG(orders.items_purchased) AS "products_per_order",
-- --     SUM(orders.price_usd)/COUNT(CASE WHEN temp3.to_cart=1 then temp3.website_session_id else NULL END) as 'rev_per_cart_session'

-- -- FROM 
-- --     temp3
-- -- LEFT JOIN
-- --     orders
-- --     ON temp3.website_session_id = orders.website_session_id

-- -- GROUP BY 1
-- -- ORDER BY 1 DESC
-- -- ;



-- -- -- +-----------------+---------------+---------------+----------+--------------------+----------+-----------+----------------------+
-- -- -- | time_period     | cart_sessions | clickthroughs | cart_ctr | products_per_order | revenue  | aov       | rev_per_cart_session |
-- -- -- +-----------------+---------------+---------------+----------+--------------------+----------+-----------+----------------------+
-- -- -- | Pre_cross_sell  |          1829 |          1227 |   0.6709 |             1.0000 | 33473.49 | 51.418571 |            18.301525 |
-- -- -- | Post_cross_sell |          1976 |          1353 |   0.6847 |             1.0447 | 36402.99 | 54.251848 |            18.422566 |
-- -- -- +-----------------+---------------+---------------+----------+--------------------+----------+-----------+----------------------+

