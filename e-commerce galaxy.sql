CREATE DATABASE ecommerce_galaxy;
USE ecommerce_galaxy;

-- Dimension 1: Product
CREATE TABLE dim_product (
    product_key INT PRIMARY KEY,
    product_id VARCHAR(10),
    product_name VARCHAR(50),
    category VARCHAR(30));

-- Dimension 2: Customer
CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,
    customer_id VARCHAR(10),
    customer_name VARCHAR(50),
    city VARCHAR(30));

-- Dimension 3: Date
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    month INT,
    quarter INT,
    year INT);

-- Dimension 4: Store / Channel
CREATE TABLE dim_store_channel (
    store_channel_key INT PRIMARY KEY,
    store_name VARCHAR(50),
    channel VARCHAR(30));

-- Fact 1: Sales
CREATE TABLE fact_sales (
    sales_key INT PRIMARY KEY,
    product_key INT,
    customer_key INT,
    date_key INT,
    store_channel_key INT,
    quantity INT,
    sales_amount DECIMAL(10,2),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (store_channel_key) REFERENCES dim_store_channel(store_channel_key));

-- Fact 2: Returns
CREATE TABLE fact_returns (
    return_key INT PRIMARY KEY,
    product_key INT,
    customer_key INT,
    date_key INT,
    store_channel_key INT,
    quantity_returned INT,
    refund_amount DECIMAL(10,2),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (store_channel_key) REFERENCES dim_store_channel(store_channel_key));
    
INSERT INTO dim_product VALUES
(1, 'P101', 'Laptop', 'Electronics'),
(2, 'P102', 'Mobile Phone', 'Electronics'),
(3, 'P103', 'Headphones', 'Accessories'),
(4, 'P104', 'Running Shoes', 'Footwear'),
(5, 'P105', 'Backpack', 'Bags');

INSERT INTO dim_customer VALUES
(1, 'C101', 'Arun Kumar', 'Chennai'),
(2, 'C102', 'Priya', 'Bangalore'),
(3, 'C103', 'Rahul', 'Hyderabad'),
(4, 'C104', 'Sneha', 'Mumbai'),
(5, 'C105', 'Karthik', 'Delhi');

INSERT INTO dim_date VALUES
(1, '2026-01-10', 1, 1, 2026),
(2, '2026-02-15', 2, 1, 2026),
(3, '2026-03-20', 3, 1, 2026),
(4, '2026-04-12', 4, 2, 2026),
(5, '2026-05-25', 5, 2, 2026);

INSERT INTO dim_store_channel VALUES
(1, 'Chennai Store', 'Online'),
(2, 'Bangalore Store', 'Online'),
(3, 'Hyderabad Store', 'Mobile App'),
(4, 'Mumbai Store', 'Online'),
(5, 'Delhi Store', 'Mobile App');

INSERT INTO fact_sales VALUES
(1, 1, 1, 1, 1, 2, 120000.00),
(2, 2, 2, 2, 2, 3, 90000.00),
(3, 3, 3, 3, 3, 5, 25000.00),
(4, 4, 4, 4, 4, 2, 10000.00),
(5, 5, 5, 5, 5, 4, 12000.00);

INSERT INTO fact_returns VALUES
(1, 1, 1, 1, 1, 1, 60000.00),
(2, 2, 2, 2, 2, 1, 30000.00),
(3, 3, 3, 3, 3, 2, 10000.00),
(4, 4, 4, 4, 4, 1, 5000.00),
(5, 5, 5, 5, 5, 1, 3000.00);

SELECT
    p.product_name,
    SUM(s.quantity) AS total_sold,
    SUM(s.sales_amount) AS total_sales,
    SUM(r.quantity_returned) AS total_returned,
    SUM(r.refund_amount)  AS total_refund
FROM dim_product p
LEFT JOIN fact_sales s
    ON p.product_key = s.product_key
LEFT JOIN fact_returns r
    ON p.product_key = r.product_key
GROUP BY p.product_name;