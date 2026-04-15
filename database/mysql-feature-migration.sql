USE ecommerce_db;

-- ALTER TABLE users ADD COLUMN IF NOT EXISTS status ENUM('active', 'inactive') DEFAULT 'active' AFTER role;

UPDATE users SET status = 'active' WHERE status IS NULL;

CREATE TABLE IF NOT EXISTS wishlist_items (
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


CREATE TABLE IF NOT EXISTS reviews (
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

CREATE TABLE IF NOT EXISTS coupons (
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

CREATE TABLE IF NOT EXISTS coupon_usages (
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

INSERT INTO coupons (code, description, discount_type, discount_value, min_order_amount, is_active)
SELECT 'SAVE10', '10% off on orders above 1000', 'percent', 10, 1000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM coupons WHERE code = 'SAVE10');

INSERT INTO coupons (code, description, discount_type, discount_value, min_order_amount, is_active)
SELECT 'SAVE20', 'Flat 200 off on orders above 2000', 'flat', 200, 2000, TRUE
WHERE NOT EXISTS (SELECT 1 FROM coupons WHERE code = 'SAVE20');

INSERT INTO coupons (code, description, discount_type, discount_value, min_order_amount, is_active)
SELECT 'WELCOME5', '5% welcome discount', 'percent', 5, 500, TRUE
WHERE NOT EXISTS (SELECT 1 FROM coupons WHERE code = 'WELCOME5');
