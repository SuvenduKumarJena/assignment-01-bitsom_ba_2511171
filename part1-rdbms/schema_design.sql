-- =========================================================
-- SCHEMA DESIGN (3NF)
-- =========================================================

-- 1. Create Customers Table
CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    customer_city VARCHAR(50) NOT NULL
);

-- 2. Create Sales Representatives Table
CREATE TABLE sales_reps (
    sales_rep_id VARCHAR(10) PRIMARY KEY,
    sales_rep_name VARCHAR(100) NOT NULL,
    sales_rep_email VARCHAR(100) NOT NULL,
    office_address VARCHAR(255) NOT NULL
);

-- 3. Create Products Table
CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

-- 4. Create Orders Table
CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    sales_rep_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (sales_rep_id) REFERENCES sales_reps(sales_rep_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- =========================================================
-- INSERT STATEMENTS (At least 5 rows per table)
-- =========================================================

-- Populate Customers (Data extracted from flat file)
INSERT INTO customers (customer_id, customer_name, customer_email, customer_city) 
VALUES 
('C001', 'Rohan Mehta', 'rohan@gmail.com', 'Mumbai'),
('C002', 'Priya Sharma', 'priya@gmail.com', 'Delhi'),
('C003', 'Amit Verma', 'amit@gmail.com', 'Bangalore'),
('C005', 'Vikram Singh', 'vikram@gmail.com', 'Mumbai'),
('C006', 'Neha Gupta', 'neha@gmail.com', 'Delhi');

-- Populate Sales Reps 
-- Note: The original dataset only contained 3 unique sales reps. 
-- 2 mock records (SR04, SR05) have been added to fulfill the 5-row minimum requirement.
INSERT INTO sales_reps (sales_rep_id, sales_rep_name, sales_rep_email, office_address) 
VALUES 
('SR01', 'Deepak Joshi', 'deepak@corp.com', 'Mumbai HQ, Nariman Point, Mumbai - 400021'),
('SR02', 'Anita Desai', 'anita@corp.com', 'Delhi Office, Connaught Place, New Delhi - 110001'),
('SR03', 'Ravi Kumar', 'ravi@corp.com', 'South Zone, MG Road, Bangalore - 560001'),
('SR04', 'Pooja Nair', 'pooja@corp.com', 'Kochi Hub, MG Road, Kochi - 682011'),
('SR05', 'Arjun Das', 'arjun@corp.com', 'Kolkata Office, Park Street, Kolkata - 700016');

-- Populate Products (Data extracted from flat file)
INSERT INTO products (product_id, product_name, category, unit_price) 
VALUES 
('P003', 'Desk Chair', 'Furniture', 8500.00),
('P004', 'Notebook', 'Stationery', 120.00),
('P005', 'Headphones', 'Electronics', 3200.00),
('P006', 'Standing Desk', 'Furniture', 22000.00),
('P007', 'Pen Set', 'Stationery', 250.00);

-- Populate Orders (Data extracted from flat file)
INSERT INTO orders (order_id, customer_id, sales_rep_id, product_id, quantity, order_date) 
VALUES 
('ORD1027', 'C002', 'SR02', 'P004', 4, '2023-11-02'),
('ORD1114', 'C001', 'SR01', 'P007', 2, '2023-08-06'),
('ORD1153', 'C006', 'SR01', 'P007', 3, '2023-02-14'),
('ORD1002', 'C002', 'SR02', 'P005', 1, '2023-01-17'),
('ORD1118', 'C006', 'SR02', 'P007', 5, '2023-11-10');