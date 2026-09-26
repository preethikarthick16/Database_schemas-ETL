create database ecommerce_dw;
use ecommerce_dw;
create table dim_product (
product_id int primary key,
product_name varchar(100),
category varchar(50),
brand varchar(50));
    
create table dim_customer (
customer_id int primary key,
customer_name varchar(100),
email varchar(100),
mobile_number varchar(15));

create table dim_location (
location_id int primary key,
city varchar(50),
state varchar(50),
country varchar(50));

create table dim_date (
date_key int primary key,
full_date date,
day int,
month int,
year int,
quarter int);

create table fact_sales 
(sales_id int primary key,
date_key int ,
product_id int,
customer_id int,
location_id int,
quantity int,
unit_price decimal(10,2),
revenue decimal(12,2),
foreign key (date_key) references dim_date(date_key),
foreign key (product_id) references dim_product(product_id),
foreign key (customer_id) references dim_customer(customer_id),
foreign key (location_id) references dim_location(location_id));

insert into dim_product (product_id, product_name, category, brand) values
(1, 'Laptop', 'Electronics', 'Dell'),
(2, 'Mobile Phone', 'Electronics', 'Samsung'),
(3, 'Headphones', 'Electronics', 'Sony'),
(4, 'Keyboard', 'Electronics', 'Logitech'),
(5, 'Mouse', 'Electronics', 'HP'),
(6, 'T-Shirt', 'Clothing', 'Puma'),
(7, 'Jeans', 'Clothing', 'Levis'),
(8, 'Shoes', 'Footwear', 'Nike'),
(9, 'Backpack', 'Accessories', 'Wildcraft'),
(10, 'Watch', 'Accessories', 'Titan');

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

insert into dim_location(location_id, city, state, country) values
(1, 'Chennai', 'Tamil Nadu', 'India'),
(2, 'Bangalore', 'Karnataka', 'India'),
(3, 'Hyderabad', 'Telangana', 'India'),
(4, 'Mumbai', 'Maharashtra', 'India'),
(5, 'Delhi', 'Delhi', 'India'),
(6, 'Pune', 'Maharashtra', 'India'),
(7, 'Kochi', 'Kerala', 'India'),
(8, 'Coimbatore', 'Tamil Nadu', 'India'),
(9, 'Madurai', 'Tamil Nadu', 'India'),
(10, 'Kolkata', 'West Bengal', 'India');

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
(10, '2026-08-25', 25, 8, 2026,3);

INSERT INTO fact_sales
(sales_id, date_key, product_id, customer_id,
 location_id, quantity, unit_price, revenue)
VALUES
(1, 1, 1, 1, 1, 2, 55000.00, 110000.00),
(2, 2, 2, 2, 2, 1, 25000.00, 25000.00),
(3, 3, 3, 3, 3, 3, 5000.00, 15000.00),
(4, 4, 4, 4, 4, 2, 3000.00, 6000.00),
(5, 5, 5, 5, 5, 4, 1500.00, 6000.00),
(6, 6, 6, 6, 6, 3, 1200.00, 3600.00),
(7, 7, 7, 7, 7, 2, 2500.00, 5000.00),
(8, 8, 8, 8, 8, 1, 5000.00, 5000.00),
(9, 9, 9, 9, 9, 2, 1800.00, 3600.00),
(10, 10, 10, 10, 10, 1, 8000.00, 8000.00);

select * from fact_sales;
select * from dim_product;
select * from dim_customer;
select * from dim_date;
select * from dim_location;

###Total sales by product  
select
p.product_name,
sum(f.revenue) AS total_sales
from fact_sales f
join dim_product p
on f.product_id = p.product_id
group by p.product_name;

###Sales by category  
select
p.category,
sum(f.revenue) AS total_sales
from fact_sales f
join dim_product p
on f.product_id = p.product_id
group by p.category;

###Sales by brand  
select
p.brand,
sum(f.revenue) AS total_sales
from fact_sales f
join dim_product p
on f.product_id = p.product_id
group by p.brand;



###Sales by customer  
select
c.customer_name,
sum(f.revenue) AS total_sales
from fact_sales f
join dim_customer c
on f.customer_id = c.customer_id
group by c. customer_name;

###Sales by city  
select
l.city,
sum(f.revenue) AS total_sales
from fact_sales f
join dim_location l
on f.customer_id = l.location_id
group by l.city;

###Sales by date  
select
d.full_date,
sum(f.revenue) AS total_sales
from fact_sales f
join dim_date d
on f.date_key = d.date_key
group by d.full_date;

###Quantity sold and revenue 
select 
sum(quantity) as total_quantity_sold,
sum(revenue) as total_revenue
from fact_sales;

