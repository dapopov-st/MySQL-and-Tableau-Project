-- 89. Analyzing product refund rates
-- Quality problem with Mr Fuzzy supplier that should have been fixed
-- after Sept. 16, 2014
-- Analyze from start to '2014-10-15'
-- Monthly product refund rates by product for the 4 products

-- select * from products;
-- +------------+---------------------+----------------------------+
-- | product_id | created_at          | product_name               |
-- +------------+---------------------+----------------------------+
-- |          1 | 2012-03-19 09:00:00 | The Original Mr. Fuzzy     |
-- |          2 | 2013-01-06 13:00:00 | The Forever Love Bear      |
-- |          3 | 2013-12-12 09:00:00 | The Birthday Sugar Panda   |
-- |          4 | 2014-02-05 10:00:00 | The Hudson River Mini bear |
-- +------------+---------------------+----------------------------+

SELECT
    YEAR(order_items.created_at) as "yr",
    MONTH(order_items.created_at) as "mn",
    COUNT(DISTINCT CASE WHEN order_items.product_id=1 THEN order_items.order_item_id ELSE NULL END) AS 'p1_orders',
    COUNT(DISTINCT CASE WHEN order_items.product_id=1 THEN order_item_refunds.order_item_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN order_items.product_id=1 THEN order_items.order_item_id ELSE NULL END) AS 'p1_refund_rt',
    COUNT(DISTINCT CASE WHEN order_items.product_id=2 THEN order_items.order_item_id ELSE NULL END) AS 'p2_orders',
    COUNT(DISTINCT CASE WHEN order_items.product_id=2 THEN order_item_refunds.order_item_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN order_items.product_id=2 THEN order_items.order_item_id ELSE NULL END) AS 'p2_refund_rt',
    COUNT(DISTINCT CASE WHEN order_items.product_id=3 THEN order_items.order_item_id ELSE NULL END) AS 'p3_orders',
    COUNT(DISTINCT CASE WHEN order_items.product_id=3 THEN order_item_refunds.order_item_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN order_items.product_id=3 THEN order_items.order_item_id ELSE NULL END) AS 'p3_refund_rt',
    COUNT(DISTINCT CASE WHEN order_items.product_id=4 THEN order_items.order_item_id ELSE NULL END) AS 'p4_orders',
    COUNT(DISTINCT CASE WHEN order_items.product_id=4 THEN order_item_refunds.order_item_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN order_items.product_id=4 THEN order_items.order_item_id ELSE NULL END) AS 'p4_refund_rt'
FROM order_items
LEFT JOIN order_item_refunds
ON order_items.order_item_id = order_item_refunds.order_item_id
WHERE order_items.created_at < '2014-10-15'
GROUP BY 1,2
;


-- +------+------+-----------+--------------+-----------+--------------+-----------+--------------+-----------+--------------+
-- | yr   | mn   | p1_orders | p1_refund_rt | p2_orders | p2_refund_rt | p3_orders | p3_refund_rt | p4_orders | p4_refund_rt |
-- +------+------+-----------+--------------+-----------+--------------+-----------+--------------+-----------+--------------+
-- | 2012 |    3 |        60 |       0.0167 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2012 |    4 |        99 |       0.0505 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2012 |    5 |       107 |       0.0374 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2012 |    6 |       141 |       0.0567 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2012 |    7 |       169 |       0.0828 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2012 |    8 |       228 |       0.0746 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2012 |    9 |       287 |       0.0906 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2012 |   10 |       371 |       0.0728 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2012 |   11 |       618 |       0.0744 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2012 |   12 |       506 |       0.0593 |         0 |         NULL |         0 |         NULL |         0 |         NULL |
-- | 2013 |    1 |       343 |       0.0496 |        47 |       0.0213 |         0 |         NULL |         0 |         NULL |
-- | 2013 |    2 |       336 |       0.0714 |       162 |       0.0123 |         0 |         NULL |         0 |         NULL |
-- | 2013 |    3 |       320 |       0.0563 |        65 |       0.0462 |         0 |         NULL |         0 |         NULL |
-- | 2013 |    4 |       459 |       0.0414 |        93 |       0.0108 |         0 |         NULL |         0 |         NULL |
-- | 2013 |    5 |       489 |       0.0634 |        82 |       0.0244 |         0 |         NULL |         0 |         NULL |
-- | 2013 |    6 |       503 |       0.0775 |        91 |       0.0549 |         0 |         NULL |         0 |         NULL |
-- | 2013 |    7 |       508 |       0.0728 |        95 |       0.0316 |         0 |         NULL |         0 |         NULL |
-- | 2013 |    8 |       510 |       0.0549 |        98 |       0.0102 |         0 |         NULL |         0 |         NULL |
-- | 2013 |    9 |       538 |       0.0428 |        98 |       0.0102 |         0 |         NULL |         0 |         NULL |
-- | 2013 |   10 |       603 |       0.0282 |       135 |       0.0148 |         0 |         NULL |         0 |         NULL |
-- | 2013 |   11 |       724 |       0.0345 |       174 |       0.0230 |         0 |         NULL |         0 |         NULL |
-- | 2013 |   12 |       818 |       0.0232 |       183 |       0.0219 |       139 |       0.0719 |         0 |         NULL |
-- | 2014 |    1 |       728 |       0.0426 |       183 |       0.0219 |       200 |       0.0650 |         0 |         NULL |
-- | 2014 |    2 |       584 |       0.0394 |       351 |       0.0171 |       211 |       0.0664 |       202 |       0.0099 |
-- | 2014 |    3 |       784 |       0.0306 |       192 |       0.0156 |       244 |       0.0697 |       205 |       0.0049 |
-- | 2014 |    4 |       917 |       0.0349 |       215 |       0.0186 |       267 |       0.0674 |       259 |       0.0154 |
-- | 2014 |    5 |      1031 |       0.0291 |       246 |       0.0163 |       298 |       0.0570 |       297 |       0.0067 |
-- | 2014 |    6 |       892 |       0.0572 |       245 |       0.0367 |       289 |       0.0554 |       250 |       0.0240 |
-- | 2014 |    7 |       959 |       0.0438 |       242 |       0.0372 |       275 |       0.0400 |       260 |       0.0154 |
-- | 2014 |    8 |       961 |       0.1374 |       239 |       0.0167 |       295 |       0.0678 |       307 |       0.0065 |
-- | 2014 |    9 |      1056 |       0.1326 |       250 |       0.0320 |       317 |       0.0662 |       327 |       0.0122 |
-- | 2014 |   10 |       511 |       0.0274 |       136 |       0.0074 |       164 |       0.0488 |       154 |       0.0325 |
-- +------+------+-----------+--------------+-----------+--------------+-----------+--------------+-----------+--------------+