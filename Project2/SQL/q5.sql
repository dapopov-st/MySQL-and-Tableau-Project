-- +------------+---------------------+----------------------------+
-- | product_id | created_at          | product_name               |
-- +------------+---------------------+----------------------------+
-- |          1 | 2012-03-19 06:00:00 | The Original Mr. Fuzzy     |
-- |          2 | 2013-01-06 10:00:00 | The Forever Love Bear      |
-- |          3 | 2013-12-12 06:00:00 | The Birthday Sugar Panda   |
-- |          4 | 2014-02-05 07:00:00 | The Hudson River Mini bear |
-- +------------+---------------------+----------------------------+

-- Monthly trending by revenue and margin by product, along with total sales and revenue

SELECT
    YEAR(order_items.created_at) AS 'year',
    MONTH(order_items.created_at) AS 'month',
    products.product_name as "product",
    COUNT(DISTINCT order_items.order_item_id) AS "total_sales",
    SUM(order_items.price_usd) AS "total_revenue",
    SUM(order_items.price_usd-order_items.cogs_usd) AS "margin_by_product"

FROM order_items
LEFT JOIN products
ON order_items.product_id = products.product_id
WHERE order_items.created_at < '2015-03-20'
GROUP BY order_items.product_id,1,2
;

SELECT
    YEAR(order_items.created_at) AS 'year',
    MONTH(order_items.created_at) AS 'quarter',
    COUNT(DISTINCT order_items.order_item_id) AS "total_sales",
    SUM(order_items.price_usd) AS "total_revenue"
FROM order_items
LEFT JOIN products
ON order_items.product_id = products.product_id
WHERE order_items.created_at < '2015-03-20'
GROUP BY 1,2
;

