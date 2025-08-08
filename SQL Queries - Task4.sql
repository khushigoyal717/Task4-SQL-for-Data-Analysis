-- Create and use the database
DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;

-- Create tables
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    created_at DATE
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2),
    stock INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert sample data into customers
INSERT INTO customers (first_name, last_name, email, city, country, created_at) VALUES
('Alice', 'Smith', 'alice@example.com', 'Delhi', 'India', '2025-01-10'),
('Bob', 'Lee', 'bob@example.com', 'Mumbai', 'India', '2025-02-12'),
('Charlie', 'Brown', 'charlie@example.com', 'Bangalore', 'India', '2025-03-05'),
('David', 'Johnson', 'david@example.com', 'Pune', 'India', '2025-03-18');

-- Insert categories
INSERT INTO categories (name) VALUES
('Electronics'),
('Books'),
('Clothing');

-- Insert products
INSERT INTO products (name, category_id, price, stock) VALUES
('Laptop', 1, 799.99, 10),
('Headphones', 1, 39.99, 100),
('Data Science Book', 2, 45.00, 30),
('T-Shirt', 3, 15.00, 50);

-- Insert orders
INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
(1, '2025-03-10', 'completed', 84.98),
(2, '2025-03-15', 'completed', 45.00),
(3, '2025-03-20', 'pending', 799.99),
(4, '2025-03-22', 'completed', 60.00);

-- Insert order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 2, 39.99),
(2, 3, 1, 45.00),
(3, 1, 1, 799.99),
(4, 4, 4, 15.00);

-- ===========================
-- Analysis Queries
-- ===========================

-- 1. Show all customers
SELECT * FROM customers;

-- 2. Customers from Delhi
SELECT * FROM customers WHERE city = 'Delhi';

-- 3. Orders with total amount > 50
SELECT * FROM orders WHERE total_amount > 50;

-- 4. Join Orders with Customers
SELECT o.id AS order_id, c.first_name, c.last_name, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- 5. Revenue by Category
SELECT cat.name AS category, SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.id
JOIN categories cat ON p.category_id = cat.id
JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY cat.name;

-- 6. Average order value
SELECT AVG(total_amount) AS avg_order_value FROM orders;

-- 7. Top-selling product
SELECT p.name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.name
ORDER BY total_sold DESC
LIMIT 1;

-- 8. Pending orders
SELECT * FROM orders WHERE status = 'pending';

-- 9. Orders placed in March 2025
SELECT * FROM orders
WHERE MONTH(order_date) = 3 AND YEAR(order_date) = 2025;

-- 10. Create a view for completed orders
CREATE OR REPLACE VIEW completed_orders AS
SELECT o.id, c.first_name, c.last_name, o.order_date, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE o.status = 'completed';
SELECT * FROM completed_orders;

-- Show the view
SELECT * FROM completed_orders;


