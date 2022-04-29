-- Make a temp1 table with all cols in website_pageviews where sessions hit /product + pre/post column => will group on it later

-- Left join temp1 back to website_pageviews on website_session_id to bring in the remaining website_pageview/session info

-- Group above table by website_session_id, counting website pageviews (save as mult_pgvw col)

-- Left join above to orders on website session id, w_next_page being cols having mult_pgvw > 1 
DROP TABLE IF EXISTS temp1;
CREATE TEMPORARY TABLE temp1
SELECT *,
    CASE WHEN created_at BETWEEN '2013-01-06' AND '2013-04-06' THEN 'post_product_2' 
    ELSE 'pre_product_2' END AS 'pre_post'
FROM website_pageviews
WHERE pageview_url='/products'
AND created_at BETWEEN '2012-10-06' AND '2013-04-06'
;

DROP TABLE IF EXISTS temp2;
CREATE TEMPORARY TABLE temp2
SELECT temp1.website_pageview_id,
      temp1.created_at,
      temp1.website_session_id,
      website_pageviews.pageview_url,
      temp1.pre_post FROM temp1
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id=temp1.website_session_id
AND website_pageviews.website_pageview_id > temp1.website_pageview_id
;

-- Group above table by website_session_id, counting website pageviews (save as mult_pgvw col)

DROP TABLE IF EXISTS temp3;
CREATE TEMPORARY TABLE temp3
SELECT 
    temp2.website_session_id,
    COUNT(DISTINCT pageview_url) AS pgview_cnt
    FROM temp2
GROUP BY 1;

DROP TABLE IF EXISTS temp4;
CREATE TEMPORARY TABLE temp4
SELECT temp2.*,
    temp3.pgview_cnt
    FROM temp2
    LEFT JOIN temp3
    ON temp2.website_session_id = temp3.website_session_id
;

-- Left join above to orders on website session id, w_next_page being cols having mult_pgvw > 1 


-- SELECT 
--     temp4.pre_post as 'time_period',
--     COUNT(DISTINCT temp4.website_session_id) as 'sessions',
--     COUNT (DISTINCT CASE WHEN temp4.pgview_cnt > 1 THEN temp1.website_session_id ELSE NULL END) AS 'w_next_pg'
-- FROM temp4
-- LEFT JOIN orders
-- ON orders.website_session_id = temp4.website_session_id
-- GROUP BY temp4.pre_post
-- ;

SELECT
    temp4.pre_post as "time_period",
    COUNT(DISTINCT temp1.website_session_id) as "sessions",
    COUNT(DISTINCT CASE WHEN temp4.pgview_cnt > 1 THEN temp1.website_session_id ELSE NULL END) AS "w_next_page",
    ROUND(COUNT(DISTINCT CASE WHEN temp4.pgview_cnt > 1 THEN temp1.website_session_id ELSE NULL END)*100.0/
    COUNT(DISTINCT temp1.website_session_id),2) as 'pct_w_next_pg',
    COUNT(DISTINCT CASE WHEN temp4.pageview_url='/the-original-mr-fuzzy' THEN temp1.website_session_id ELSE NULL END) AS 'to_mrfuzzy',
    ROUND(COUNT(DISTINCT CASE WHEN temp4.pageview_url='/the-original-mr-fuzzy' THEN temp1.website_session_id ELSE NULL END)*100.0/
    COUNT(DISTINCT temp1.website_session_id),2) AS 'pct_to_mrfuzzy',
    COUNT(DISTINCT CASE WHEN temp4.pageview_url='/the-forever-love-bear' THEN temp1.website_session_id ELSE NULL END) AS 'to_lovebear',
    ROUND(COUNT(DISTINCT CASE WHEN temp4.pageview_url='/the-forever-love-bear' THEN temp1.website_session_id ELSE NULL END)*100.0/
    COUNT(DISTINCT temp1.website_session_id),2) AS 'pct_to_lovebear'

FROM temp1
LEFT JOIN temp4
ON temp1.website_session_id = temp4.website_session_id
GROUP BY temp4.pre_post
ORDER BY sessions DESC
;