+------+-------+----------------------------+-------------+---------------+-------------------+
| year | month | product                    | total_sales | total_revenue | margin_by_product |
+------+-------+----------------------------+-------------+---------------+-------------------+
| 2012 |     3 | The Original Mr. Fuzzy     |          60 |       2999.40 |           1830.00 |
| 2012 |     4 | The Original Mr. Fuzzy     |          99 |       4949.01 |           3019.50 |
| 2012 |     5 | The Original Mr. Fuzzy     |         108 |       5398.92 |           3294.00 |
| 2012 |     6 | The Original Mr. Fuzzy     |         140 |       6998.60 |           4270.00 |
| 2012 |     7 | The Original Mr. Fuzzy     |         169 |       8448.31 |           5154.50 |
| 2012 |     8 | The Original Mr. Fuzzy     |         228 |      11397.72 |           6954.00 |
| 2012 |     9 | The Original Mr. Fuzzy     |         287 |      14347.13 |           8753.50 |
| 2012 |    10 | The Original Mr. Fuzzy     |         372 |      18596.28 |          11346.00 |
| 2012 |    11 | The Original Mr. Fuzzy     |         618 |      30893.82 |          18849.00 |
| 2012 |    12 | The Original Mr. Fuzzy     |         506 |      25294.94 |          15433.00 |
| 2013 |     1 | The Original Mr. Fuzzy     |         343 |      17146.57 |          10461.50 |
| 2013 |     2 | The Original Mr. Fuzzy     |         335 |      16746.65 |          10217.50 |
| 2013 |     3 | The Original Mr. Fuzzy     |         321 |      16046.79 |           9790.50 |
| 2013 |     4 | The Original Mr. Fuzzy     |         460 |      22995.40 |          14030.00 |
| 2013 |     5 | The Original Mr. Fuzzy     |         488 |      24395.12 |          14884.00 |
| 2013 |     6 | The Original Mr. Fuzzy     |         504 |      25194.96 |          15372.00 |
| 2013 |     7 | The Original Mr. Fuzzy     |         509 |      25444.91 |          15524.50 |
| 2013 |     8 | The Original Mr. Fuzzy     |         508 |      25394.92 |          15494.00 |
| 2013 |     9 | The Original Mr. Fuzzy     |         537 |      26844.63 |          16378.50 |
| 2013 |    10 | The Original Mr. Fuzzy     |         605 |      30243.95 |          18452.50 |
| 2013 |    11 | The Original Mr. Fuzzy     |         722 |      36092.78 |          22021.00 |
| 2013 |    12 | The Original Mr. Fuzzy     |         820 |      40991.80 |          25010.00 |
| 2014 |     1 | The Original Mr. Fuzzy     |         726 |      36292.74 |          22143.00 |
| 2014 |     2 | The Original Mr. Fuzzy     |         587 |      29344.13 |          17903.50 |
| 2014 |     3 | The Original Mr. Fuzzy     |         784 |      39192.16 |          23912.00 |
| 2014 |     4 | The Original Mr. Fuzzy     |         917 |      45840.83 |          27968.50 |
| 2014 |     5 | The Original Mr. Fuzzy     |        1030 |      51489.70 |          31415.00 |
| 2014 |     6 | The Original Mr. Fuzzy     |         893 |      44641.07 |          27236.50 |
| 2014 |     7 | The Original Mr. Fuzzy     |         960 |      47990.40 |          29280.00 |
| 2014 |     8 | The Original Mr. Fuzzy     |         959 |      47940.41 |          29249.50 |
| 2014 |     9 | The Original Mr. Fuzzy     |        1056 |      52789.44 |          32208.00 |
| 2014 |    10 | The Original Mr. Fuzzy     |        1171 |      58538.29 |          35715.50 |
| 2014 |    11 | The Original Mr. Fuzzy     |        1469 |      73435.31 |          44804.50 |
| 2014 |    12 | The Original Mr. Fuzzy     |        1571 |      78534.29 |          47915.50 |
| 2015 |     1 | The Original Mr. Fuzzy     |        1389 |      69436.11 |          42364.50 |
| 2015 |     2 | The Original Mr. Fuzzy     |        1113 |      55638.87 |          33946.50 |
| 2015 |     3 | The Original Mr. Fuzzy     |         862 |      43091.38 |          26291.00 |
| 2013 |     1 | The Forever Love Bear      |          47 |       2819.53 |           1762.50 |
| 2013 |     2 | The Forever Love Bear      |         162 |       9718.38 |           6075.00 |
| 2013 |     3 | The Forever Love Bear      |          65 |       3899.35 |           2437.50 |
| 2013 |     4 | The Forever Love Bear      |          94 |       5639.06 |           3525.00 |
| 2013 |     5 | The Forever Love Bear      |          82 |       4919.18 |           3075.00 |
| 2013 |     6 | The Forever Love Bear      |          90 |       5399.10 |           3375.00 |
| 2013 |     7 | The Forever Love Bear      |          96 |       5759.04 |           3600.00 |
| 2013 |     8 | The Forever Love Bear      |          97 |       5819.03 |           3637.50 |
| 2013 |     9 | The Forever Love Bear      |          98 |       5879.02 |           3675.00 |
| 2013 |    10 | The Forever Love Bear      |         135 |       8098.65 |           5062.50 |
| 2013 |    11 | The Forever Love Bear      |         174 |      10438.26 |           6525.00 |
| 2013 |    12 | The Forever Love Bear      |         183 |      10978.17 |           6862.50 |
| 2014 |     1 | The Forever Love Bear      |         184 |      11038.16 |           6900.00 |
| 2014 |     2 | The Forever Love Bear      |         350 |      20996.50 |          13125.00 |
| 2014 |     3 | The Forever Love Bear      |         193 |      11578.07 |           7237.50 |
| 2014 |     4 | The Forever Love Bear      |         214 |      12837.86 |           8025.00 |
| 2014 |     5 | The Forever Love Bear      |         246 |      14757.54 |           9225.00 |
| 2014 |     6 | The Forever Love Bear      |         245 |      14697.55 |           9187.50 |
| 2014 |     7 | The Forever Love Bear      |         245 |      14697.55 |           9187.50 |
| 2014 |     8 | The Forever Love Bear      |         237 |      14217.63 |           8887.50 |
| 2014 |     9 | The Forever Love Bear      |         250 |      14997.50 |           9375.00 |
| 2014 |    10 | The Forever Love Bear      |         286 |      17157.14 |          10725.00 |
| 2014 |    11 | The Forever Love Bear      |         377 |      22616.23 |          14137.50 |
| 2014 |    12 | The Forever Love Bear      |         385 |      23096.15 |          14437.50 |
| 2015 |     1 | The Forever Love Bear      |         395 |      23696.05 |          14812.50 |
| 2015 |     2 | The Forever Love Bear      |         644 |      38633.56 |          24150.00 |
| 2015 |     3 | The Forever Love Bear      |         222 |      13317.78 |           8325.00 |
| 2013 |    12 | The Birthday Sugar Panda   |         139 |       6392.61 |           4378.50 |
| 2014 |     1 | The Birthday Sugar Panda   |         200 |       9198.00 |           6300.00 |
| 2014 |     2 | The Birthday Sugar Panda   |         213 |       9795.87 |           6709.50 |
| 2014 |     3 | The Birthday Sugar Panda   |         243 |      11175.57 |           7654.50 |
| 2014 |     4 | The Birthday Sugar Panda   |         266 |      12233.34 |           8379.00 |
| 2014 |     5 | The Birthday Sugar Panda   |         299 |      13751.01 |           9418.50 |
| 2014 |     6 | The Birthday Sugar Panda   |         290 |      13337.10 |           9135.00 |
| 2014 |     7 | The Birthday Sugar Panda   |         274 |      12601.26 |           8631.00 |
| 2014 |     8 | The Birthday Sugar Panda   |         294 |      13521.06 |           9261.00 |
| 2014 |     9 | The Birthday Sugar Panda   |         317 |      14578.83 |           9985.50 |
| 2014 |    10 | The Birthday Sugar Panda   |         368 |      16924.32 |          11592.00 |
| 2014 |    11 | The Birthday Sugar Panda   |         432 |      19867.68 |          13608.00 |
| 2014 |    12 | The Birthday Sugar Panda   |         533 |      24512.67 |          16789.50 |
| 2015 |     1 | The Birthday Sugar Panda   |         449 |      20649.51 |          14143.50 |
| 2015 |     2 | The Birthday Sugar Panda   |         406 |      18671.94 |          12789.00 |
| 2015 |     3 | The Birthday Sugar Panda   |         262 |      12049.38 |           8253.00 |
| 2014 |     2 | The Hudson River Mini bear |         203 |       6087.97 |           4161.50 |
| 2014 |     3 | The Hudson River Mini bear |         204 |       6117.96 |           4182.00 |
| 2014 |     4 | The Hudson River Mini bear |         259 |       7767.41 |           5309.50 |
| 2014 |     5 | The Hudson River Mini bear |         298 |       8937.02 |           6109.00 |
| 2014 |     6 | The Hudson River Mini bear |         249 |       7467.51 |           5104.50 |
| 2014 |     7 | The Hudson River Mini bear |         264 |       7917.36 |           5412.00 |
| 2014 |     8 | The Hudson River Mini bear |         303 |       9086.97 |           6211.50 |
| 2014 |     9 | The Hudson River Mini bear |         328 |       9836.72 |           6724.00 |
| 2014 |    10 | The Hudson River Mini bear |         376 |      11276.24 |           7708.00 |
| 2014 |    11 | The Hudson River Mini bear |         454 |      13615.46 |           9307.00 |
| 2014 |    12 | The Hudson River Mini bear |         584 |      17514.16 |          11972.00 |
| 2015 |     1 | The Hudson River Mini bear |         611 |      18323.89 |          12525.50 |
| 2015 |     2 | The Hudson River Mini bear |         542 |      16254.58 |          11111.00 |
| 2015 |     3 | The Hudson River Mini bear |         343 |      10286.57 |           7031.50 |
+------+-------+----------------------------+-------------+---------------+-------------------+


