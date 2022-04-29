-- 75 Monthly orders volume, overall conversion rates, revenue per session, breakdown of sales by product
-- Between '2012-04-01' and '2013-04-05'

SELECT
    YEAR(website_sessions.created_at) as 'yr',
    MONTH(website_sessions.created_at) as 'mn',
    COUNT(DISTINCT orders.order_id) as 'orders',
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) as "conv_rate",
    (COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id))*AVG(price_usd) as "revenue_per_session", -- conv_rate times avg rev per session
    COUNT(DISTINCT CASE WHEN orders.primary_product_id=1 THEN orders.order_id ELSE NULL END) as "product_one_orders",
    COUNT(DISTINCT CASE WHEN orders.primary_product_id=2 THEN orders.order_id ELSE NULL END) as "product_two_orders"

FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id=orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-04-01' and '2013-04-01'
GROUP BY 1, 2
;

-- +------+------+--------+-----------+---------------------+--------------------+--------------------+
-- | yr   | mn   | orders | conv_rate | revenue_per_session | product_one_orders | product_two_orders |
-- +------+------+--------+-----------+---------------------+--------------------+--------------------+
-- | 2012 |    4 |     99 |    0.0265 |        1.3261012767 |                 99 |                  0 |
-- | 2012 |    5 |    108 |    0.0289 |        1.4458810659 |                108 |                  0 |
-- | 2012 |    6 |    140 |    0.0353 |        1.7642046885 |                140 |                  0 |
-- | 2012 |    7 |    169 |    0.0398 |        1.9901789846 |                169 |                  0 |
-- | 2012 |    8 |    228 |    0.0374 |        1.8690914569 |                228 |                  0 |
-- | 2012 |    9 |    287 |    0.0439 |        2.1927449133 |                287 |                  0 |
-- | 2012 |   10 |    371 |    0.0453 |        2.2667183656 |                371 |                  0 |
-- | 2012 |   11 |    618 |    0.0441 |        2.2035534512 |                618 |                  0 |
-- | 2012 |   12 |    506 |    0.0502 |        2.5114118172 |                506 |                  0 |
-- | 2013 |    1 |    391 |    0.0611 |        3.1270254344 |                344 |                 47 |
-- | 2013 |    2 |    497 |    0.0693 |        3.6921079533 |                335 |                162 |
-- | 2013 |    3 |    385 |    0.0615 |        3.1788064902 |                320 |                 65 |
-- +------+------+--------+-----------+---------------------+--------------------+--------------------+
