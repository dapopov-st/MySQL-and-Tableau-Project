-- 55. Analyzing Channel Portfolios
-- Between 2012-08-22 AND 2012-11-29, nonbrand -- remember that dates are in reversed European format!
-- week_start_date, gsearch_sessions, bsearch_sessions
-- weekly trended session volume

SELECT
    MIN(DATE(created_at)) AS "week_start_date",
    COUNT(DISTINCT CASE WHEN utm_source='gsearch' THEN website_session_id ELSE NULL END) as  "gsearch_sessions",
    COUNT(DISTINCT CASE WHEN utm_source='bsearch' THEN website_session_id ELSE NULL END) as  "bsearch_sessions"
FROM
    website_sessions
WHERE created_at >'2012-08-22' AND created_at <'2012-11-29'
AND utm_campaign='nonbrand'
GROUP BY YEARWEEK(created_at)
;

-- +-----------------+------------------+------------------+
-- | week_start_date | gsearch_sessions | bsearch_sessions |
-- +-----------------+------------------+------------------+
-- | 2012-08-22      |              593 |              196 |
-- | 2012-08-26      |             1059 |              343 |
-- | 2012-09-02      |              920 |              290 |
-- | 2012-09-09      |              950 |              329 |
-- | 2012-09-16      |             1154 |              362 |
-- | 2012-09-23      |             1052 |              323 |
-- | 2012-09-30      |              999 |              318 |
-- | 2012-10-07      |              996 |              330 |
-- | 2012-10-14      |             1258 |              419 |
-- | 2012-10-21      |             1306 |              430 |
-- | 2012-10-28      |             1210 |              385 |
-- | 2012-11-04      |             1353 |              430 |
-- | 2012-11-11      |             1246 |              438 |
-- | 2012-11-18      |             3508 |             1093 |
-- | 2012-11-25      |             2286 |              774 |
-- +-----------------+------------------+------------------+