+------+---------+-------------+---------------+
| year | quarter | total_sales | total_revenue |
+------+---------+-------------+---------------+
| 2012 |       3 |          60 |       2999.40 |
| 2012 |       4 |          99 |       4949.01 |
| 2012 |       5 |         108 |       5398.92 |
| 2012 |       6 |         140 |       6998.60 |
| 2012 |       7 |         169 |       8448.31 |
| 2012 |       8 |         228 |      11397.72 |
| 2012 |       9 |         287 |      14347.13 |
| 2012 |      10 |         372 |      18596.28 |
| 2012 |      11 |         618 |      30893.82 |
| 2012 |      12 |         506 |      25294.94 |
| 2013 |       1 |         390 |      19966.10 |
| 2013 |       2 |         497 |      26465.03 |
| 2013 |       3 |         386 |      19946.14 |
| 2013 |       4 |         554 |      28634.46 |
| 2013 |       5 |         570 |      29314.30 |
| 2013 |       6 |         594 |      30594.06 |
| 2013 |       7 |         605 |      31203.95 |
| 2013 |       8 |         605 |      31213.95 |
| 2013 |       9 |         635 |      32723.65 |
| 2013 |      10 |         740 |      38342.60 |
| 2013 |      11 |         896 |      46531.04 |
| 2013 |      12 |        1142 |      58362.58 |
| 2014 |       1 |        1110 |      56528.90 |
| 2014 |       2 |        1353 |      66224.47 |
| 2014 |       3 |        1424 |      68063.76 |
| 2014 |       4 |        1656 |      78679.44 |
| 2014 |       5 |        1873 |      88935.27 |
| 2014 |       6 |        1677 |      80143.23 |
| 2014 |       7 |        1743 |      83206.57 |
| 2014 |       8 |        1793 |      84766.07 |
| 2014 |       9 |        1951 |      92202.49 |
| 2014 |      10 |        2201 |     103895.99 |
| 2014 |      11 |        2732 |     129534.68 |
| 2014 |      12 |        3073 |     143657.27 |
| 2015 |       1 |        2844 |     132105.56 |
| 2015 |       2 |        2705 |     129198.95 |
| 2015 |       3 |        1689 |      78745.11 |
+------+---------+-------------+---------------+