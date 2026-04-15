-- ===============================================
-- HYBRID E-COMMERCE SYSTEM - MYSQL DATABASE SETUP
-- ===============================================
-- Save this as: database/mysql-schema.sql
-- Run in MySQL: mysql -u root -p < mysql-schema.sql
-- OR copy-paste entire content in MySQL console
-- ===============================================

-- Create Database
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- ===============================================
-- TABLE 1: USERS (Customers & Admins)
-- ===============================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    role ENUM('customer', 'admin') DEFAULT 'customer',
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_status (status)
);

-- ===============================================
-- TABLE 2: ORDERS
-- ===============================================
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    shipping_address TEXT NOT NULL,
    payment_method VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_order_date (order_date),
    INDEX idx_status (status)
);

-- ===============================================
-- TABLE 3: ORDER_ITEMS (Products in Orders)
-- ===============================================
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id VARCHAR(100) NOT NULL,        -- Stores MongoDB ObjectId
    product_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id)
);

CREATE TABLE wishlist_items (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id VARCHAR(100) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2) DEFAULT 0,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_user_product (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(100) NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    status ENUM('pending', 'approved', 'hidden') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_reviews_product (product_id),
    INDEX idx_reviews_status (status)
);

CREATE TABLE coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    discount_type ENUM('flat', 'percent') DEFAULT 'percent',
    discount_value DECIMAL(10, 2) NOT NULL,
    min_order_amount DECIMAL(10, 2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE coupon_usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE SET NULL
);

-- ===============================================
-- SAMPLE DATA - USERS (Test Accounts)
-- ===============================================

-- Customer 1: password123
INSERT INTO users (username, email, password, full_name, phone, address, city, state, postal_code, role) 
VALUES ('john_doe', 'john@example.com', '123456', 'John Doe', '9876543210', '123 Main St', 'Delhi', 'Delhi', '110001', 'customer');

-- Customer 2: password456
INSERT INTO users (username, email, password, full_name, phone, address, city, state, postal_code, role) 
VALUES ('jane_smith', 'jane@example.com', '456789', 'Jane Smith', '9876543211', '456 Oak Ave', 'Mumbai', 'Maharashtra', '400001', 'customer');

-- Admin: adminpass
INSERT INTO users (username, email, password, full_name, phone, role) 
VALUES ('admin_user', 'admin@example.com', 'admin123', 'Admin User', '9999999999', 'admin');

-- ===============================================
-- SAMPLE DATA - ORDERS (Test Data)
-- ===============================================

-- Order 1 - for John Doe
INSERT INTO orders (user_id, total_amount, status, shipping_address, payment_method) 
VALUES (1, 5999.00, 'delivered', '123 Main St, Delhi', 'Credit Card');

-- Order 2 - for John Doe
INSERT INTO orders (user_id, total_amount, status, shipping_address, payment_method) 
VALUES (1, 2999.00, 'shipped', '123 Main St, Delhi', 'Debit Card');

-- Order 3 - for Jane Smith
INSERT INTO orders (user_id, total_amount, status, shipping_address, payment_method) 
VALUES (2, 7999.00, 'pending', '456 Oak Ave, Mumbai', 'Net Banking');

-- ===============================================
-- SAMPLE DATA - ORDER ITEMS (Products in Orders)
-- ===============================================
-- Items in Order 1
INSERT INTO order_items (order_id, product_id, product_name, quantity, price, subtotal) 
VALUES (1, '507f1f77bcf86cd799439011', 'Wireless Headphones', 1, 2999.00, 2999.00);

INSERT INTO order_items (order_id, product_id, product_name, quantity, price, subtotal) 
VALUES (1, '507f1f77bcf86cd799439012', 'USB-C Cable', 2, 1500.00, 3000.00);

-- Items in Order 2
INSERT INTO order_items (order_id, product_id, product_name, quantity, price, subtotal) 
VALUES (2, '507f1f77bcf86cd799439013', 'Phone Case', 1, 2999.00, 2999.00);

-- Items in Order 3
INSERT INTO order_items (order_id, product_id, product_name, quantity, price, subtotal) 
VALUES (3, '507f1f77bcf86cd799439011', 'Wireless Headphones', 2, 2999.00, 5998.00);

INSERT INTO order_items (order_id, product_id, product_name, quantity, price, subtotal) 
VALUES (3, '507f1f77bcf86cd799439014', 'Screen Protector', 1, 2001.00, 2001.00);

INSERT INTO coupons (code, description, discount_type, discount_value, min_order_amount, is_active)
VALUES
('SAVE10', '10% off on orders above 1000', 'percent', 10, 1000, TRUE),
('SAVE20', 'Flat 200 off on orders above 2000', 'flat', 200, 2000, TRUE),
('WELCOME5', '5% welcome discount', 'percent', 5, 500, TRUE);

-- ===============================================
-- VERIFY SETUP - Run These Queries
-- ===============================================
-- SELECT * FROM users;
-- SELECT * FROM orders;
-- SELECT * FROM order_items;

-- ===============================================
-- IMPORTANT: MySQL Connection Details
-- ===============================================
-- Host: localhost
-- Port: 3306
-- Database: ecommerce_db
-- Username: root
-- Password: (your MySQL password during installation)
-- ===============================================
