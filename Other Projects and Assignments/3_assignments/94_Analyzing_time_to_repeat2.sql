DROP TABLE IF EXISTS all_sessions_with_repeats;

CREATE TEMPORARY TABLE all_sessions_with_repeats
SELECT
    first_sessions.user_id,
    first_sessions.website_session_id AS first_session_id,
    website_sessions.website_session_id AS repeat_session_id,
    first_sessions.created_at as first_created_at,
    website_sessions.created_at as repeat_sessions_created_at
    -- website_sessions.created_at as web_created_at,
    -- first_sessions.created_at as rep_reated_at
FROM (
    SELECT 
    *
    FROM website_sessions
    WHERE created_at BETWEEN '2014-01-01' AND '2014-11-02'  -- inclusive
    AND is_repeat_session = 0
) AS first_sessions
LEFT JOIN website_sessions
ON first_sessions.user_id = website_sessions.user_id
AND website_sessions.is_repeat_session=1
AND website_sessions.website_session_id > first_sessions.website_session_id
AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-11-02'
;

SELECT 
    AVG(DATEDIFF(sessions_with_dates.min_repeat_created_at,sessions_with_dates.first_created_at)) AS avg_day_first_to_second,
    MIN(DATEDIFF(sessions_with_dates.min_repeat_created_at,sessions_with_dates.first_created_at)) AS min_day_first_to_second,
    MAX(DATEDIFF(sessions_with_dates.min_repeat_created_at,sessions_with_dates.first_created_at)) AS max_day_first_to_second

FROM
(
SELECT    
    user_id,
    first_session_id,
    first_created_at,
    MIN(DISTINCT repeat_session_id) AS min_repeat_session_id,
    MIN(DISTINCT repeat_sessions_created_at) AS min_repeat_created_at

FROM all_sessions_with_repeats
WHERE repeat_session_id IS NOT NULL
GROUP BY 1,2,3
) AS sessions_with_dates
;

-- +-------------------------+-------------------------+-------------------------+
-- | avg_day_first_to_second | min_day_first_to_second | max_day_first_to_second |
-- +-------------------------+-------------------------+-------------------------+
-- |                 33.2589 |                       0 |                      69 |
-- +-------------------------+-------------------------+-------------------------+