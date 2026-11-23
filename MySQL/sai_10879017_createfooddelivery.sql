-- food delivery application
-- data base creation

CREATE DATABASE food_delivery_db;

USE food_delivery_db;

SELECT DATABASE();


USE food_delivery_db;
 
-- ==========================================
-- 1. CUSTOMERS
-- ==========================================
 
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    mobile VARCHAR(15) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 2. CUSTOMER ADDRESSES
-- ==========================================
 
CREATE TABLE customer_addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_type VARCHAR(30) DEFAULT 'HOME',
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    pincode VARCHAR(10),
    is_default BOOLEAN DEFAULT FALSE,
 
    CONSTRAINT fk_address_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
 
    INDEX idx_address_customer (customer_id)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 3. RESTAURANTS
-- ==========================================
 
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(150) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15),
    email VARCHAR(150) UNIQUE,
    opening_time TIME,
    closing_time TIME,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 4. FOOD CATEGORIES
-- ==========================================
 
CREATE TABLE food_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 5. MENU ITEMS
-- ==========================================
 
CREATE TABLE menu_items (
    menu_item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    food_name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    food_type ENUM('VEG','NON_VEG') NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 
    CONSTRAINT chk_menu_price
        CHECK (price >= 0),
 
    CONSTRAINT fk_menu_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),
 
    CONSTRAINT fk_menu_category
        FOREIGN KEY (category_id)
        REFERENCES food_categories(category_id),
 
    INDEX idx_menu_restaurant (restaurant_id),
    INDEX idx_menu_category (category_id)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 6. CARTS
-- One cart per customer in this basic design
-- ==========================================
 
CREATE TABLE carts (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 
    CONSTRAINT fk_cart_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 7. CART ITEMS
-- ==========================================
 
CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
 
    CONSTRAINT chk_cart_quantity
        CHECK (quantity > 0),
 
    CONSTRAINT fk_cartitem_cart
        FOREIGN KEY (cart_id)
        REFERENCES carts(cart_id),
 
    CONSTRAINT fk_cartitem_menu
        FOREIGN KEY (menu_item_id)
        REFERENCES menu_items(menu_item_id),
 
    CONSTRAINT uq_cart_menu
        UNIQUE (cart_id, menu_item_id)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 8. DELIVERY PARTNERS
-- ==========================================
 
CREATE TABLE delivery_partners (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL,
    mobile VARCHAR(15) NOT NULL UNIQUE,
    vehicle_number VARCHAR(30) UNIQUE,
    vehicle_type VARCHAR(50),
    availability_status ENUM(
        'AVAILABLE',
        'BUSY',
        'INACTIVE'
    ) DEFAULT 'AVAILABLE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 9. ORDERS
-- One order belongs to one restaurant
-- ==========================================
 
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    address_id INT,
    delivery_address VARCHAR(500) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL,
    delivery_charge DECIMAL(10,2) DEFAULT 0.00,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(10,2) NOT NULL,
    order_status ENUM(
        'PLACED',
        'CONFIRMED',
        'PREPARING',
        'READY_FOR_PICKUP',
        'OUT_FOR_DELIVERY',
        'DELIVERED',
        'CANCELLED'
    ) DEFAULT 'PLACED',
 
    CONSTRAINT chk_order_amounts
        CHECK (
            subtotal >= 0
            AND delivery_charge >= 0
            AND discount_amount >= 0
            AND total_amount >= 0
        ),
 
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
 
    CONSTRAINT fk_order_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),
 
    CONSTRAINT fk_order_address
        FOREIGN KEY (address_id)
        REFERENCES customer_addresses(address_id),
 
    INDEX idx_order_customer (customer_id),
    INDEX idx_order_restaurant (restaurant_id),
    INDEX idx_order_date (order_date)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 10. ORDER ITEMS
-- Store food name and price at order time
-- ==========================================
 
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT,
    food_name VARCHAR(150) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    item_total DECIMAL(10,2) NOT NULL,
 
    CONSTRAINT chk_orderitem_quantity
        CHECK (quantity > 0),
 
    CONSTRAINT chk_orderitem_price
        CHECK (unit_price >= 0 AND item_total >= 0),
 
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
 
    CONSTRAINT fk_orderitem_menu
        FOREIGN KEY (menu_item_id)
        REFERENCES menu_items(menu_item_id),
 
    INDEX idx_orderitem_order (order_id),
    INDEX idx_orderitem_menu (menu_item_id)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 11. PAYMENTS
-- Multiple payment attempts per order
-- ==========================================
 
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method ENUM(
        'UPI',
        'CREDIT_CARD',
        'DEBIT_CARD',
        'CASH_ON_DELIVERY'
    ) NOT NULL,
    transaction_reference VARCHAR(100) UNIQUE,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM(
        'PENDING',
        'SUCCESS',
        'FAILED'
    ) DEFAULT 'PENDING',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
 
    CONSTRAINT chk_payment_amount
        CHECK (payment_amount >= 0),
 
    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
 
    INDEX idx_payment_order (order_id)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 12. DELIVERIES
-- ==========================================
 
CREATE TABLE deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    partner_id INT NOT NULL,
    delivery_status ENUM(
        'ASSIGNED',
        'ACCEPTED',
        'PICKED_UP',
        'DELIVERED',
        'REJECTED'
    ) DEFAULT 'ASSIGNED',
    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    accepted_at DATETIME,
    pickup_time DATETIME,
    delivery_time DATETIME,
    estimated_delivery_time DATETIME,
 
    CONSTRAINT fk_delivery_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
 
    CONSTRAINT fk_delivery_partner
        FOREIGN KEY (partner_id)
        REFERENCES delivery_partners(partner_id),
 
    INDEX idx_delivery_partner (partner_id)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 13. ORDER STATUS HISTORY
-- ==========================================
 
CREATE TABLE order_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status VARCHAR(40) NOT NULL,
    status_description VARCHAR(255),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 
    CONSTRAINT fk_history_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
 
    INDEX idx_history_order (order_id)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 14. REVIEWS
-- Restaurant or food item review
-- ==========================================
 
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    restaurant_id INT,
    menu_item_id INT,
    rating INT NOT NULL,
    comments TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
 
    CONSTRAINT chk_review_rating
        CHECK (rating BETWEEN 1 AND 5),
 
    CONSTRAINT chk_review_target
        CHECK (
            restaurant_id IS NOT NULL
            OR menu_item_id IS NOT NULL
        ),
 
    CONSTRAINT fk_review_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
 
    CONSTRAINT fk_review_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
 
    CONSTRAINT fk_review_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),
 
    CONSTRAINT fk_review_menu
        FOREIGN KEY (menu_item_id)
        REFERENCES menu_items(menu_item_id),
 
    INDEX idx_review_restaurant (restaurant_id),
    INDEX idx_review_menu (menu_item_id)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 15. COUPONS
