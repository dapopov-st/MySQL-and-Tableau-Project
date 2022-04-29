-- 73 Product-level sales analysis
-- Monthly trends for number_of_sales, total_revenue, and total_margin_generated

SELECT 
    YEAR(created_at),
    MONTH(created_at),
    COUNT(DISTINCT order_id) as number_of_sales,
    SUM(price_usd) as total_revenue,
    SUM(price_usd - cogs_usd) as total_margin
FROM
    orders
WHERE created_at < '2013-01-04'
GROUP BY 1,2;