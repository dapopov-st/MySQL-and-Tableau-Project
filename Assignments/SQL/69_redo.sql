SELECT temp.hour,
    ROUND(AVG(DISTINCT CASE WHEN day = 0 THEN sessions ELSE NULL END),1) AS 'mon',
    ROUND(AVG(DISTINCT CASE WHEN day = 1 THEN sessions ELSE NULL END),1) AS 'tue',
    ROUND(AVG(DISTINCT CASE WHEN day = 2 THEN sessions ELSE NULL END),1) AS 'wed',
    ROUND(AVG(DISTINCT CASE WHEN day = 3 THEN sessions ELSE NULL END),1) AS 'thur',
    ROUND(AVG(DISTINCT CASE WHEN day = 4 THEN sessions ELSE NULL END),1) AS 'fri',
    ROUND(AVG(DISTINCT CASE WHEN day = 5 THEN sessions ELSE NULL END),1) AS 'sat',
    ROUND(AVG(DISTINCT CASE WHEN day = 6 THEN sessions ELSE NULL END),1) AS 'sun'

FROM(
SELECT
    DATE(created_at),
    WEEKDAY(created_at) as 'day', -- will need the day for cols
    HOUR(created_at) as 'hour', --  will need the hour for first col
    COUNT(DISTINCT website_session_id) as "sessions"
FROM
    website_sessions

WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1,2,3) AS temp
GROUP BY 1
;