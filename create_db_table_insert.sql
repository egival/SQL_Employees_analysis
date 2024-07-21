-- connect to e.g. postgres db. If via PowerShell then command "psql -U postgress"
CREATE DATABASE egi_db2;

 --connect to egi_db2: \c egi_db2;
CREATE TABLE customers (customer_id CHAR (10), customer_name VARCHAR(100));
--check if table created \dt

--insert values:
INSERT INTO customers (customer_id, customer_name) VALUES (1, 'Joe'), (2, 'Sofia');

--check if values were inserted:
SELECT * FROM customers;