CREATE DATABASE supermarket_dw;
USE supermarket_dw;

CREATE TABLE dim_category (
    category_key INT PRIMARY KEY,
    category_name VARCHAR(50));
    
CREATE TABLE dim_subcategory (
    subcategory_key INT PRIMARY KEY,
    subcategory_name VARCHAR(50),
    category_key INT,
    FOREIGN KEY (category_key) REFERENCES dim_category(category_key));

CREATE TABLE dim_product (
    product_key INT PRIMARY KEY,
    product_name VARCHAR(50),
    subcategory_key INT,
    FOREIGN KEY (subcategory_key) REFERENCES dim_subcategory(subcategory_key));
    
CREATE TABLE dim_state (
    state_key INT PRIMARY KEY,
    state_name VARCHAR(50));
    
CREATE TABLE dim_city (
    city_key INT PRIMARY KEY,
    city_name VARCHAR(50),
    state_key INT,
    FOREIGN KEY (state_key) REFERENCES dim_state(state_key));
    
CREATE TABLE dim_store (
    store_key INT PRIMARY KEY,
    store_name VARCHAR(50),
    city_key INT,
    FOREIGN KEY (city_key) REFERENCES dim_city(city_key));
    
CREATE TABLE fact_product_sales (
    sales_key INT PRIMARY KEY,
    product_key INT,
    city_key int,
    store_key INT,
    sales_date DATE,
    quantity INT,
    sales_amount DECIMAL(10,2),
	FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
	FOREIGN KEY (store_key) REFERENCES dim_store(store_key));

INSERT INTO dim_category VALUES
(1, 'Beverages'),
(2, 'Food'),
(3, 'Personal Care'),
(4, 'Cleaning'),
(5, 'Bakery');

INSERT INTO dim_subcategory VALUES
(101, 'Soft Drinks', 1),
(102, 'Snacks', 2),
(103, 'Shampoo', 3),
(104, 'Detergent', 4),
(105, 'Bread', 5);

INSERT INTO dim_product VALUES
(1001, 'Coca Cola', 101),
(1002, 'Potato Chips', 102),
(1003, 'Dove Shampoo', 103),
(1004, 'Surf Excel', 104),
(1005, 'Brown Bread', 105);

INSERT INTO dim_state VALUES
(1, 'Tamil Nadu'),
(2, 'Karnataka'),
(3, 'Kerala'),
(4, 'Telangana'),
(5, 'Andhra Pradesh');

INSERT INTO dim_city VALUES
(101, 'Chennai', 1),
(102, 'Bangalore', 2),
(103, 'Kochi', 3),
(104, 'Hyderabad', 4),
(105, 'Vijayawada', 5);

INSERT INTO dim_store VALUES
(201, 'Chennai Central Store', 101),
(202, 'Bangalore Main Store', 102),
(203, 'Kochi Supermarket', 103),
(204, 'Hyderabad Central Store', 104),
(205, 'Vijayawada Main Store', 105);

INSERT INTO fact_product_sales VALUES
(1, 1001,101, 201, '2026-01-10', 10, 500.00),
(2, 1002,102, 202, '2026-01-11', 20, 1000.00),
(3, 1003,103, 203, '2026-01-12', 5, 750.00),
(4, 1004,104, 204, '2026-01-13', 8, 1200.00),
(5, 1005,105, 205, '2026-01-14', 15, 600.00);

###total sales of the products
SELECT
	p.product_name,
    c.category_name,
    s.store_name,
    SUM(f.sales_amount) AS total_sales
FROM fact_product_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
JOIN dim_subcategory sc
    ON p.subcategory_key = sc.subcategory_key
JOIN dim_category c
    ON c.category_key = c.category_key
join dim_store s
	on f.store_key = s.store_key
GROUP BY c.category_name,p.product_name,s.store_name;

###quantityand sales-amount of the product
select
p.product_name, c.city_name,f.quantity,f.sales_amount
from fact_product_sales f
join dim_product p 
on f.product_key = p.product_key
join dim_city c
on f.city_key = c.city_key;