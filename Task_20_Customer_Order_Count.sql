-- Task 20: Customer Order Count
-- Dataset: synthetic Superstore-style sample used in the Excel workbook.
-- Import the Raw Data sheet into a table named order_lines.

-- 1. Example table structure (adapt data types to your SQL database)
CREATE TABLE order_lines (
    order_id VARCHAR(20),
    order_date DATE,
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    product VARCHAR(100),
    quantity INT,
    sales DECIMAL(10,2)
);

-- 2. Count distinct orders for each customer.
-- DISTINCT is important because one order may contain multiple product lines.
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS order_count
FROM order_lines
GROUP BY customer_id, customer_name
ORDER BY order_count DESC, customer_name;

-- 3. Identify the top 5 customers by number of orders.
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS order_count
FROM order_lines
GROUP BY customer_id, customer_name
ORDER BY order_count DESC, customer_name
LIMIT 5;

-- 4. Classify customers by order frequency.
WITH customer_orders AS (
    SELECT
        customer_id,
        customer_name,
        COUNT(DISTINCT order_id) AS order_count
    FROM order_lines
    GROUP BY customer_id, customer_name
)
SELECT
    customer_id,
    customer_name,
    order_count,
    CASE
        WHEN order_count >= 3 THEN 'Frequent (3+)'
        WHEN order_count = 2 THEN 'Repeat (2)'
        ELSE 'One-time (1)'
    END AS buyer_segment
FROM customer_orders
ORDER BY order_count DESC, customer_name;

-- 5. Check how many raw rows exist per order (data-quality check).
SELECT order_id, COUNT(*) AS order_line_count
FROM order_lines
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY order_line_count DESC;
