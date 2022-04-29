-- 78 Product-level website pathing
-- Compare clickthrough rates from '2012-10-06' to '2013-04-06'
-- i. Start at the '/products' page and add a col with pre_product_2 and post_product_2
-- ii. From that table, count num of pageviews (1=no next page) per session 
-- iii. From there, group by pre/post col and do counts 

DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT
    *,
    CASE
        WHEN created_at BETWEEN '2013-01-06' AND '2013-04-06' THEN "post_product_2"
        ELSE "pre_product_2"
    END AS "pre_post"
FROM website_pageviews
WHERE pageview_url IN ('/products','/the-original-mr-fuzzy','/cart','/shipping','/billing'
    '/thank-you-for-your-order','/the-forever-love-bear')
    AND created_at BETWEEN '2012-10-06' AND'2013-04-06'
; -- Assuming they have to go to products first to select their product

DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT
    temp1.website_session_id,
    COUNT(DISTINCT temp1.website_pageview_id) as 'num_pages_viewed'
FROM  temp1 
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id=temp1.website_session_id
GROUP BY 1
;

SELECT
    temp1.pre_post as "time_period",
    COUNT(DISTINCT temp1.website_session_id) as "sessions",
    COUNT(DISTINCT CASE WHEN temp2.num_pages_viewed > 1 THEN temp1.website_session_id ELSE NULL END) AS "w_next_page",
    ROUND(COUNT(DISTINCT CASE WHEN temp2.num_pages_viewed > 1 THEN temp1.website_session_id ELSE NULL END)*100.0/
    COUNT(DISTINCT temp1.website_session_id),2) as 'pct_w_next_pg',
    COUNT(DISTINCT CASE WHEN temp1.pageview_url='/the-original-mr-fuzzy' THEN temp1.website_session_id ELSE NULL END) AS 'to_mrfuzzy',
    ROUND(COUNT(DISTINCT CASE WHEN temp1.pageview_url='/the-original-mr-fuzzy' THEN temp1.website_session_id ELSE NULL END)*100.0/
    COUNT(DISTINCT temp1.website_session_id),2) AS 'pct_to_mrfuzzy',
    COUNT(DISTINCT CASE WHEN temp1.pageview_url='/the-forever-love-bear' THEN temp1.website_session_id ELSE NULL END) AS 'to_lovebear',
    ROUND(COUNT(DISTINCT CASE WHEN temp1.pageview_url='/the-forever-love-bear' THEN temp1.website_session_id ELSE NULL END)*100.0/
    COUNT(DISTINCT temp1.website_session_id),2) AS 'pct_to_lovebear'

FROM temp1
LEFT JOIN temp2
ON temp1.website_session_id = temp2.website_session_id
GROUP BY temp1.pre_post
ORDER BY sessions DESC
;

-- +----------------+----------+-------------+---------------+------------+----------------+-------------+-----------------+
-- | time_period    | sessions | w_next_page | pct_w_next_pg | to_mrfuzzy | pct_to_mrfuzzy | to_lovebear | pct_to_lovebear |
-- +----------------+----------+-------------+---------------+------------+----------------+-------------+-----------------+
-- | pre_product_2  |    15700 |       11351 |         72.30 |      11350 |          72.29 |           0 |            0.00 |
-- | post_product_2 |    10709 |        8200 |         76.57 |       6654 |          62.13 |        1546 |           14.44 |
-- +----------------+----------+-------------+---------------+------------+----------------+-------------+-----------------+