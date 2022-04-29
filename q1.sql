-- End date: created_at < '2015-03-20'
-- QUARTER(created_at)
-- Session and order volume trended by quarter for the life of the business

SELECT
    YEAR(website_sessions.created_at) AS 'year',
    QUARTER(website_sessions.created_at) AS 'quarter',
    COUNT(DISTINCT website_sessions.website_session_id) AS 'sessions',
    COUNT(DISTINCT orders.order_id) AS 'orders'

FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2015-03-20'
GROUP BY 1,2
;


-- +------+---------+----------+--------+
-- | year | quarter | sessions | orders |
-- +------+---------+----------+--------+
-- | 2012 |       1 |     1882 |     60 |
-- | 2012 |       2 |    11431 |    347 |
-- | 2012 |       3 |    16904 |    684 |
-- | 2012 |       4 |    32265 |   1496 |
-- | 2013 |       1 |    19839 |   1273 |
-- | 2013 |       2 |    24748 |   1718 |
-- | 2013 |       3 |    27656 |   1839 |
-- | 2013 |       4 |    40553 |   2618 |
-- | 2014 |       1 |    46777 |   3069 |
-- | 2014 |       2 |    53132 |   3850 |
-- | 2014 |       3 |    57147 |   4033 |
-- | 2014 |       4 |    76395 |   5911 |
-- | 2015 |       1 |    64142 |   5415 |
-- +------+---------+----------+--------+