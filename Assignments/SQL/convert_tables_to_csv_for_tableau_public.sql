-- TABLE order_item_refunds
-- INTO OUTFILE '/Users/dmitriyapopov/Desktop/MySqlTableau/Advanced_SQL/3_assignments/order_item_refunds.csv'
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- ESCAPED BY ''
-- LINES TERMINATED BY 'n';

--  use mavenfuzzyfactory;

-- SELECT * FROM order_item_refunds INTO OUTFILE "~/Desktop/order_item_refunds.csv";


-- TABLE order_item_refunds
-- INTO OUTFILE '~/Desktop/order_item_refunds2.csv'
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- ESCAPED BY ''
-- LINES TERMINATED BY '\n';

-- TABLE order_items
-- INTO OUTFILE '~/Desktop/MySqlTableau/order_items.csv'
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- ESCAPED BY ''
-- LINES TERMINATED BY '\n';

-- TABLE orders
-- INTO OUTFILE '~/Desktop/MySqlTableau/orders.csv'
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- ESCAPED BY ''
-- LINES TERMINATED BY '\n';


-- TABLE products
-- INTO OUTFILE '~/Desktop/MySqlTableau/products.csv'
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- ESCAPED BY ''
-- LINES TERMINATED BY '\n';

-- TABLE website_pageviews
-- INTO OUTFILE '~/Desktop/MySqlTableau/website_pageviews.csv'
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- ESCAPED BY ''
-- LINES TERMINATED BY '\n';

TABLE website_sessions
INTO OUTFILE '~/Desktop/MySqlTableau/website_sessions.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\n';