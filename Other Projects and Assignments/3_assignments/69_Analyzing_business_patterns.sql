-- 69 Analyzing business patterns
-- Average website session volume by hour of day and day of week
-- created_at > '2012-09-14' AND created_at < '2012-11-16'
-- Columns hr | mon-sun

-- First create a temp table grouped by date, weekday, and hour
-- Then display the averages grouped by hour -> Columns hr | mon-sun

DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT 
    DATE(created_at) as "day",
    WEEKDAY(created_at) as "wkday",
    HOUR(created_at) as 'hr',
    COUNT(DISTINCT website_session_id) as "sessions"
   
FROM website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1,2,3;

SELECT
    hr,
    ROUND(AVG(DISTINCT CASE WHEN wkday=0 THEN sessions ELSE NULL END),1) as 'mon',
    ROUND(AVG(DISTINCT CASE WHEN wkday=1 THEN sessions ELSE NULL END),1) as 'tue',
    ROUND(AVG(DISTINCT CASE WHEN wkday=2 THEN sessions ELSE NULL END),1) as 'wed',
    ROUND(AVG(DISTINCT CASE WHEN wkday=3 THEN sessions ELSE NULL END),1) as 'thur',
    ROUND(AVG(DISTINCT CASE WHEN wkday=4 THEN sessions ELSE NULL END),1) as 'fri',
    ROUND(AVG(DISTINCT CASE WHEN wkday=5 THEN sessions ELSE NULL END),1) as 'sat',
    ROUND(AVG(DISTINCT CASE WHEN wkday=6 THEN sessions ELSE NULL END),1) as 'sun'

FROM temp1
GROUP BY 1;


-- +------+------+------+------+------+------+------+------+
-- | hr   | mon  | tue  | wed  | thur | fri  | sat  | sun  |
-- +------+------+------+------+------+------+------+------+
-- |    0 |  9.7 |  8.2 |  8.0 |  9.0 |  9.6 |  7.5 |  5.0 |
-- |    1 |  8.0 |  6.6 |  5.2 |  7.3 |  7.5 |  4.2 |  4.8 |
-- |    2 |  6.3 |  6.6 |  5.3 |  5.0 |  7.2 |  5.7 |  3.5 |
-- |    3 |  6.0 |  5.4 |  4.0 |  5.8 |  4.8 |  3.8 |  3.0 |
-- |    4 |  5.8 |  5.4 |  6.0 |  5.6 |  5.0 |  4.8 |  3.2 |
-- |    5 |  5.0 |  5.7 |  5.8 |  3.5 |  5.3 |  3.0 |  2.5 |
-- |    6 |  5.3 |  6.6 |  4.5 |  6.6 |  6.4 |  5.2 |  4.3 |
-- |    7 |  6.4 |  7.3 |  5.2 |  6.2 |  6.8 |  4.7 |  3.6 |
-- |    8 |  9.2 |  8.1 |  9.3 | 10.6 |  7.5 |  5.4 |  5.6 |
-- |    9 | 14.3 | 13.7 | 15.5 | 16.4 | 11.1 |  4.6 |  5.6 |
-- |   10 | 18.0 | 15.2 | 18.9 | 18.1 | 18.3 |  9.3 |  5.3 |
-- |   11 | 19.1 | 17.4 | 22.3 | 20.7 | 19.5 |  7.8 |  6.7 |
-- |   12 | 18.2 | 21.8 | 23.7 | 22.6 | 19.8 |  8.0 |  6.2 |
-- |   13 | 22.3 | 22.3 | 23.1 | 23.8 | 20.2 |  8.2 |  8.7 |
-- |   14 | 18.1 | 23.4 | 21.3 | 20.7 | 22.1 |  7.8 |  7.5 |
-- |   15 | 17.6 | 20.5 | 21.8 | 18.0 | 19.2 |  8.8 |  7.8 |
-- |   16 | 23.0 | 19.7 | 24.8 | 24.3 | 20.0 |  6.4 |  5.7 |
-- |   17 | 19.9 | 20.9 | 22.5 | 18.7 | 20.6 |  8.7 |  5.6 |
-- |   18 | 17.4 | 16.4 | 19.0 | 18.0 | 12.3 |  7.4 |  8.7 |
-- |   19 | 12.4 | 13.9 | 14.3 | 14.9 | 11.0 |  5.1 |  6.7 |
-- |   20 | 11.6 | 14.4 | 14.0 | 12.1 | 13.5 |  6.8 |  7.7 |
-- |   21 | 10.5 | 13.8 | 13.3 | 11.0 | 10.7 |  6.5 |  8.8 |
-- |   22 |  9.6 | 10.8 | 10.8 | 10.3 |  8.1 |  5.0 | 10.2 |
-- |   23 |  9.4 |  9.2 |  9.4 | 11.7 |  5.3 |  5.1 | 10.0 |
-- +------+------+------+------+------+------+------+------+




