create database retailstore_dw;
use retailstore_dw;

create table dim_product (
product_id int primary key,
product_name varchar(100),
category varchar(50),
price varchar(50));

create table dim_customer (
customer_id int primary key,
customer_name varchar(100),
email varchar(100),
mobile_number varchar(15));

create table dim_date (
date_key int primary key,
full_date date,
day int,
month int,
year int,
quarter int);

create table dim_store (
store_id int primary key,
store_name varchar(100),
city varchar(50));

insert into dim_product(product_id, product_name, category, price) values
(1,'Laptop', 'Electronics', 55000.00),
(2, 'Mobile Phone', 'Electronics', 25000.00),
(3, 'Headphones', 'Electronics', 2000.00),
(4, 'Keyboard', 'Accessories', 1500.00),
(5, 'Mouse', 'Accessories', 800.00),
(6, 'Monitor', 'Electronics', 12000.00),
(7, 'Printer', 'Electronics', 9000.00),
(8, 'Office Chair', 'Furniture', 7000.00),
(9, 'Desk', 'Furniture', 10000.00),
(10,'Tablet', 'Electronics', 18000.00);

insert into dim_customer(customer_id, customer_name, email,mobile_number) values
(1, 'Arun Kumar', 'arun@gmail.com',8976543278),
(2, 'Priya Sharma', 'priya@gmail.com',9098765436),
(3, 'Rahul Singh', 'rahul@gmail.com',8345126789),
(4, 'Sneha Reddy', 'sneha@gmail.com',7865432123),
(5, 'Karthik Raj', 'karthik@gmail.com',8908786543),
(6, 'Anjali Patel', 'anjali@gmail.com',9898912345),
(7, 'Vijay Kumar', 'vijay@gmail.com',9998065432),
(8, 'Divya Menon', 'divya@gmail.com',8990676512),
(9, 'Suresh Babu', 'suresh@gmail.com',7896754329),
(10, 'Meena Devi', 'meena@gmail.com',9098768976);

insert into dim_store(store_id, store_name, city) values
(1,'Chennai Central', 'Chennai'),
(2,'Bangalore Mall', 'Bangalore'),
(3,'Hyderabad Plaza', 'Hyderabad'),
(4,'Mumbai Central', 'Mumbai'),
(5,'Delhi Store', 'Delhi'),
(6,'Pune Mall', 'Pune'),
(7,'Kolkata Store', 'Kolkata'),
(8,'Coimbatore Mall', 'Coimbatore'),
(9,'Chennai Express', 'Chennai'),
(10,'Hyderabad Central', 'Hyderabad');

insert into dim_date(date_key, full_date, day, month, year,quarter) values
(1, '2026-01-05', 5, 1, 2026, 1),
(2, '2026-01-15', 15, 1, 2026, 1),
(3, '2026-02-10', 10, 2, 2026, 1),
(4, '2026-02-20', 20, 2, 2026,1),
(5, '2026-03-05', 5, 3, 2026,1),
(6, '2026-04-10', 10, 4, 2026,2),
(7, '2026-05-15', 15, 5, 2026,2),
(8, '2026-06-20', 20, 6, 2026,2),
(9, '2026-07-10', 10, 7, 2026,3),
(10,'2026-08-25', 25, 8, 2026,3);

-- Fact Table
CREATE TABLE fact_sales (
    sales_key INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    store_id INT,
    date_key INT,
    quantity INT,
    sales_amount DECIMAL(10,2),
    discount_percent DECIMAL(5,2),
    discount_amount DECIMAL(10,2),
    net_sales_amount DECIMAL(10,2),

    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key));
    
INSERT INTO fact_sales VALUES

(1, 1, 1, 1, 1, 2, 100000.00, 10.00, 10000.00, 90000.00),

(2, 2, 2, 2, 2, 3, 60000.00, 5.00, 3000.00, 57000.00),

(3, 3, 3, 3, 3, 5, 10000.00, 10.00, 1000.00, 9000.00),

(4, 4, 4, 4, 4, 4, 12000.00, 15.00, 1800.00, 10200.00),

(5, 5, 5, 5, 5, 6, 6000.00, 10.00, 600.00, 5400.00),

(6, 6, 6, 6, 6, 2, 30000.00, 20.00, 6000.00, 24000.00),

(7, 7, 7, 7, 7, 1, 15000.00, 5.00, 750.00, 14250.00),

(8, 8, 8, 8, 8, 3, 45000.00, 10.00, 4500.00, 40500.00),

(9, 9, 9, 9, 9, 4, 8000.00, 15.00, 1200.00, 6800.00),

(10, 10, 10, 10, 10, 5, 10000.00, 10.00, 1000.00, 9000.00);

###product sold based on category
SELECT
    p.product_name,
    f.quantity,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.discount_amount) AS total_discount
FROM fact_sales f
JOIN dim_product p
    ON f.product_id = p.product_id
where category = "electronics"
GROUP BY p.product_name,f.quantity;

###total sales based on city
SELECT
    s.city,
    d.full_date,
    SUM(f.net_sales_amount) AS total_net_sales
FROM fact_sales f
JOIN dim_store s
    ON f.store_id = s.store_id
join dim_date d
	on f.date_key = d.date_key
GROUP BY s.city, d.full_date;
