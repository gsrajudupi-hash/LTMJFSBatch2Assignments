-- ============================================================================
-- ONLINE FOOD DELIVERY MANAGEMENT SYSTEM (OFDMS)
-- Complete MySQL 8.0+ Schema, Sample Data & All 30 Business Queries
-- ============================================================================

DROP DATABASE IF EXISTS food_delivery_db;
CREATE DATABASE food_delivery_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE food_delivery_db;

-- ============================================================================
-- DDL: TABLE DEFINITIONS
-- ============================================================================

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'SUSPENDED') DEFAULT 'ACTIVE',
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer_email (email),
    INDEX idx_customer_phone (phone)
) ENGINE=InnoDB;

CREATE TABLE customer_addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    landmark VARCHAR(100),
    address_type ENUM('HOME', 'WORK', 'OTHER') DEFAULT 'HOME',
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_address_customer 
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_address_customer (customer_id)
) ENGINE=InnoDB;

CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    rating DECIMAL(3, 2) DEFAULT 0.00 CHECK (rating BETWEEN 0.00 AND 5.00),
    is_active BOOLEAN DEFAULT TRUE,
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_restaurant_city (city),
    INDEX idx_restaurant_active (is_active)
) ENGINE=InnoDB;

CREATE TABLE food_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0.00),
    is_veg BOOLEAN NOT NULL DEFAULT TRUE,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_menu_restaurant 
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_menu_category 
        FOREIGN KEY (category_id) REFERENCES food_categories(category_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_menu_restaurant (restaurant_id),
    INDEX idx_menu_category (category_id),
    INDEX idx_menu_price (price)
) ENGINE=InnoDB;

