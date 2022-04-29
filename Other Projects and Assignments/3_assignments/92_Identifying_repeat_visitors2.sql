-- 92 Identifying repeat visitors
-- STUDYING HIS SOLUTION

-- repeat_sessions | users
-- BETWEEN '2014-01-01' AND '2014-11-01'

-- First get all session id's with 0 (non repeat), then join repeat website sessions back to these
-- on user id => will know which sessions are repeat sessions

-- Then count the number of times repeat sessions were repeated

-- X Then join back to all sessions and group by repeat_sessions

USE mavenfuzzyfactory;

DROP TABLE IF EXISTS first_sessions;
CREATE TEMPORARY TABLE first_sessions
SELECT 
*
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01'
    AND is_repeat_session = 0
;


DROP TABLE IF EXISTS all_sessions_with_repeats;

CREATE TEMPORARY TABLE all_sessions_with_repeats
SELECT
    first_sessions.user_id,
    first_sessions.website_session_id AS new_session_id,
    website_sessions.website_session_id AS repeat_session_id
FROM first_sessions
LEFT JOIN website_sessions
ON first_sessions.user_id = website_sessions.user_id
AND website_sessions.is_repeat_session=1
AND website_sessions.website_session_id > first_sessions.website_session_id
AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-01'
;

DROP TABLE IF EXISTS temp1;

CREATE TEMPORARY TABLE temp1
SELECT
    user_id,
    COUNT(DISTINCT new_session_id) AS new_sessions,
    COUNT(DISTINCT repeat_session_id) AS repeat_sessions
FROM all_sessions_with_repeats
GROUP BY 1;


SELECT
    repeat_sessions,
    COUNT(DISTINCT user_id)
FROM temp1
GROUP BY 1;

------------------------------------------------------------------------------------------------




DROP TABLE IF EXISTS temp2;

CREATE TEMPORARY TABLE temp2
SELECT
    user_id,
    -- COUNT(DISTINCT new_session_id) AS new_sessions,
    -- CASE WHEN (DISTINCT new_session_id) AS new_sessions,
    MIN(DISTINCT repeat_session_id) AS repeat_sessions
    -- CASE WHEN repeat_session_id IS NOT NULL THEN new_session_id ELSE 0 END AS prev_session_id
FROM all_sessions_with_repeats
GROUP BY 1;

DROP TABLE IF EXISTS temp3;

CREATE TEMPORARY TABLE temp3
SELECT
    temp2.user_id,
    temp2.repeat_sessions as repeat_id,
    CASE WHEN all_sessions_with_repeats.repeat_session_id IS NOT NULL THEN all_sessions_with_repeats.new_session_id ELSE 0 END AS prev_session_id
FROM temp2
LEFT JOIN all_sessions_with_repeats
ON all_sessions_with_repeats.user_id = temp2.user_id
WHERE temp2.repeat_sessions IS NOT NULL
;

DROP TABLE IF EXISTS temp4;

CREATE TEMPORARY TABLE temp4
SELECT 
    temp3.user_id,
    temp3.repeat_id,
    temp3.prev_session_id,
    CASE WHEN website_sessions.website_session_id = temp3.repeat_id THEN website_sessions.created_at ELSE NULL END AS repeat_created_at,
    CASE WHEN website_sessions.website_session_id = temp3.prev_session_id THEN website_sessions.created_at ELSE NULL END AS prev_created_at
FROM temp3
LEFT JOIN website_sessions
ON website_sessions.user_id =  temp3.user_id
;

DROP TABLE IF EXISTS temp5;
CREATE TEMPORARY TABLE temp5
SELECT 
    temp4.user_id,
    temp4.repeat_id,
    temp4.prev_session_id,
    MAX(repeat_created_at),
    MAX(prev_created_at)

FROM temp4
GROUP BY 1,2,3
;







-- DROP TABLE IF EXISTS times_repeated;
-- CREATE TEMPORARY TABLE times_repeated
-- SELECT 
--     user_id,
--     COUNT(DISTINCT website_session_id) as 'extra_repeats'
-- FROM repeat_sessions_only
-- GROUP BY 1
-- ;

 

-- DROP TABLE IF EXISTS all_sessions_with_repeats;

-- CREATE TEMPORARY TABLE all_sessions_with_repeats
-- SELECT
--     website_sessions.user_id,
--     CASE
--         WHEN times_repeated.extra_repeats IS NULL THEN 0
--         WHEN times_repeated.extra_repeats = 1  THEN 1
--         WHEN times_repeated.extra_repeats = 2  THEN 2
--         WHEN times_repeated.extra_repeats = 3 THEN 3
--     END AS "num_repeats"

-- FROM 
--     website_sessions
-- LEFT JOIN times_repeated
-- ON website_sessions.user_id = times_repeated.user_id
-- -- GROUP BY 1
-- ;
-- DROP TABLE IF EXISTS temp1;

-- CREATE TEMPORARY TABLE temp1
-- SELECT 
--     user_id,
--     MAX(num_repeats) as tot_repeats
-- FROM all_sessions_with_repeats
-- GROUP BY 1;


-- DROP TABLE IF EXISTS repeat_sessions;
-- CREATE TEMPORARY TABLE repeat_sessions
-- SELECT
--     first_sessions.user_id,
--     COUNT(DISTINCT website_sessions.website_session_id) as "num_sessions"
--     -- website_sessions.is_repeat_session,
--     -- first_sessions.created_at

-- FROM
--     first_sessions
-- LEFT JOIN
--     website_sessions
--     ON website_sessions.user_id = first_sessions.user_id
--     -- AND website_sessions.website_session_id > first_sessions.website_session_id -- just in case
-- WHERE first_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-01' -- just in case some sessions continued to a day not in period, for example
-- AND website_sessions.is_repeat_session = 1
-- GROUP BY 1
-- ;

DROP TABLE IF EXISTS count_sessions_by_user;
-- CREATE TEMPORARY TABLE count_sessions_by_user
-- SELECT
--     user_id,
--     COUNT(DISTINCT website_session_id) as "num_visits"
--     FROM repeat_sessions
--     -- WHERE is_repeat_session IS NOT NULL
-- GROUP BY user_id
-- ;


DROP TABLE IF EXISTS repeat_sessions_only;

CREATE TEMPORARY TABLE repeat_sessions_only
SELECT 
*
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01'
    AND is_repeat_session = 1
;

DROP TABLE IF EXISTS all_sessions;
CREATE TEMPORARY TABLE all_sessions
SELECT 
*
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-01'
;
