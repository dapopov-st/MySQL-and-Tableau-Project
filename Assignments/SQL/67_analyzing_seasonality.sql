-- 67. Monthly and weekly volume patterns for 2012 for sessions and orders

SELECT
    YEAR(website_sessions.created_at) as 'yr',
    MONTH(website_sessions.created_at) as 'mo',
    COUNT(DISTINCT website_sessions.website_session_id) as 'sessions',
    COUNT(DISTINCT orders.order_id) as 'orders'
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id 
WHERE website_sessions.created_at < '2013-01-01'
GROUP BY 1,2
;

SELECT
    MIN(DATE(website_sessions.created_at)) as 'week_start_date',
    COUNT(DISTINCT website_sessions.website_session_id) as 'sessions',
    COUNT(DISTINCT orders.order_id) as 'orders'
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id 
WHERE website_sessions.created_at < '2013-01-01'
GROUP BY YEARWEEK(website_sessions.created_at)
;

-- +------+------+----------+--------+
-- | yr   | mo   | sessions | orders |
-- +------+------+----------+--------+
-- | 2012 |    3 |     1877 |     60 |
-- | 2012 |    4 |     3732 |     99 |
-- | 2012 |    5 |     3734 |    108 |
-- | 2012 |    6 |     3967 |    140 |
-- | 2012 |    7 |     4245 |    169 |
-- | 2012 |    8 |     6098 |    228 |
-- | 2012 |    9 |     6543 |    287 |
-- | 2012 |   10 |     8182 |    371 |
-- | 2012 |   11 |    14020 |    618 |
-- | 2012 |   12 |    10072 |    506 |
-- +------+------+----------+--------+


-- +-----------------+----------+--------+
-- | week_start_date | sessions | orders |
-- +-----------------+----------+--------+
-- | 2012-03-19      |      893 |     25 |
-- | 2012-03-25      |      984 |     35 |
-- | 2012-04-01      |     1188 |     29 |
-- | 2012-04-08      |     1034 |     27 |
-- | 2012-04-15      |      680 |     23 |
-- | 2012-04-22      |      653 |     18 |
-- | 2012-04-29      |      770 |     19 |
-- | 2012-05-06      |      798 |     17 |
-- | 2012-05-13      |      709 |     23 |
-- | 2012-05-20      |      961 |     28 |
-- | 2012-05-27      |      876 |     30 |
-- | 2012-06-03      |      920 |     34 |
-- | 2012-06-10      |      995 |     30 |
-- | 2012-06-17      |      964 |     37 |
-- | 2012-06-24      |      885 |     32 |
-- | 2012-07-01      |      893 |     30 |
-- | 2012-07-08      |      922 |     36 |
-- | 2012-07-15      |      987 |     46 |
-- | 2012-07-22      |      955 |     42 |
-- | 2012-07-29      |     1172 |     55 |
-- | 2012-08-05      |     1236 |     48 |
-- | 2012-08-12      |     1179 |     39 |
-- | 2012-08-19      |     1521 |     55 |
-- | 2012-08-26      |     1597 |     52 |
-- | 2012-09-02      |     1411 |     56 |
-- | 2012-09-09      |     1489 |     71 |
-- | 2012-09-16      |     1776 |     77 |
-- | 2012-09-23      |     1628 |     69 |
-- | 2012-09-30      |     1554 |     68 |
-- | 2012-10-07      |     1626 |     73 |
-- | 2012-10-14      |     1955 |     93 |
-- | 2012-10-21      |     2045 |     95 |
-- | 2012-10-28      |     1923 |     81 |
-- | 2012-11-04      |     2091 |     92 |
-- | 2012-11-11      |     1973 |    101 |
-- | 2012-11-18      |     5130 |    223 |
-- | 2012-11-25      |     4172 |    179 |
-- | 2012-12-02      |     2727 |    145 |
-- | 2012-12-09      |     2489 |    123 |
-- | 2012-12-16      |     2718 |    135 |
-- | 2012-12-23      |     1682 |     74 |
-- | 2012-12-30      |      309 |     21 |
-- +-----------------+----------+--------+