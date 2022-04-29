-- created_at BETWEEN '2014-12-05' AND '2015-03-20' 
-- product_id = 4
-- COUNT num of order_item_id's for each product


DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT 
    *,
    CASE
        WHEN product_id=1 and is_primary_item=1 then 1
        WHEN product_id=2 and is_primary_item=1 then 2
        WHEN product_id=3 and is_primary_item=1 then 3
        WHEN product_id=4 and is_primary_item=1 then 4
    END AS "primary_product"
FROM order_items
WHERE created_at BETWEEN '2014-12-05' AND '2015-03-20' 
;

DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT 
    order_id,
    MAX(primary_product) as max_primary
FROM temp1
GROUP BY 1;

DROP TABLE IF EXISTS temp3;
CREATE TEMPORARY TABLE temp3
SELECT
    temp1.order_id,
    temp1.order_item_id,
    temp1.product_id,
    temp1.is_primary_item,
    temp1.created_at,
    CASE
        WHEN temp1.primary_product IS NULL THEN temp2.max_primary
        ELSE temp1.primary_product
    END AS "prim_product"
FROM temp1
LEFT JOIN temp2
ON temp1.order_id=temp2.order_id
;


SELECT
    prim_product as "primary_product",
    COUNT(DISTINCT CASE 
        WHEN product_id=1 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=2 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=3 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=4 AND is_primary_item=1 THEN order_item_id 
    ELSE NULL END) AS "total_orders",
    COUNT(DISTINCT CASE 
        WHEN product_id=1 AND is_primary_item=1 AND prim_product=1 THEN NULL
        WHEN product_id=1 AND is_primary_item=0 AND prim_product=2 THEN order_item_id 
        WHEN product_id=1 AND is_primary_item=0 AND prim_product=3 THEN order_item_id
        WHEN product_id=1 AND is_primary_item=0 AND prim_product=4 THEN order_item_id 
        END) AS "p1_cross",
    COUNT(DISTINCT CASE 
        WHEN product_id=2 AND is_primary_item=0 AND prim_product=1 THEN order_item_id
        WHEN product_id=2 AND is_primary_item=1 AND prim_product=2 THEN NULL
        WHEN product_id=2 AND is_primary_item=0 AND prim_product=3 THEN order_item_id
        WHEN product_id=2 AND is_primary_item=0 AND prim_product=4 THEN order_item_id 
        END) AS "p2_cross",
    COUNT(DISTINCT CASE 
        WHEN product_id=3 AND is_primary_item=0 AND prim_product=1 THEN order_item_id
        WHEN product_id=3 AND is_primary_item=0 AND prim_product=2 THEN order_item_id
        WHEN product_id=3 AND is_primary_item=1 AND prim_product=3 THEN NULL
        WHEN product_id=3 AND is_primary_item=0 AND prim_product=4 THEN order_item_id 
        END) AS "p3_cross",
    COUNT(DISTINCT CASE 
        WHEN product_id=4 AND is_primary_item=0 AND prim_product=1 THEN order_item_id
        WHEN product_id=4 AND is_primary_item=0 AND prim_product=2 THEN order_item_id
        WHEN product_id=4 AND is_primary_item=0 AND prim_product=3 THEN order_item_id
        WHEN product_id=4 AND is_primary_item=1 AND prim_product=4 THEN NULL 
        END) AS "p4_cross",
    COUNT(DISTINCT CASE 
        WHEN product_id=1 AND is_primary_item=1 AND prim_product=1 THEN NULL
        WHEN product_id=1 AND is_primary_item=0 AND prim_product=2 THEN order_item_id 
        WHEN product_id=1 AND is_primary_item=0 AND prim_product=3 THEN order_item_id
        WHEN product_id=1 AND is_primary_item=0 AND prim_product=4 THEN order_item_id 
        END)/
    COUNT(DISTINCT CASE 
        WHEN product_id=1 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=2 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=3 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=4 AND is_primary_item=1 THEN order_item_id 
    ELSE NULL END) AS "p1_crs_rt",
    COUNT(DISTINCT CASE 
        WHEN product_id=2 AND is_primary_item=0 AND prim_product=1 THEN order_item_id
        WHEN product_id=2 AND is_primary_item=1 AND prim_product=2 THEN NULL
        WHEN product_id=2 AND is_primary_item=0 AND prim_product=3 THEN order_item_id
        WHEN product_id=2 AND is_primary_item=0 AND prim_product=4 THEN order_item_id 
        END)/
    COUNT(DISTINCT CASE 
        WHEN product_id=1 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=2 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=3 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=4 AND is_primary_item=1 THEN order_item_id 
    ELSE NULL END)
         AS "p2_crs_rt",
    COUNT(DISTINCT CASE 
        WHEN product_id=3 AND is_primary_item=0 AND prim_product=1 THEN order_item_id
        WHEN product_id=3 AND is_primary_item=0 AND prim_product=2 THEN order_item_id
        WHEN product_id=3 AND is_primary_item=1 AND prim_product=3 THEN NULL
        WHEN product_id=3 AND is_primary_item=0 AND prim_product=4 THEN order_item_id 
        END)/
    COUNT(DISTINCT CASE 
        WHEN product_id=1 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=2 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=3 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=4 AND is_primary_item=1 THEN order_item_id 
    ELSE NULL END) AS "p3_crs_rt",
    COUNT(DISTINCT CASE 
        WHEN product_id=4 AND is_primary_item=0 AND prim_product=1 THEN order_item_id
        WHEN product_id=4 AND is_primary_item=0 AND prim_product=2 THEN order_item_id
        WHEN product_id=4 AND is_primary_item=0 AND prim_product=3 THEN order_item_id
        WHEN product_id=4 AND is_primary_item=1 AND prim_product=4 THEN NULL 
        END)/
    COUNT(DISTINCT CASE 
        WHEN product_id=1 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=2 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=3 AND is_primary_item=1 THEN order_item_id 
        WHEN product_id=4 AND is_primary_item=1 THEN order_item_id 
    ELSE NULL END) AS "p4_crs_rt"

  
