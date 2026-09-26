CREATE DATABASE banking_dw;
USE banking_dw;

-- Customer Dimension
CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50));

-- Branch Dimension
CREATE TABLE dim_branch (
    branch_key INT PRIMARY KEY,
    branch_name VARCHAR(100),
    branch_city VARCHAR(50));

-- Date Dimension
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    month INT,
    quarter INT,
    year INT);

-- Loan Transaction Fact
CREATE TABLE fact_loan (
    loan_id INT PRIMARY KEY,
    customer_key INT,
    branch_key INT,
    date_key INT,
    loan_amount DECIMAL(12,2),
    interest_amount DECIMAL(12,2),
    loan_status VARCHAR(30),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (branch_key) REFERENCES dim_branch(branch_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key));

-- Account Transaction Fact
CREATE TABLE fact_account (
    transaction_id INT PRIMARY KEY,
    customer_key INT,
    branch_key INT,
    date_key INT,
    deposit_amount DECIMAL(12,2),
    withdrawal_amount DECIMAL(12,2),
    transaction_type VARCHAR(30),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (branch_key) REFERENCES dim_branch(branch_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key));
    
    -- Customer
INSERT INTO dim_customer VALUES
(1, 'Arun Kumar', 'Chennai'),
(2, 'Priya Sharma', 'Bangalore'),
(3, 'Rahul Kumar', 'Hyderabad'),
(4, 'Sneha Reddy', 'Chennai'),
(5, 'Vikram Singh', 'Mumbai');

-- Branch
INSERT INTO dim_branch VALUES
(1, 'Anna Nagar Branch', 'Chennai'),
(2, 'MG Road Branch', 'Bangalore'),
(3, 'Banjara Hills Branch', 'Hyderabad'),
(4, 'T Nagar Branch', 'Chennai'),
(5, 'Andheri Branch', 'Mumbai');

-- Date
INSERT INTO dim_date VALUES
(20260101, '2026-01-10', 1, 1, 2026),
(20260102, '2026-02-15', 2, 1, 2026),
(20260103, '2026-03-20', 3, 1, 2026),
(20260104, '2026-04-12', 4, 2, 2026),
(20260105, '2026-05-25', 5, 2, 2026);

-- Loan Fact
INSERT INTO fact_loan VALUES
(101, 1, 1, 20260101, 500000.00, 50000.00, 'Approved'),
(102, 2, 2, 20260102, 300000.00, 30000.00, 'Approved'),
(103, 3, 3, 20260103, 750000.00, 75000.00, 'Pending'),
(104, 4, 4, 20260104, 400000.00, 40000.00, 'Approved'),
(105, 5, 5, 20260105, 600000.00, 60000.00, 'Rejected');

-- Account Fact
INSERT INTO fact_account VALUES
(201, 1, 1, 20260101, 50000.00, 0.00, 'Deposit'),
(202, 2, 2, 20260102, 0.00, 20000.00, 'Withdrawal'),
(203, 3, 3, 20260103, 75000.00, 0.00, 'Deposit'),
(204, 4, 4, 20260104, 0.00, 15000.00, 'Withdrawal'),
(205, 5, 5, 20260105, 100000.00, 0.00, 'Deposit');

###rejected customer with loan amount
SELECT
    c.customer_name,
    SUM(l.loan_amount) AS total_loan_amount,
    SUM(l.interest_amount) AS total_interest
FROM fact_loan l
JOIN dim_customer c
    ON l.customer_key = c.customer_key
where loan_status = "rejected"
GROUP BY c.customer_name;

SELECT
    b.branch_name,
    SUM(a.deposit_amount) AS total_deposits,
    SUM(a.withdrawal_amount) AS total_withdrawals,
    a.transaction_type
FROM fact_account a
JOIN dim_branch b
    ON a.branch_key = b.branch_key
GROUP BY b.branch_name, a.transaction_type
order by a.transaction_type;