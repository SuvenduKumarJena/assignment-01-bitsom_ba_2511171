-- Q1: List all customers along with the total number of orders they have placed
-- We use a LEFT JOIN to ensure we include customers even if they haven't placed an order.
SELECT 
    c.name, 
    COUNT(o.order_id) AS total_orders
FROM read_csv_auto('customers.csv') AS c
LEFT JOIN read_json_auto('orders.json') AS o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Q2: Find the top 3 customers by total order value
SELECT 
    c.name, 
    SUM(o.total_amount) AS total_order_value
FROM read_csv_auto('customers.csv') AS c
JOIN read_json_auto('orders.json') AS o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_order_value DESC
LIMIT 3;

-- Q3: List all products purchased by customers from Bangalore
SELECT DISTINCT 
    p.product_name
FROM read_csv_auto('customers.csv') AS c
JOIN read_json_auto('orders.json') AS o 
    ON c.customer_id = o.customer_id
JOIN read_parquet('products.parquet') AS p 
    ON o.order_id = p.order_id
WHERE c.city = 'Bangalore';

-- Q4: Join all three files to show: customer name, order date, product name, and quantity
SELECT 
    c.name AS customer_name,
    o.order_date,
    p.product_name,
    p.quantity
FROM read_csv_auto('customers.csv') AS c
JOIN read_json_auto('orders.json') AS o 
    ON c.customer_id = o.customer_id
JOIN read_parquet('products.parquet') AS p 
    ON o.order_id = p.order_id;