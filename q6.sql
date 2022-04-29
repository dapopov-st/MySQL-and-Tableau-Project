-- From % clickthrough from /products to /the-original-mr-fuzzy  /the-forever-love-bear /the-birthday-sugar-panda /the-hudson-river-mini-bear 
-- From there to /billing, /billing-2, /shipping, /thank-you-for-your-order

DROP TABLE IF EXISTS product_pageviews;
CREATE TABLE product_pageviews
SELECT
        *
        FROM website_pageviews
        WHERE website_pageviews.created_at < '2015-03-20' 
        AND website_pageviews.pageview_url='/products'
;

-- Just want conversions from product to order

SELECT
    YEAR(product_pageviews.created_at) AS 'year',
    MONTH(product_pageviews.created_at) AS 'month',
    COUNT(DISTINCT website_pageviews.website_session_id) AS "clicked_from_product",
    COUNT(DISTINCT product_pageviews.website_session_id) AS "clicked_to_product",
    COUNT(DISTINCT website_pageviews.website_session_id)/
    COUNT(DISTINCT product_pageviews.website_session_id) AS "prod_clickthrough",
    COUNT(DISTINCT orders.order_id)/
    COUNT(DISTINCT product_pageviews.website_session_id) AS "prod_to_order_cvr"

FROM product_pageviews  
LEFT JOIN website_pageviews
    ON product_pageviews.website_session_id = website_pageviews.website_session_id
    AND website_pageviews.website_pageview_id>product_pageviews.website_pageview_id
LEFT JOIN orders
    ON orders.website_session_id = product_pageviews.website_session_id
-- WHERE website_pageviews.created_at < '2015-03-20' 
GROUP BY 1,2
;



-- +------+-------+----------------------+--------------------+-------------------+-------------------+
-- | year | month | clicked_from_product | clicked_to_product | prod_clickthrough | prod_to_order_cvr |
-- +------+-------+----------------------+--------------------+-------------------+-------------------+
-- | 2012 |     3 |                  530 |                743 |            0.7133 |            0.0808 |
-- | 2012 |     4 |                 1031 |               1450 |            0.7110 |            0.0683 |
-- | 2012 |     5 |                 1139 |               1588 |            0.7173 |            0.0680 |
-- | 2012 |     6 |                 1241 |               1745 |            0.7112 |            0.0802 |
-- | 2012 |     7 |                 1441 |               2022 |            0.7127 |            0.0836 |
-- | 2012 |     8 |                 2198 |               3012 |            0.7297 |            0.0757 |
-- | 2012 |     9 |                 2257 |               3125 |            0.7222 |            0.0918 |
-- | 2012 |    10 |                 2950 |               4032 |            0.7316 |            0.0923 |
-- | 2012 |    11 |                 4849 |               6745 |            0.7189 |            0.0916 |
-- | 2012 |    12 |                 3620 |               5011 |            0.7224 |            0.1010 |
-- | 2013 |     1 |                 2593 |               3377 |            0.7678 |            0.1155 |
-- | 2013 |     2 |                 2806 |               3688 |            0.7608 |            0.1348 |
-- | 2013 |     3 |                 2578 |               3375 |            0.7639 |            0.1144 |
-- | 2013 |     4 |                 3355 |               4359 |            0.7697 |            0.1271 |
-- | 2013 |     5 |                 3610 |               4686 |            0.7704 |            0.1216 |
-- | 2013 |     6 |                 3541 |               4605 |            0.7689 |            0.1290 |
-- | 2013 |     7 |                 3884 |               5013 |            0.7748 |            0.1207 |
-- | 2013 |     8 |                 3949 |               5224 |            0.7559 |            0.1160 |
-- | 2013 |     9 |                 4075 |               5403 |            0.7542 |            0.1162 |
-- | 2013 |    10 |                 4568 |               6043 |            0.7559 |            0.1175 |
-- | 2013 |    11 |                 5893 |               7881 |            0.7477 |            0.1090 |
-- | 2013 |    12 |                 7035 |               8847 |            0.7952 |            0.1186 |
-- | 2014 |     1 |                 6389 |               7793 |            0.8198 |            0.1259 |
-- | 2014 |     2 |                 6481 |               7961 |            0.8141 |            0.1288 |
-- | 2014 |     3 |                 6668 |               8103 |            0.8229 |            0.1312 |
-- | 2014 |     4 |                 7959 |               9744 |            0.8168 |            0.1274 |
-- | 2014 |     5 |                 8465 |              10260 |            0.8250 |            0.1333 |
-- | 2014 |     6 |                 8264 |              10018 |            0.8249 |            0.1238 |
-- | 2014 |     7 |                 8962 |              10841 |            0.8267 |            0.1185 |
-- | 2014 |     8 |                 8977 |              10766 |            0.8338 |            0.1231 |
-- | 2014 |     9 |                 9157 |              11129 |            0.8228 |            0.1280 |
-- | 2014 |    10 |                10234 |              12331 |            0.8299 |            0.1305 |
-- | 2014 |    11 |                12140 |              14626 |            0.8300 |            0.1371 |
-- | 2014 |    12 |                14497 |              17102 |            0.8477 |            0.1343 |
-- | 2015 |     1 |                12989 |              15210 |            0.8540 |            0.1378 |
-- | 2015 |     2 |                12196 |              14385 |            0.8478 |            0.1438 |
-- | 2015 |     3 |                 7693 |               8988 |            0.8559 |            0.1392 |
-- +------+-------+----------------------+--------------------+-------------------+-------------------+






