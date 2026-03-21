
-- ------------------------------------------------------------------------------
-- 1. Create Dimension Tables
-- ------------------------------------------------------------------------------

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,           
    full_date DATE NOT NULL,           
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    quarter INT NOT NULL
);

-- Dimension: Store
CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    store_city VARCHAR(50) NOT NULL
);

-- Dimension: Product
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 2. Create Fact Table
-- ------------------------------------------------------------------------------

-- Fact: Sales
CREATE TABLE fact_sales (
    transaction_id VARCHAR(20) PRIMARY KEY,
    date_id INT NOT NULL,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    customer_id VARCHAR(20),            
    units_sold INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(15, 2) NOT NULL, 
    
    -- Foreign Key Constraints
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);

-- ------------------------------------------------------------------------------
-- 3. Load Cleaned Sample Data
-- ------------------------------------------------------------------------------

-- INSERT into dim_date (Dates standardized to YYYY-MM-DD format)
INSERT INTO dim_date (date_id, full_date, year, month, day, quarter) VALUES 
(20230829, '2023-08-29', 2023, 8, 29, 3),
(20231212, '2023-12-12', 2023, 12, 12, 4),
(20230205, '2023-02-05', 2023, 2, 5, 1),
(20230220, '2023-02-20', 2023, 2, 20, 1),
(20230115, '2023-01-15', 2023, 1, 15, 1),
(20230809, '2023-08-09', 2023, 8, 9, 3),
(20230331, '2023-03-31', 2023, 3, 31, 1),
(20231026, '2023-10-26', 2023, 10, 26, 4),
(20231208, '2023-12-08', 2023, 12, 8, 4),
(20230815, '2023-08-15', 2023, 8, 15, 3);

-- INSERT into dim_store
INSERT INTO dim_store (store_id, store_name, store_city) VALUES 
(1, 'Chennai Anna', 'Chennai'),
(2, 'Delhi South', 'Delhi'),
(3, 'Bangalore MG', 'Bangalore'),
(4, 'Pune FC Road', 'Pune'),
(5, 'Mumbai Central', 'Mumbai');

-- INSERT into dim_product (Categories standardardized to 'Electronics', 'Grocery', 'Clothing')
INSERT INTO dim_product (product_id, product_name, category) VALUES 
(1, 'Speaker', 'Electronics'),
(2, 'Tablet', 'Electronics'),
(3, 'Phone', 'Electronics'),
(4, 'Smartwatch', 'Electronics'),
(5, 'Atta 10kg', 'Grocery'),
(6, 'Jeans', 'Clothing'),
(7, 'Biscuits', 'Grocery'),
(8, 'Jacket', 'Clothing'),
(9, 'Laptop', 'Electronics'),
(10, 'Milk 1L', 'Grocery');

-- INSERT into fact_sales (Cleaned rows with calculated total_amount measure)
INSERT INTO fact_sales (transaction_id, date_id, store_id, product_id, customer_id, units_sold, unit_price, total_amount) VALUES 
('TXN5000', 20230829, 1, 1, 'CUST045', 3, 49262.78, 147788.34),
('TXN5001', 20231212, 1, 2, 'CUST021', 11, 23226.12, 255487.32),
('TXN5002', 20230205, 1, 3, 'CUST019', 20, 48703.39, 974067.80),
('TXN5003', 20230220, 2, 2, 'CUST007', 14, 23226.12, 325165.68),
('TXN5004', 20230115, 1, 4, 'CUST004', 10, 58851.01, 588510.10),
('TXN5005', 20230809, 3, 5, 'CUST027', 12, 52464.00, 629568.00),
('TXN5006', 20230331, 4, 4, 'CUST025', 6, 58851.01, 353106.06),
('TXN5007', 20231026, 4, 6, 'CUST041', 16, 2317.47, 37079.52),
('TXN5008', 20231208, 3, 7, 'CUST030', 9, 27469.99, 247229.91),
('TXN5009', 20230815, 3, 4, 'CUST020', 3, 58851.01, 176553.03);