-- ==========================================
 
CREATE TABLE coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_code VARCHAR(50) NOT NULL UNIQUE,
    discount_type ENUM('PERCENTAGE','FIXED') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    minimum_order_value DECIMAL(10,2) DEFAULT 0.00,
    maximum_discount DECIMAL(10,2),
    valid_from DATETIME NOT NULL,
    valid_until DATETIME NOT NULL,
    usage_limit INT,
    is_active BOOLEAN DEFAULT TRUE,
 
    CONSTRAINT chk_coupon_discount
        CHECK (discount_value > 0),
 
    CONSTRAINT chk_coupon_dates
        CHECK (valid_until >= valid_from),
 
    CONSTRAINT chk_coupon_usage
        CHECK (usage_limit IS NULL OR usage_limit > 0)
) ENGINE=InnoDB;
 
 
-- ==========================================
-- 16. COUPON REDEMPTIONS
-- One redemption per customer per coupon
-- ==========================================
 
CREATE TABLE coupon_redemptions (
    redemption_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_id INT NOT NULL UNIQUE,
    discount_applied DECIMAL(10,2) NOT NULL,
    redeemed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 
    CONSTRAINT chk_redemption_discount
        CHECK (discount_applied >= 0),
 
    CONSTRAINT uq_coupon_customer
        UNIQUE (coupon_id, customer_id),
 
    CONSTRAINT fk_redemption_coupon
        FOREIGN KEY (coupon_id)
        REFERENCES coupons(coupon_id),
 
    CONSTRAINT fk_redemption_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
 
    CONSTRAINT fk_redemption_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
) ENGINE=InnoDB;
   

-- 17. refunds

CREATE TABLE refunds (
    refund_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL,
    refund_reason VARCHAR(255),
    refund_status ENUM(
        'REQUESTED',
        'PROCESSING',
        'COMPLETED',
        'FAILED'
    ) DEFAULT 'REQUESTED',
    refund_date DATETIME DEFAULT CURRENT_TIMESTAMP,
 
    CONSTRAINT chk_refund_amount
        CHECK (refund_amount > 0),
 
    CONSTRAINT fk_refund_payment
        FOREIGN KEY (payment_id)
        REFERENCES payments(payment_id),
 
    INDEX idx_refund_payment (payment_id)
) ENGINE=INNODB;

SHOW TABLES;

/*
SELECT COUNT(*) AS total_tables
FROM information_schema.tables
WHERE table_schema = 'food_delivery_db'
AND table_type = 'BASE TABLE';
*/

 