-- SELECT
--     YEAR(website_pageviews.created_at) AS 'year',
--     MONTH(website_pageviews.created_at) AS 'month',
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url='/the-original-mr-fuzzy' THEN website_pageviews.website_pageview_id ELSE NULL END)/
--     COUNT(DISTINCT website_pageviews.website_pageview_id) AS "to_fuzzy_ctr",
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url='/the-forever-love-bear' THEN website_pageviews.website_pageview_id ELSE NULL END)/
--     COUNT(DISTINCT website_pageviews.website_pageview_id) AS "to_lovebear_ctr",
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url='/the-birthday-sugar-panda' THEN website_pageviews.website_pageview_id ELSE NULL END)/
--     COUNT(DISTINCT website_pageviews.website_pageview_id) AS "to_panda_ctr",
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url='/cart' THEN website_pageviews.website_pageview_id ELSE NULL END)/
--     COUNT(DISTINCT product_pageviews.website_pageview_id) AS "to_cart_ctr",
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url='/shipping' THEN website_pageviews.website_pageview_id ELSE NULL END)/
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url='/cart' THEN website_pageviews.website_pageview_id ELSE NULL END) AS "to_ship_ctr",
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url IN ('/billing','/billing-2') THEN website_pageviews.website_pageview_id ELSE NULL END)/
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url='/shipping' THEN website_pageviews.website_pageview_id ELSE NULL END) AS "to_bill_ctr",
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url='/thank-you-for-your-order' THEN website_pageviews.website_pageview_id ELSE NULL END)/
--     COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url IN ('/billing','/billing-2') THEN website_pageviews.website_pageview_id ELSE NULL END) AS "to_thank_ctr"
-- FROM product_pageviews  
-- LEFT JOIN website_pageviews
--     ON product_pageviews.website_session_id = website_pageviews.website_session_id
--     AND website_pageviews.created_at>product_pageviews.created_at
-- WHERE website_pageviews.created_at < '2015-03-20' 
-- GROUP BY 1,2
-- ;