FROM temp3
GROUP BY 1;


-- +-----------------+--------------+----------+----------+----------+----------+-----------+-----------+-----------+-----------+
-- | primary_product | total_orders | p1_cross | p2_cross | p3_cross | p4_cross | p1_crs_rt | p2_crs_rt | p3_crs_rt | p4_crs_rt |
-- +-----------------+--------------+----------+----------+----------+----------+-----------+-----------+-----------+-----------+
-- |               1 |         4463 |        0 |      237 |      552 |      931 |    0.0000 |    0.0531 |    0.1237 |    0.2086 |
-- |               2 |         1277 |       25 |        0 |       40 |      260 |    0.0196 |    0.0000 |    0.0313 |    0.2036 |
-- |               3 |          928 |       84 |       40 |        0 |      208 |    0.0905 |    0.0431 |    0.0000 |    0.2241 |
-- |               4 |          581 |       16 |        9 |       22 |        0 |    0.0275 |    0.0155 |    0.0379 |    0.0000 |
-- +-----------------+--------------+----------+----------+----------+----------+-----------+-----------+-----------+-----------+


---------------------------------------------------------------------------------------------------------

-- Get total sales data for every item (4 cols), then...
-- Given is_primary_item=1, if product_id=1, count num of orders also including 2, 3, 4 
-- (have same order_id, but higher order_item_id)
-- Same for other products as primary items (total of 4*3=12 cols)

-- OR
-- primary products as a col (1,2,3,4 are rows), cross sold as cols


-- Instead of is_primary_item, would be nice to have a col showing primary item
-- Then can group on that col and count 

-- DROP TABLE IF EXISTS min_orders;
-- CREATE TEMPORARY TABLE min_orders
-- SELECT
--     order_id,
--     MIN(order_item_id) as min_order_item_id
--     -- MIN(order_item_id) as min_order_item_id,
--     FROM order_items
--     WHERE created_at BETWEEN '2014-12-05' AND '2015-03-20' 
--     GROUP BY order_id 
-- ;

-- SELECT product_id
--             FROM min_orders
--             WHERE order_items.order_item_id=min_orders.min_order_item_id
-- ;
-- DROP TABLE IF EXISTS primary_orders;

