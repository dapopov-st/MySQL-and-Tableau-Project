SELECT
    CASE
        WHEN http_referer IS  NULL AND utm_source IS  NULL  THEN "direct_type_in"
        WHEN http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') AND utm_source IS  NULL THEN "organic_search"
        WHEN utm_campaign='brand' THEN "paid_brand"
        WHEN utm_campaign='nonbrand' THEN "paid_nonbrand"
        WHEN utm_source IS NULL AND http_referer IS NULL then 'direct_type_in'
        WHEN utm_source='socialbook' THEN 'paid_social'
    END AS 'channel_group',
    -- http_referer,
    -- utm_source,
    -- utm_campaign,
    COUNT(DISTINCT CASE WHEN is_repeat_session=0 THEN website_session_id ELSE NULL END) AS "new_session",
    COUNT(DISTINCT CASE WHEN is_repeat_session=1 THEN website_session_id ELSE NULL END) AS "repeat_session"
    
FROM
    website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-05'
GROUP BY 1;

-- +----------------+-------------+----------------+
-- | channel_group  | new_session | repeat_session |
-- +----------------+-------------+----------------+
-- | direct_type_in |        6588 |          10566 |
-- | organic_search |        7138 |          11509 |
-- | paid_brand     |        6434 |          11027 |
-- | paid_nonbrand  |      119957 |              0 |
-- | paid_social    |        7654 |              0 |
-- +----------------+-------------+----------------+