-- +------+-------+--------------+-----------------+--------------+-------------+-------------+-------------+--------------+
-- | year | month | to_fuzzy_ctr | to_lovebear_ctr | to_panda_ctr | to_cart_ctr | to_ship_ctr | to_bill_ctr | to_thank_ctr |
-- +------+-------+--------------+-----------------+--------------+-------------+-------------+-------------+--------------+
-- | 2012 |     3 |       0.4818 |          0.0000 |       0.0000 |      0.4321 |      0.6856 |      0.7898 |       0.4839 |
-- | 2012 |     4 |       0.4945 |          0.0000 |       0.0000 |      0.4239 |      0.6545 |      0.8112 |       0.4267 |
-- | 2012 |     5 |       0.4954 |          0.0000 |       0.0000 |      0.4205 |      0.6534 |      0.8307 |       0.4154 |
-- | 2012 |     6 |       0.4708 |          0.0000 |       0.0000 |      0.4480 |      0.6817 |      0.8443 |       0.4375 |
-- | 2012 |     7 |       0.4745 |          0.0000 |       0.0000 |      0.4434 |      0.6604 |      0.8673 |       0.4617 |
-- | 2012 |     8 |       0.4825 |          0.0000 |       0.0000 |      0.4363 |      0.6788 |      0.7972 |       0.4393 |
-- | 2012 |     9 |       0.4757 |          0.0000 |       0.0000 |      0.4369 |      0.6846 |      0.8000 |       0.5315 |
-- | 2012 |    10 |       0.4822 |          0.0000 |       0.0000 |      0.4261 |      0.6786 |      0.8042 |       0.5423 |
-- | 2012 |    11 |       0.4759 |          0.0000 |       0.0000 |      0.4312 |      0.6939 |      0.8132 |       0.5237 |
-- | 2012 |    12 |       0.4648 |          0.0000 |       0.0000 |      0.4428 |      0.6987 |      0.8393 |       0.5383 |
-- | 2013 |     1 |       0.4161 |          0.0520 |       0.0000 |      0.4427 |      0.6812 |      0.8018 |       0.6220 |
-- | 2013 |     2 |       0.3113 |          0.1277 |       0.0000 |      0.4815 |      0.7069 |      0.8199 |       0.6347 |
-- | 2013 |     3 |       0.4071 |          0.0642 |       0.0000 |      0.4344 |      0.6786 |      0.8250 |       0.6156 |
-- | 2013 |     4 |       0.3926 |          0.0613 |       0.0000 |      0.4551 |      0.7007 |      0.8280 |       0.6253 |
-- | 2013 |     5 |       0.4046 |          0.0606 |       0.0000 |      0.4446 |      0.6760 |      0.8203 |       0.6404 |
-- | 2013 |     6 |       0.3955 |          0.0595 |       0.0000 |      0.4567 |      0.6877 |      0.8264 |       0.6464 |
-- | 2013 |     7 |       0.4044 |          0.0603 |       0.0000 |      0.4544 |      0.6567 |      0.8154 |       0.6402 |
-- | 2013 |     8 |       0.4046 |          0.0610 |       0.0000 |      0.4502 |      0.6682 |      0.8098 |       0.6289 |
-- | 2013 |     9 |       0.4129 |          0.0584 |       0.0000 |      0.4382 |      0.6719 |      0.7975 |       0.6573 |
-- | 2013 |    10 |       0.4012 |          0.0602 |       0.0000 |      0.4486 |      0.6969 |      0.8018 |       0.6201 |
-- | 2013 |    11 |       0.4070 |          0.0604 |       0.0000 |      0.4480 |      0.6754 |      0.8037 |       0.5994 |
-- | 2013 |    12 |       0.3735 |          0.0567 |       0.0371 |      0.4462 |      0.6776 |      0.8016 |       0.6152 |
-- | 2014 |     1 |       0.3474 |          0.0563 |       0.0599 |      0.4519 |      0.6803 |      0.7943 |       0.6288 |
-- | 2014 |     2 |       0.2785 |          0.1202 |       0.0592 |      0.4641 |      0.6742 |      0.7959 |       0.6351 |
-- | 2014 |     3 |       0.3484 |          0.0567 |       0.0597 |      0.4487 |      0.6695 |      0.8098 |       0.6554 |
-- | 2014 |     4 |       0.3470 |          0.0554 |       0.0575 |      0.4590 |      0.6776 |      0.7985 |       0.6277 |
-- | 2014 |     5 |       0.3429 |          0.0552 |       0.0588 |      0.4592 |      0.6851 |      0.8047 |       0.6384 |
-- | 2014 |     6 |       0.3477 |          0.0597 |       0.0636 |      0.4422 |      0.6656 |      0.8059 |       0.6321 |
-- | 2014 |     7 |       0.3534 |          0.0590 |       0.0633 |      0.4355 |      0.6690 |      0.7974 |       0.6177 |
-- | 2014 |     8 |       0.3472 |          0.0610 |       0.0615 |      0.4439 |      0.6750 |      0.7926 |       0.6215 |
-- | 2014 |     9 |       0.3508 |          0.0544 |       0.0618 |      0.4433 |      0.6785 |      0.8036 |       0.6435 |
-- | 2014 |    10 |       0.3428 |          0.0556 |       0.0635 |      0.4484 |      0.6864 |      0.8178 |       0.6246 |
-- | 2014 |    11 |       0.3434 |          0.0545 |       0.0606 |      0.4527 |      0.6872 |      0.8106 |       0.6550 |
-- | 2014 |    12 |       0.3228 |          0.0529 |       0.0601 |      0.4611 |      0.6754 |      0.8067 |       0.6305 |
-- | 2015 |     1 |       0.3176 |          0.0547 |       0.0604 |      0.4538 |      0.6865 |      0.8040 |       0.6443 |
-- | 2015 |     2 |       0.2520 |          0.1100 |       0.0578 |      0.4849 |      0.6745 |      0.8105 |       0.6397 |
-- | 2015 |     3 |       0.3180 |          0.0523 |       0.0581 |      0.4660 |      0.6778 |      0.7996 |       0.6438 |
-- +------+-------+--------------+-----------------+--------------+-------------+-------------+-------------+--------------+