CREATE TABLE carts (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_customer 
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ci_cart 
        FOREIGN KEY (cart_id) REFERENCES carts(cart_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ci_item 
        FOREIGN KEY (item_id) REFERENCES menu_items(item_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_cart_item UNIQUE (cart_id, item_id)
) ENGINE=InnoDB;

CREATE TABLE coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(255),
    discount_type ENUM('PERCENTAGE', 'FIXED') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL CHECK (discount_value > 0.00),
    min_order_amount DECIMAL(10, 2) DEFAULT 0.00,
    max_discount_amount DECIMAL(10, 2),
    usage_limit_per_user INT DEFAULT 1,
    valid_from DATETIME NOT NULL,
    valid_until DATETIME NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    delivery_address_id INT NOT NULL,
    coupon_id INT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0.00),
    delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0.00),
    order_status ENUM('PLACED', 'CONFIRMED', 'PREPARING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED') DEFAULT 'PLACED',
    cancellation_reason VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_customer 
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_order_restaurant 
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_order_address 
        FOREIGN KEY (delivery_address_id) REFERENCES customer_addresses(address_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_order_coupon 
        FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_order_customer (customer_id),
    INDEX idx_order_restaurant (restaurant_id),
    INDEX idx_order_date (order_date),
    INDEX idx_order_status (order_status)
) ENGINE=InnoDB;

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    item_price DECIMAL(10, 2) NOT NULL CHECK (item_price >= 0.00),
    quantity INT NOT NULL CHECK (quantity > 0),
    item_subtotal DECIMAL(10, 2) NOT NULL CHECK (item_subtotal >= 0.00),
    CONSTRAINT fk_oi_order 
        FOREIGN KEY (order_id) REFERENCES orders(order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_oi_item 
        FOREIGN KEY (item_id) REFERENCES menu_items(item_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_oi_order (order_id),
    INDEX idx_oi_item (item_id)
) ENGINE=InnoDB;

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method ENUM('UPI', 'CREDIT_CARD', 'DEBIT_CARD', 'CASH_ON_DELIVERY') NOT NULL,
    transaction_reference VARCHAR(100) UNIQUE,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0.00),
    payment_status ENUM('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_order 
        FOREIGN KEY (order_id) REFERENCES orders(order_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_payment_order (order_id),
    INDEX idx_payment_status (payment_status)
) ENGINE=InnoDB;

CREATE TABLE delivery_partners (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    vehicle_type ENUM('BIKE', 'SCOOTER', 'CYCLE', 'EV') NOT NULL,
    vehicle_number VARCHAR(20) NOT NULL UNIQUE,
    is_available BOOLEAN DEFAULT TRUE,
    rating DECIMAL(3, 2) DEFAULT 0.00 CHECK (rating BETWEEN 0.00 AND 5.00),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_dp_available (is_available)
) ENGINE=InnoDB;

CREATE TABLE deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    partner_id INT NOT NULL,
    delivery_status ENUM('ASSIGNED', 'ACCEPTED', 'REJECTED', 'PICKED_UP', 'DELIVERED', 'FAILED') DEFAULT 'ASSIGNED',
    estimated_delivery_time DATETIME,
    pickup_time DATETIME,
    delivered_time DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_delivery_order 
        FOREIGN KEY (order_id) REFERENCES orders(order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_delivery_partner 
        FOREIGN KEY (partner_id) REFERENCES delivery_partners(partner_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_delivery_status (delivery_status)
) ENGINE=InnoDB;

CREATE TABLE order_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status ENUM('PLACED', 'CONFIRMED', 'PREPARING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED') NOT NULL,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(255),
    CONSTRAINT fk_osh_order 
        FOREIGN KEY (order_id) REFERENCES orders(order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_osh_order (order_id)
) ENGINE=InnoDB;

CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    restaurant_rating INT NOT NULL CHECK (restaurant_rating BETWEEN 1 AND 5),
    restaurant_review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_order 
        FOREIGN KEY (order_id) REFERENCES orders(order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_review_customer 
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_review_restaurant 
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_review_restaurant (restaurant_id)
) ENGINE=InnoDB;

CREATE TABLE coupon_redemptions (
    redemption_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_id INT NOT NULL UNIQUE,
    discount_applied DECIMAL(10, 2) NOT NULL,
    redeemed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cr_coupon 
        FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cr_customer 
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cr_order 
        FOREIGN KEY (order_id) REFERENCES orders(order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE refunds (
    refund_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_id INT NOT NULL,
    refund_amount DECIMAL(10, 2) NOT NULL CHECK (refund_amount > 0.00),
    reason VARCHAR(255) NOT NULL,
    refund_status ENUM('INITIATED', 'PROCESSING', 'COMPLETED', 'FAILED') DEFAULT 'INITIATED',
    processed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_refund_order 
        FOREIGN KEY (order_id) REFERENCES orders(order_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_refund_payment 
        FOREIGN KEY (payment_id) REFERENCES payments(payment_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================================
-- DML: SAMPLE DATA
-- ============================================================================

INSERT INTO customers (customer_id, first_name, last_name, email, phone, password_hash, status) VALUES
(1, 'Rahul', 'Sharma', 'rahul.sharma@example.com', '9876543210', '$2y$10$hash1', 'ACTIVE'),
(2, 'Priya', 'Patel', 'priya.patel@example.com', '9876543211', '$2y$10$hash2', 'ACTIVE'),
(3, 'Amit', 'Verma', 'amit.verma@example.com', '9876543212', '$2y$10$hash3', 'ACTIVE'),
(4, 'Sneha', 'Reddy', 'sneha.reddy@example.com', '9876543213', '$2y$10$hash4', 'ACTIVE'),
(5, 'Vikram', 'Singh', 'vikram.singh@example.com', '9876543214', '$2y$10$hash5', 'ACTIVE'),
(6, 'Ananya', 'Roy', 'ananya.roy@example.com', '9876543215', '$2y$10$hash6', 'ACTIVE'),
(7, 'Rohan', 'Gupta', 'rohan.gupta@example.com', '9876543216', '$2y$10$hash7', 'INACTIVE');

INSERT INTO customer_addresses (address_id, customer_id, address_line1, city, state, pincode, address_type, is_default) VALUES
(1, 1, 'Flat 401, Galaxy Apts, Bandra West', 'Mumbai', 'Maharashtra', '400050', 'HOME', 1),
(2, 1, 'Tech Park, Mindspace, Malad West', 'Mumbai', 'Maharashtra', '400064', 'WORK', 0),
(3, 2, '12B, Rose Villa, Indiranagar', 'Bangalore', 'Karnataka', '560038', 'HOME', 1),
(4, 4, 'B-302, Prestige Towers, Whitefield', 'Bangalore', 'Karnataka', '560066', 'HOME', 1),
(5, 5, 'House 45, Sector 15', 'Gurugram', 'Haryana', '122001', 'HOME', 1),
(6, 6, '54A, Southern Avenue', 'Kolkata', 'West Bengal', '700029', 'HOME', 1);

INSERT INTO restaurants (restaurant_id, name, email, phone, address, city, pincode, rating, is_active, opening_time, closing_time) VALUES
(1, 'Spice Symphony', 'contact@spicesymphony.com', '9123456780', '10 MG Road', 'Bangalore', '560001', 4.50, 1, '10:00:00', '23:00:00'),
(2, 'Biryani Blues', 'orders@biryaniblues.com', '9123456781', '45 Park Street', 'Kolkata', '700016', 4.80, 1, '11:00:00', '23:30:00'),
(3, 'Green Earth Cafe', 'hello@greenearth.com', '9123456782', 'Juhu Tara Road', 'Mumbai', '400049', 4.20, 1, '08:00:00', '22:00:00'),
(4, 'Wok & Roll', 'info@wokandroll.com', '9123456783', 'Cyber Hub, DLF Phase 2', 'Gurugram', '122002', 3.90, 1, '12:00:00', '23:00:00'),
(5, 'Pizza Paradise', 'support@pizzaparadise.com', '9123456784', 'Koramangala 5th Block', 'Bangalore', '560095', 3.50, 0, '11:00:00', '23:00:00'),
(6, 'Royal Sweets & Chaat', 'contact@royalsweets.com', '9123456785', 'Salt Lake Sector 1', 'Kolkata', '700064', 4.00, 1, '09:00:00', '21:00:00');

INSERT INTO food_categories (category_id, name, description) VALUES
(1, 'North Indian', 'Curries, breads and tandoori specialties'),
(2, 'Biryani', 'Aromatic rice dishes cooked with rich spices'),
(3, 'Chinese', 'Noodles, fried rice, and authentic Asian gravies'),
(4, 'Fast Food', 'Burgers, wraps, and quick casual bites'),
(5, 'Desserts', 'Sweet confectioneries, pastries, and treats'),
(6, 'Beverages', 'Refreshing shakes, juices, and cold brews');

INSERT INTO menu_items (item_id, restaurant_id, category_id, name, description, price, is_veg, is_available) VALUES
(1, 1, 1, 'Butter Chicken', 'Tender chicken in rich tomato makhani gravy', 320.00, 0, 1),
(2, 1, 1, 'Paneer Butter Masala', 'Cottage cheese cubes in spiced buttery gravy', 280.00, 1, 1),
(3, 1, 1, 'Garlic Naan', 'Clay oven baked bread brushed with garlic butter', 60.00, 1, 1),
(4, 2, 2, 'Hyderabadi Chicken Biryani', 'Fragrant basmati rice layered with spiced marinated chicken', 350.00, 0, 1),
(5, 2, 2, 'Kolkata Mutton Biryani', 'Slow cooked tender mutton with potato and boiled egg', 420.00, 0, 1),
(6, 2, 2, 'Mutton Biryani Jumbo Feast', 'Large sharing portion premium mutton biryani', 550.00, 0, 1),
(7, 3, 1, 'Dal Makhani', 'Slow simmered black lentils finished with fresh cream', 220.00, 1, 1),
(8, 3, 4, 'Avocado Toast', 'Toasted sourdough with seasoned mashed Hass avocado', 260.00, 1, 1),
(9, 3, 5, 'Vegan Chocolate Cake', 'Rich artisanal eggless dark chocolate cake', 180.00, 1, 1),
(10, 3, 6, 'Berry Blast Smoothie', 'Blended berries with Greek yogurt and honey', 150.00, 1, 1),
(11, 4, 3, 'Hakka Noodles', 'Wok-tossed noodles with crunchy seasonal vegetables', 190.00, 1, 1),
(12, 4, 3, 'Chilli Chicken Dry', 'Crispy chicken tossed in fiery green chillies and soy sauce', 290.00, 0, 1),
(13, 4, 3, 'Seafood Platter Supreme', 'Prawns, calamari and fish tossed in spicy XO sauce', 650.00, 0, 1),
(14, 6, 5, 'Gulab Jamun (2 pcs)', 'Golden fried milk solids soaked in rose cardamom syrup', 70.00, 1, 1),
(15, 6, 1, 'Chole Bhature', 'Spicy Punjabi chickpeas served with puffed bhature', 140.00, 1, 1),
(16, 1, 1, 'Tofu Salad with Dressing', 'Organic grilled tofu over greens with lemon vinaigrette', 210.00, 1, 0);

INSERT INTO coupons (coupon_id, code, description, discount_type, discount_value, min_order_amount, max_discount_amount, valid_from, valid_until, is_active) VALUES
(1, 'WELCOME50', '50% off on first order up to Rs 100', 'PERCENTAGE', 50.00, 200.00, 100.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1),
(2, 'FEAST20', '20% off on orders above Rs 500 up to Rs 150', 'PERCENTAGE', 20.00, 500.00, 150.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1),
(3, 'FLAT100', 'Flat Rs 100 off on orders above Rs 600', 'FIXED', 100.00, 600.00, 100.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1);

INSERT INTO delivery_partners (partner_id, name, phone, vehicle_type, vehicle_number, is_available, rating) VALUES
(1, 'Suresh Kumar', '9811223344', 'BIKE', 'KA-01-AB-1234', 1, 4.80),
(2, 'Ramesh Yadav', '9811223345', 'SCOOTER', 'WB-02-CD-5678', 1, 4.50),
(3, 'Rajesh Verma', '9811223346', 'EV', 'MH-03-EF-9012', 0, 4.20),
(4, 'Mahesh Shinde', '9811223347', 'BIKE', 'DL-04-GH-3456', 1, 4.00);

INSERT INTO orders (order_id, customer_id, restaurant_id, delivery_address_id, coupon_id, order_date, subtotal, delivery_fee, discount_amount, tax_amount, total_amount, order_status) VALUES
(1, 1, 1, 1, 1, '2026-10-15 19:30:00', 660.00, 40.00, 100.00, 33.00, 633.00, 'DELIVERED'),
(2, 2, 2, 3, 2, '2026-10-20 20:15:00', 770.00, 50.00, 150.00, 38.50, 708.50, 'DELIVERED'),
(3, 4, 2, 4, NULL, '2026-10-25 13:00:00', 970.00, 50.00, 0.00, 48.50, 1068.50, 'DELIVERED'),
(4, 4, 1, 4, 3, '2026-11-01 19:45:00', 660.00, 40.00, 100.00, 33.00, 633.00, 'DELIVERED'),
(5, 5, 4, 5, NULL, '2026-11-05 21:00:00', 480.00, 30.00, 0.00, 24.00, 534.00, 'DELIVERED'),
(6, 6, 2, 6, NULL, '2026-11-10 14:30:00', 420.00, 40.00, 0.00, 21.00, 481.00, 'DELIVERED'),
(7, 1, 3, 1, NULL, '2026-11-12 12:30:00', 440.00, 30.00, 0.00, 22.00, 492.00, 'DELIVERED'),
(8, 4, 2, 4, 2, '2026-11-12 20:00:00', 770.00, 50.00, 150.00, 38.50, 708.50, 'DELIVERED'),
(9, 5, 1, 5, NULL, '2026-11-14 19:15:00', 320.00, 40.00, 0.00, 16.00, 376.00, 'DELIVERED'),
(10, 1, 2, 1, NULL, '2026-11-15 13:30:00', 350.00, 40.00, 0.00, 17.50, 407.50, 'DELIVERED');

INSERT INTO order_items (order_item_id, order_id, item_id, item_price, quantity, item_subtotal) VALUES
(1, 1, 1, 320.00, 1, 320.00),
(2, 1, 2, 280.00, 1, 280.00),
(3, 1, 3, 60.00, 1, 60.00),
(4, 2, 4, 350.00, 1, 350.00),
(5, 2, 5, 420.00, 1, 420.00),
(6, 3, 4, 350.00, 1, 350.00),
(7, 3, 5, 420.00, 1, 420.00),
(8, 3, 9, 180.00, 1, 180.00),
(9, 4, 1, 320.00, 1, 320.00),
(10, 4, 2, 280.00, 1, 280.00),
(11, 4, 3, 60.00, 1, 60.00),
(12, 5, 11, 190.00, 1, 190.00),
(13, 5, 12, 290.00, 1, 290.00),
(14, 6, 5, 420.00, 1, 420.00),
(15, 7, 7, 220.00, 2, 440.00),
(16, 8, 4, 350.00, 1, 350.00),
(17, 8, 5, 420.00, 1, 420.00),
(18, 9, 1, 320.00, 1, 320.00),
(19, 10, 4, 350.00, 1, 350.00);

INSERT INTO payments (payment_id, order_id, payment_method, transaction_reference, amount, payment_status, payment_date) VALUES
(1, 1, 'UPI', 'UPI_TXN_001', 633.00, 'SUCCESS', '2026-10-15 19:31:00'),
(2, 2, 'CREDIT_CARD', 'CC_TXN_002', 708.50, 'SUCCESS', '2026-10-20 20:16:00'),
(3, 3, 'UPI', 'UPI_TXN_003', 1068.50, 'SUCCESS', '2026-10-25 13:02:00'),
(4, 4, 'DEBIT_CARD', 'DC_TXN_004', 633.00, 'SUCCESS', '2026-11-01 19:46:00'),
(5, 5, 'UPI', 'UPI_TXN_005', 534.00, 'SUCCESS', '2026-11-05 21:01:00'),
(6, 6, 'CASH_ON_DELIVERY', NULL, 481.00, 'SUCCESS', '2026-11-10 15:15:00'),
(7, 7, 'UPI', 'UPI_TXN_007', 492.00, 'SUCCESS', '2026-11-12 12:31:00'),
(8, 8, 'CREDIT_CARD', 'CC_TXN_008', 708.50, 'SUCCESS', '2026-11-12 20:01:00'),
(9, 9, 'UPI', 'UPI_TXN_009', 376.00, 'SUCCESS', '2026-11-14 19:16:00'),
(10, 10, 'UPI', 'UPI_TXN_010', 407.50, 'SUCCESS', '2026-11-15 13:31:00');

INSERT INTO deliveries (delivery_id, order_id, partner_id, delivery_status, estimated_delivery_time, pickup_time, delivered_time) VALUES
(1, 1, 1, 'DELIVERED', '2026-10-15 20:15:00', '2026-10-15 19:50:00', '2026-10-15 20:10:00'),
(2, 2, 1, 'DELIVERED', '2026-10-20 21:00:00', '2026-10-20 20:35:00', '2026-10-20 20:55:00'),
(3, 3, 1, 'DELIVERED', '2026-10-25 13:45:00', '2026-10-25 13:20:00', '2026-10-25 13:40:00'),
(4, 4, 1, 'DELIVERED', '2026-11-01 20:30:00', '2026-11-01 20:05:00', '2026-11-01 20:25:00'),
(5, 5, 2, 'DELIVERED', '2026-11-05 21:45:00', '2026-11-05 21:20:00', '2026-11-05 21:42:00'),
(6, 6, 2, 'DELIVERED', '2026-11-10 15:15:00', '2026-11-10 14:50:00', '2026-11-10 15:12:00'),
(7, 7, 1, 'DELIVERED', '2026-11-12 13:15:00', '2026-11-12 12:50:00', '2026-11-12 13:10:00'),
(8, 8, 1, 'DELIVERED', '2026-11-12 20:45:00', '2026-11-12 20:20:00', '2026-11-12 20:40:00'),
(9, 9, 2, 'DELIVERED', '2026-11-14 20:00:00', '2026-11-14 19:35:00', '2026-11-14 19:55:00'),
(10, 10, 1, 'DELIVERED', '2026-11-15 14:15:00', '2026-11-15 13:50:00', '2026-11-15 14:10:00');

INSERT INTO reviews (review_id, order_id, customer_id, restaurant_id, restaurant_rating, restaurant_review) VALUES
(1, 1, 1, 1, 5, 'Outstanding butter chicken and prompt delivery!'),
(2, 3, 4, 2, 5, 'Heavenly biryani! Best mutton pieces ever.'),
(3, 4, 4, 1, 4, 'Paneer was fresh and hot. Loved it.'),
(4, 5, 5, 4, 4, 'Tasty noodles, great quantity.'),
(5, 7, 1, 3, 4, 'Delicious Dal Makhani!'),
(6, 9, 5, 1, 4, 'Consistently good butter chicken.');

INSERT INTO coupon_redemptions (redemption_id, coupon_id, customer_id, order_id, discount_applied) VALUES
(1, 1, 1, 1, 100.00),
(2, 2, 2, 2, 150.00),
(3, 3, 4, 4, 100.00),
(4, 2, 4, 8, 150.00);

-- ============================================================================
-- SQL PROBLEM SOLVING: ALL 30 BUSINESS QUERIES
-- ============================================================================

-- Q1: Display all registered customers.
SELECT customer_id, first_name, last_name, email, phone, status, created_at FROM customers ORDER BY customer_id ASC;

-- Q2: Display all active restaurants.
SELECT restaurant_id, name, city, phone, rating, opening_time, closing_time FROM restaurants WHERE is_active = TRUE ORDER BY rating DESC;

-- Q3: Find all vegetarian food items.
SELECT item_id, name, price, description FROM menu_items WHERE is_veg = TRUE ORDER BY price ASC;

-- Q4: Display food items belonging to a particular restaurant (e.g., Spice Symphony, ID = 1).
SELECT m.item_id, m.name AS food_name, c.name AS category_name, m.price, m.is_veg, m.is_available FROM menu_items m JOIN food_categories c ON m.category_id = c.category_id WHERE m.restaurant_id = 1 ORDER BY m.price DESC;

-- Q5: Find food items whose price is greater than Rs 200.
SELECT item_id, name, price, is_veg FROM menu_items WHERE price > 200.00 ORDER BY price DESC;

-- Q6: Display all orders placed by a particular customer (e.g., Rahul Sharma, ID = 1).
SELECT order_id, order_date, subtotal, delivery_fee, discount_amount, total_amount, order_status FROM orders WHERE customer_id = 1 ORDER BY order_date DESC;

-- Q7: Find all orders placed on a particular date (e.g., '2026-11-12').
SELECT order_id, customer_id, restaurant_id, total_amount, order_status, order_date FROM orders WHERE DATE(order_date) = '2026-11-12' ORDER BY order_date ASC;

-- Q8: Display all available delivery partners.
SELECT partner_id, name, phone, vehicle_type, vehicle_number, rating FROM delivery_partners WHERE is_available = TRUE ORDER BY rating DESC;

-- Q9: Display customer details along with their delivery addresses.
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, c.phone, COALESCE(a.address_line1, 'No address') AS address, COALESCE(a.city, '-') AS city, COALESCE(a.state, '-') AS state, COALESCE(a.pincode, '-') AS pincode, COALESCE(a.address_type, '-') AS address_type, COALESCE(a.is_default, 0) AS is_default FROM customers c LEFT JOIN customer_addresses a ON c.customer_id = a.customer_id ORDER BY c.customer_id ASC, a.is_default DESC;

-- Q10: Display restaurant names along with their food menu.
SELECT r.name AS restaurant_name, m.name AS food_item, c.name AS category, m.price, CASE WHEN m.is_veg = 1 THEN 'Veg' ELSE 'Non-Veg' END AS food_type FROM restaurants r JOIN menu_items m ON r.restaurant_id = m.restaurant_id JOIN food_categories c ON m.category_id = c.category_id ORDER BY r.name ASC, m.price DESC;

-- Q11: Display complete order details, including customer and restaurant information.
SELECT o.order_id, o.order_date, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.phone AS customer_phone, r.name AS restaurant_name, r.city AS restaurant_city, o.subtotal, o.discount_amount, o.delivery_fee, o.total_amount, o.order_status FROM orders o JOIN customers c ON o.customer_id = c.customer_id JOIN restaurants r ON o.restaurant_id = r.restaurant_id ORDER BY o.order_id ASC;

-- Q12: Find the total number of orders placed by each customer.
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, COUNT(o.order_id) AS total_orders FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id GROUP BY c.customer_id, c.first_name, c.last_name, c.email ORDER BY total_orders DESC, c.customer_id ASC;

-- Q13: Find the total number of food items available in each restaurant.
SELECT r.restaurant_id, r.name AS restaurant_name, COUNT(m.item_id) AS available_items_count FROM restaurants r LEFT JOIN menu_items m ON r.restaurant_id = m.restaurant_id AND m.is_available = TRUE GROUP BY r.restaurant_id, r.name ORDER BY available_items_count DESC;

-- Q14: Calculate the total sales generated by each restaurant.
SELECT r.restaurant_id, r.name AS restaurant_name, COALESCE(SUM(o.total_amount), 0.00) AS total_sales FROM restaurants r LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id AND o.order_status = 'DELIVERED' GROUP BY r.restaurant_id, r.name ORDER BY total_sales DESC;

-- Q15: Find the most frequently ordered food item.
SELECT m.item_id, m.name AS food_item_name, r.name AS restaurant_name, SUM(oi.quantity) AS total_quantity_ordered FROM menu_items m JOIN order_items oi ON m.item_id = oi.item_id JOIN restaurants r ON m.restaurant_id = r.restaurant_id GROUP BY m.item_id, m.name, r.name ORDER BY total_quantity_ordered DESC LIMIT 1;

-- Q16: Find customers who have never placed an order.
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, c.phone FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id WHERE o.order_id IS NULL;

-- Q17: Display delivery partners who have completed more than five deliveries.
SELECT dp.partner_id, dp.name AS partner_name, dp.phone, dp.vehicle_type, COUNT(d.delivery_id) AS completed_deliveries FROM delivery_partners dp JOIN deliveries d ON dp.partner_id = d.partner_id WHERE d.delivery_status = 'DELIVERED' GROUP BY dp.partner_id, dp.name, dp.phone, dp.vehicle_type HAVING COUNT(d.delivery_id) > 5;

-- Q18: Find the average rating of each restaurant.
SELECT r.restaurant_id, r.name AS restaurant_name, ROUND(AVG(rev.restaurant_rating), 2) AS calculated_avg_rating, COUNT(rev.review_id) AS total_reviews FROM restaurants r LEFT JOIN reviews rev ON r.restaurant_id = rev.restaurant_id GROUP BY r.restaurant_id, r.name ORDER BY calculated_avg_rating DESC;

-- Q19: Find the customer who has spent the highest amount on food orders.
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, SUM(o.total_amount) AS total_spent FROM customers c JOIN orders o ON c.customer_id = o.customer_id WHERE o.order_status = 'DELIVERED' GROUP BY c.customer_id, c.first_name, c.last_name, c.email ORDER BY total_spent DESC LIMIT 1;

-- Q20: Find the restaurant that generated the highest revenue.
SELECT r.restaurant_id, r.name AS restaurant_name, r.city, SUM(o.total_amount) AS total_revenue FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id WHERE o.order_status = 'DELIVERED' GROUP BY r.restaurant_id, r.name, r.city ORDER BY total_revenue DESC LIMIT 1;

-- Q21: Find the second most expensive food item.
WITH RankedMenu AS (
    SELECT item_id, name, price, DENSE_RANK() OVER (ORDER BY price DESC) AS rnk FROM menu_items
)
SELECT item_id, name AS food_item_name, price FROM RankedMenu WHERE rnk = 2;

-- Q22: Find restaurants whose average ratings are greater than the overall average rating.
SELECT r.restaurant_id, r.name AS restaurant_name, ROUND(AVG(rev.restaurant_rating), 2) AS restaurant_avg_rating FROM restaurants r JOIN reviews rev ON r.restaurant_id = rev.restaurant_id GROUP BY r.restaurant_id, r.name HAVING AVG(rev.restaurant_rating) > (SELECT AVG(restaurant_rating) FROM reviews) ORDER BY restaurant_avg_rating DESC;

-- Q23: Find customers who have placed more orders than the average number of orders per customer.
WITH CustomerOrderCounts AS (
    SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(o.order_id) AS order_count FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, customer_name, order_count FROM CustomerOrderCounts WHERE order_count > (SELECT AVG(order_count) FROM CustomerOrderCounts) ORDER BY order_count DESC;

-- Q24: Find food items that have never been ordered.
SELECT m.item_id, m.name AS food_item_name, r.name AS restaurant_name, m.price FROM menu_items m JOIN restaurants r ON m.restaurant_id = r.restaurant_id LEFT JOIN order_items oi ON m.item_id = oi.item_id WHERE oi.order_item_id IS NULL ORDER BY m.price DESC;

-- Q25: Find the top three best-selling food items.
SELECT m.item_id, m.name AS food_item_name, SUM(oi.quantity) AS total_units_sold, SUM(oi.item_subtotal) AS total_revenue_generated FROM menu_items m JOIN order_items oi ON m.item_id = oi.item_id GROUP BY m.item_id, m.name ORDER BY total_units_sold DESC, total_revenue_generated DESC LIMIT 3;

-- Q26: Identify customers who have used promotional coupons.
SELECT DISTINCT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, cp.code AS coupon_code, cr.discount_applied FROM customers c JOIN coupon_redemptions cr ON c.customer_id = cr.customer_id JOIN coupons cp ON cr.coupon_id = cp.coupon_id ORDER BY c.customer_id ASC;

-- Q27: Find restaurants that have not received any orders.
SELECT r.restaurant_id, r.name AS restaurant_name, r.city, r.phone FROM restaurants r LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id WHERE o.order_id IS NULL;

-- Q28: Generate monthly restaurant revenue reports.
SELECT r.name AS restaurant_name, DATE_FORMAT(o.order_date, '%Y-%m') AS order_month, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS monthly_revenue FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id WHERE o.order_status = 'DELIVERED' GROUP BY r.name, DATE_FORMAT(o.order_date, '%Y-%m') ORDER BY order_month DESC, monthly_revenue DESC;

-- Q29: Find delivery partners with the highest number of completed deliveries.
WITH PartnerDeliveries AS (
    SELECT dp.partner_id, dp.name AS partner_name, dp.phone, COUNT(d.delivery_id) AS completed_deliveries, DENSE_RANK() OVER (ORDER BY COUNT(d.delivery_id) DESC) AS rank_pos FROM delivery_partners dp JOIN deliveries d ON dp.partner_id = d.partner_id WHERE d.delivery_status = 'DELIVERED' GROUP BY dp.partner_id, dp.name, dp.phone
)
SELECT partner_id, partner_name, phone, completed_deliveries FROM PartnerDeliveries WHERE rank_pos = 1;

-- Q30: Identify customers who have placed orders but have never submitted a review.
SELECT DISTINCT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, c.phone FROM customers c JOIN orders o ON c.customer_id = o.customer_id WHERE c.customer_id NOT IN (SELECT DISTINCT customer_id FROM reviews) ORDER BY c.customer_id ASC;
