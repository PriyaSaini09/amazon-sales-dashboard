CREATE DATABASE amazon_project; 
USE amazon_project;
CREATE TABLE amazon_sales (
    idx INT,
    order_id VARCHAR(50),
    order_date DATE,
    status VARCHAR(50),
    fulfilment VARCHAR(50),
    sales_channel VARCHAR(50),
    ship_service_level VARCHAR(50),
    style VARCHAR(100),
    sku VARCHAR(100),
    category VARCHAR(100),
    size VARCHAR(20),
    asin VARCHAR(50),
    courier_status VARCHAR(50),
    qty INT,
    currency VARCHAR(10),
    amount DECIMAL(10,2),
    ship_city VARCHAR(100),
    ship_state VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(50),
    promotion_ids TEXT,
    b2b VARCHAR(10),
    fulfilled_by VARCHAR(50),
    unnamed_22 TEXT
);
ALTER TABLE amazon_sales 
MODIFY order_date VARCHAR(20);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/amzon_sales.csv'
INTO TABLE amazon_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
idx,
order_id,
order_date,
status,
fulfilment,
sales_channel,
ship_service_level,
style,
sku,
category,
size,
asin,
courier_status,
@qty,
currency,
@amount,
ship_city,
ship_state,
ship_postal_code,
ship_country,
promotion_ids,
b2b,
fulfilled_by,
unnamed_22
)
SET 
qty = NULLIF(@qty, ''),
amount = NULLIF(@amount, '');
UPDATE amazon_sales
SET order_date = 
    CASE
        WHEN order_date LIKE '% - %' THEN STR_TO_DATE(SUBSTRING_INDEX(order_date, ' - ', 1), '%m/%d/%Y')
        WHEN order_date LIKE '%-%-%__' THEN STR_TO_DATE(order_date, '%m-%d-%y')
        WHEN order_date LIKE '%-%-%____' THEN STR_TO_DATE(order_date, '%m-%d-%Y')
        ELSE NULL
    END;
    ALTER TABLE amazon_sales 
MODIFY order_date DATE;
SELECT COUNT(*) FROM amazon_sales;
SELECT * FROM amazon_sales;
SELECT order_date FROM amazon_sales;
SELECT COUNT(*) AS 'total_orders',
SUM(amount) As 'total_sales'
FROM amazon_sales;
SELECT status , COUNT(*) AS 'total_orders',
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM amazon_sales), 2) AS percentage
FROM amazon_sales 
GROUP BY status
ORDER BY total_orders DESC;
SELECT category , COUNT(*) AS 'total_orders', 
SUM(amount) as 'revenue' 
FROM amazon_sales
GROUP BY  category
ORDER BY revenue  DESC;
SELECT sku , SUM(amount) as 'revenue' 
FROM amazon_sales 
GROUP BY sku
ORDER BY revenue DESC 
LIMIT 10;