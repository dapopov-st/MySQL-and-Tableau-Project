SELECT
    YEAR(website_sessions.created_at) AS 'year',
    QUARTER(website_sessions.created_at) AS 'quarter',
    COUNT(DISTINCT website_sessions.website_session_id) AS 'sessions',
    COUNT(DISTINCT orders.order_id) AS 'orders',
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS 'conv_rate',
    SUM(orders.price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS 'revenue_per_session',
    SUM(orders.price_usd)/COUNT(DISTINCT orders.order_id) AS 'revenue_per_order'


FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-03-20'
GROUP BY 1,2
;

-- +------+---------+----------+--------+-----------+---------------------+-------------------+
-- | year | quarter | sessions | orders | conv_rate | revenue_per_session | revenue_per_order |
-- +------+---------+----------+--------+-----------+---------------------+-------------------+
-- | 2012 |       1 |     1877 |     60 |    0.0320 |            1.597975 |         49.990000 |
-- | 2012 |       2 |    11433 |    347 |    0.0304 |            1.517233 |         49.990000 |
-- | 2012 |       3 |    16886 |    684 |    0.0405 |            2.024941 |         49.990000 |
-- | 2012 |       4 |    32274 |   1495 |    0.0463 |            2.315643 |         49.990000 |
-- | 2013 |       1 |    19828 |   1273 |    0.0642 |            3.347653 |         52.142396 |
-- | 2013 |       2 |    24737 |   1717 |    0.0694 |            3.577347 |         51.539214 |
-- | 2013 |       3 |    27665 |   1841 |    0.0665 |            3.442672 |         51.733585 |
-- | 2013 |       4 |    40551 |   2616 |    0.0645 |            3.529783 |         54.715688 |
-- | 2014 |       1 |    46759 |   3068 |    0.0656 |            4.077529 |         62.145098 |
-- | 2014 |       2 |    53125 |   3848 |    0.0724 |            4.663942 |         64.389797 |
-- | 2014 |       3 |    57146 |   4036 |    0.0706 |            4.554774 |         64.491355 |
-- | 2014 |       4 |    76392 |   5908 |    0.0773 |            4.933658 |         63.793497 |
-- | 2015 |       1 |    64198 |   5420 |    0.0844 |            5.301965 |         62.799917 |
-- +------+---------+----------+--------+-----------+---------------------+-------------------+