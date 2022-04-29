-- 64. Analyzing direct traffic
-- Organic search, direct type in, paid brand search sessions by month, 
-- and show these as % of paid search nonbrand
-- utm_source is NULL and http_referer is NULL THEN 'direct type_in'
-- utm_source is NULL and http_referer is NOT NULL THEN 'organic' of the http_referrer type (gsearch,bsearch)

SELECT
    YEAR(created_at) as 'yr',
    MONTH(created_at) as 'mn',
    COUNT(CASE WHEN utm_campaign='nonbrand' THEN website_session_id ELSE NULL END) as "nonbrand",
    COUNT(CASE WHEN utm_campaign='brand' THEN website_session_id ELSE NULL END) as "brand",
    COUNT(CASE WHEN utm_campaign='brand' THEN website_session_id ELSE NULL END)/
    COUNT(CASE WHEN utm_campaign='nonbrand' THEN website_session_id ELSE NULL END) as "brand_pct_of_nonbrand",
    COUNT(CASE WHEN http_referer IS NULL AND utm_source IS NULL THEN website_session_id ELSE NULL END) as "direct",
    COUNT(CASE WHEN http_referer IS NULL AND utm_source IS NULL THEN website_session_id ELSE NULL END)*100.0/
    COUNT(CASE WHEN utm_campaign='nonbrand' THEN website_session_id ELSE NULL END) AS "direct_pct_of_nonbrand",
    COUNT(CASE WHEN http_referer IS NOT NULL AND utm_source IS  NULL THEN website_session_id ELSE NULL END) as "organic",
    COUNT(CASE WHEN http_referer IS NOT NULL AND utm_source IS  NULL THEN website_session_id ELSE NULL END)*100.0/
    COUNT(CASE WHEN utm_campaign='nonbrand' THEN website_session_id ELSE NULL END) AS "organic_pct_of_nonbrand"
FROM website_sessions
WHERE created_at>='2012-03-01' AND created_at<='2012-12-23'
GROUP BY 1,2;

-- +------+------+----------+-------+-----------------------+--------+------------------------+---------+-------------------------+
-- | yr   | mn   | nonbrand | brand | brand_pct_of_nonbrand | direct | direct_pct_of_nonbrand | organic | organic_pct_of_nonbrand |
-- +------+------+----------+-------+-----------------------+--------+------------------------+---------+-------------------------+
-- | 2012 |    3 |     1850 |    10 |                0.0054 |      9 |                0.48649 |       8 |                 0.43243 |
-- | 2012 |    4 |     3507 |    76 |                0.0217 |     71 |                2.02452 |      78 |                 2.22412 |
-- | 2012 |    5 |     3294 |   139 |                0.0422 |    151 |                4.58409 |     150 |                 4.55373 |
-- | 2012 |    6 |     3442 |   165 |                0.0479 |    170 |                4.93899 |     190 |                 5.52005 |
-- | 2012 |    7 |     3656 |   195 |                0.0533 |    187 |                5.11488 |     207 |                 5.66193 |
-- | 2012 |    8 |     5320 |   263 |                0.0494 |    250 |                4.69925 |     265 |                 4.98120 |
-- | 2012 |    9 |     5588 |   339 |                0.0607 |    285 |                5.10021 |     331 |                 5.92341 |
-- | 2012 |   10 |     6883 |   431 |                0.0626 |    440 |                6.39256 |     428 |                 6.21822 |
-- | 2012 |   11 |    12267 |   558 |                0.0455 |    571 |                4.65476 |     624 |                 5.08682 |
-- | 2012 |   12 |     6643 |   464 |                0.0698 |    482 |                7.25576 |     492 |                 7.40629 |
-- +------+------+----------+-------+-----------------------+--------+------------------------+---------+-------------------------+