-- CREATE TEMPORARY TABLE primary_orders
-- SELECT
--     order_items.order_id,
--     order_items.product_id ,
--     order_items.is_primary_item,
--     min_orders.min_order_item_id,
--     CASE 
--         WHEN order_items.order_item_id=min_orders.min_order_item_id THEN product_id 
--         ELSE product_id=(
--             SELECT product_id
--             FROM min_orders
--             WHERE order_items.order_item_id=min_orders.min_order_item_id
--         ) 
--     END AS  "primary_item" 

-- FROM  min_orders
-- RIGHT JOIN
--     order_items
-- ON order_items.order_item_id = min_orders.min_order_item_id
-- WHERE order_items.created_at BETWEEN '2014-12-05' AND '2015-03-20' 
-- ;


-- SELECT
--     product_id,
--     COUNT(DISTINCT CASE 
--     WHEN product_id=1 AND is_primary_item=1 THEN order_item_id 
--     WHEN product_id=2 AND is_primary_item=1 THEN order_item_id 
--     WHEN product_id=3 AND is_primary_item=1 THEN order_item_id 
--     WHEN product_id=4 AND is_primary_item=1 THEN order_item_id 
--     ELSE NULL END) AS "total_primary",
--     COUNT(DISTINCT CASE 
--     WHEN product_id=1 THEN 0 
--     WHEN product_id=2 AND is_primary_item=1 THEN order_item_id 
--     ELSE NULL END) AS "p1_xsell",
--     COUNT(DISTINCT CASE 
--     WHEN product_id=2 and is_primary_item=0 THEN order_item_id
--     ELSE NULL END) AS "p2_xsell"
-- FROM order_items
-- WHERE created_at BETWEEN '2014-12-05' AND '2015-03-20' 
-- GROUP BY product_id
-- ORDER BY product_id
-- ;



-- SELECT 
--     product_name,
--     product_id,
--     MIN(created_at) as "first_created"
-- FROM products
-- GROUP BY product_name,product_id
-- ORDER BY first_created DESC;
-- +----------------------------+------------+---------------------+
-- | product_name               | product_id | first_created       |
-- +----------------------------+------------+---------------------+
-- | The Hudson River Mini bear |          4 | 2014-02-05 07:00:00 |
-- | The Birthday Sugar Panda   |          3 | 2013-12-12 06:00:00 |
-- | The Forever Love Bear      |          2 | 2013-01-06 10:00:00 |
-- | The Original Mr. Fuzzy     |          1 | 2012-03-19 06:00:00 |
-- +----------------------------+------------+---------------------+

-- DROP TABLE IF EXISTS temp4;
-- CREATE TEMPORARY TABLE temp4
-- SELECT
--     prim_product as "primary_product",
--     COUNT(DISTINCT CASE 
--     WHEN product_id=1 AND is_primary_item=1 THEN order_item_id 
--     WHEN product_id=2 AND is_primary_item=1 THEN order_item_id 
--     WHEN product_id=3 AND is_primary_item=1 THEN order_item_id 
--     WHEN product_id=4 AND is_primary_item=1 THEN order_item_id 
--     ELSE NULL END) AS "total_primary",
--     COUNT(DISTINCT CASE WHEN product_id=2 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--     ELSE NULL END) AS "p1_to_2",
--     COUNT(DISTINCT CASE WHEN product_id=3 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--     ELSE NULL END) AS "p1_to_3",
--     COUNT(DISTINCT CASE WHEN product_id=4 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--     ELSE NULL END) AS "p1_to_4",
--     COUNT(DISTINCT CASE WHEN product_id=1 AND is_primary_item=0 AND prim_product=2 THEN order_item_id 
--     ELSE NULL END) AS "p2_to_1",
--     COUNT(DISTINCT CASE WHEN product_id=3 AND is_primary_item=0 AND prim_product=2 THEN order_item_id 
--     ELSE NULL END) AS "p2_to_3",
--     COUNT(DISTINCT CASE WHEN product_id=4 AND is_primary_item=0 AND prim_product=2 THEN order_item_id 
--     ELSE NULL END) AS "p2_to_4",
--     COUNT(DISTINCT CASE WHEN product_id=1 AND is_primary_item=0 AND prim_product=3 THEN order_item_id 
--     ELSE NULL END) AS "p3_to_1",
--     COUNT(DISTINCT CASE WHEN product_id=2 AND is_primary_item=0 AND prim_product=3 THEN order_item_id 
--     ELSE NULL END) AS "p3_to_2",
--     COUNT(DISTINCT CASE WHEN product_id=4 AND is_primary_item=0 AND prim_product=3 THEN order_item_id 
--     ELSE NULL END) AS "p3_to_4",
--     COUNT(DISTINCT CASE WHEN product_id=1 AND is_primary_item=0 AND prim_product=4 THEN order_item_id 
--     ELSE NULL END) AS "p4_to_1",
--     COUNT(DISTINCT CASE WHEN product_id=2 AND is_primary_item=0 AND prim_product=4 THEN order_item_id 
--     ELSE NULL END) AS "p4_to_2",
--     COUNT(DISTINCT CASE WHEN product_id=3 AND is_primary_item=0 AND prim_product=4 THEN order_item_id 
--     ELSE NULL END) AS "p4_to_3"
    
-- FROM temp3
-- GROUP BY 1;

-- -- +-----------------+---------------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
-- -- | primary_product | total_primary | p1_to_2 | p1_to_3 | p1_to_4 | p2_to_1 | p2_to_3 | p2_to_4 | p3_to_1 | p3_to_2 | p3_to_4 | p4_to_1 | p4_to_2 | p4_to_3 |
-- -- +-----------------+---------------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+
-- -- |               1 |          4463 |     237 |     552 |     931 |       0 |       0 |       0 |       0 |       0 |       0 |       0 |       0 |       0 |
-- -- |               2 |          1277 |       0 |       0 |       0 |      25 |      40 |     260 |       0 |       0 |       0 |       0 |       0 |       0 |
-- -- |               3 |           928 |       0 |       0 |       0 |       0 |       0 |       0 |      84 |      40 |     208 |       0 |       0 |       0 |
-- -- |               4 |           581 |       0 |       0 |       0 |       0 |       0 |       0 |       0 |       0 |       0 |      16 |       9 |      22 |
-- -- +-----------------+---------------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+---------+

-- DROP TABLE IF EXISTS temp5;
-- CREATE TEMPORARY TABLE temp5
-- SELECT
--     primary_product,
--     total_primary,
--     CASE
--         WHEN primary_product=1 THEN 0
--         WHEN primary_product=2 THEN 237
--         WHEN primary_product=3 THEN 552
--         WHEN primary_product=4 and p1_to_4>0 THEN (p1_to_4 WHERE primary_product=1)
--     END AS p1_cross -- ,

--     -- COUNT(DISTINCT CASE WHEN product_id=2 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--     -- ELSE NULL END) AS "p1_to_2",
--     -- COUNT(DISTINCT CASE WHEN product_id=3 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--     -- ELSE NULL END) AS "p1_to_3",
--     -- COUNT(DISTINCT CASE WHEN product_id=4 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--     -- ELSE NULL END) AS "p1_to_4"
-- FROM temp4
-- -- GROUP BY 1
-- ;



-- DROP TABLE IF EXISTS temp6;
-- CREATE TEMPORARY TABLE temp6
-- SELECT
--     prim_product as "primary_product",
--     COUNT(DISTINCT CASE 
--     WHEN product_id=1 AND is_primary_item=1 THEN order_item_id 
--     WHEN product_id=2 AND is_primary_item=1 THEN order_item_id 
--     WHEN product_id=3 AND is_primary_item=1 THEN order_item_id 
--     WHEN product_id=4 AND is_primary_item=1 THEN order_item_id 
--     ELSE NULL END) AS "total_primary",
--     COUNT(DISTINCT 
--         CASE 
--             WHEN product_id=1 AND is_primary_item=0 AND prim_product=1 THEN 0
--             WHEN product_id=2 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--             WHEN product_id=3 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--             WHEN product_id=4 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--             END) AS "p1_cross"
--     -- COUNT(DISTINCT CASE WHEN product_id=3 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--     -- ELSE NULL END) AS "p1_to_3",
--     -- COUNT(DISTINCT CASE WHEN product_id=4 AND is_primary_item=0 AND prim_product=1 THEN order_item_id 
--     -- ELSE NULL END) AS "p1_to_4"
    
-- FROM temp3
-- GROUP BY 1;






