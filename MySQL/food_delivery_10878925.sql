/*==============================================================
  FOOD DELIVERY MANAGEMENT SYSTEM
==============================================================*/

DROP DATABASE IF EXISTS food_delivery_db;

CREATE DATABASE food_delivery_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE food_delivery_db;


/*==============================================================
  TABLE CREATION
==============================================================*/

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    mobile_number VARCHAR(15) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE customer_address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    address_line1 VARCHAR(200) NOT NULL,
    address_line2 VARCHAR(200),
    city VARCHAR(80) NOT NULL,
    state VARCHAR(80) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    address_type ENUM('HOME', 'WORK', 'OTHER')
        NOT NULL DEFAULT 'HOME',
    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_address_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE restaurant (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_name VARCHAR(120) NOT NULL,
    address VARCHAR(250) NOT NULL,
    city VARCHAR(80) NOT NULL,
    contact_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_restaurant_hours
        CHECK (opening_time <> closing_time)
);

CREATE TABLE food_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(80) NOT NULL UNIQUE,
    description VARCHAR(250)
);

CREATE TABLE menu_item (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    item_name VARCHAR(120) NOT NULL,
    description VARCHAR(300),
    price DECIMAL(10,2) NOT NULL,
    is_vegetarian BOOLEAN NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_menu_item
        UNIQUE (restaurant_id, item_name),

    CONSTRAINT chk_menu_price
        CHECK (price > 0),

    CONSTRAINT fk_menu_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_menu_category
        FOREIGN KEY (category_id)
        REFERENCES food_category(category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_cart_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE cart_item (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_cart_item
        UNIQUE (cart_id, item_id),

    CONSTRAINT chk_cart_quantity
        CHECK (quantity > 0),

    CONSTRAINT fk_cartitem_cart
        FOREIGN KEY (cart_id)
        REFERENCES cart(cart_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_cartitem_menu
        FOREIGN KEY (item_id)
        REFERENCES menu_item(item_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE coupon (
    coupon_id INT PRIMARY KEY AUTO_INCREMENT,
    coupon_code VARCHAR(40) NOT NULL UNIQUE,
    discount_type ENUM('PERCENTAGE', 'FIXED') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    minimum_order_value DECIMAL(10,2) NOT NULL DEFAULT 0,
    maximum_discount DECIMAL(10,2),
    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL,
    usage_limit_per_customer INT NOT NULL DEFAULT 1,
    total_usage_limit INT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_coupon_value
        CHECK (discount_value > 0),

    CONSTRAINT chk_coupon_dates
        CHECK (valid_until >= valid_from),

    CONSTRAINT chk_coupon_usage
        CHECK (usage_limit_per_customer > 0)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    address_id INT NOT NULL,
    coupon_id INT,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    order_status ENUM(
        'PLACED',
        'CONFIRMED',
        'PREPARING',
        'READY_FOR_PICKUP',
        'OUT_FOR_DELIVERY',
        'DELIVERED',
        'CANCELLED',
        'REJECTED'
    ) NOT NULL DEFAULT 'PLACED',

    subtotal DECIMAL(10,2) NOT NULL,
    delivery_charge DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    final_amount DECIMAL(10,2) NOT NULL,
    cancellation_reason VARCHAR(300),

    CONSTRAINT chk_order_amounts
        CHECK (
            subtotal >= 0
            AND delivery_charge >= 0
            AND discount_amount >= 0
            AND final_amount >= 0
        ),

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_address
        FOREIGN KEY (address_id)
        REFERENCES customer_address(address_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_coupon
        FOREIGN KEY (coupon_id)
        REFERENCES coupon(coupon_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE order_item (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT uq_order_item
        UNIQUE (order_id, item_id),

    CONSTRAINT chk_orderitem_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_orderitem_price
        CHECK (unit_price > 0),

    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_orderitem_menu
        FOREIGN KEY (item_id)
        REFERENCES menu_item(item_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
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
        'FAILED',
        'REFUNDED'
    ) NOT NULL,

    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_payment_amount
        CHECK (payment_amount >= 0),

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE delivery_partner (
    partner_id INT PRIMARY KEY AUTO_INCREMENT,
    partner_name VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL UNIQUE,
    vehicle_number VARCHAR(30) NOT NULL UNIQUE,

    vehicle_type ENUM(
        'BIKE',
        'SCOOTER',
        'BICYCLE',
        'EV'
    ) NOT NULL,

    availability_status ENUM(
        'AVAILABLE',
        'BUSY',
        'OFFLINE'
    ) NOT NULL DEFAULT 'AVAILABLE',

    joined_at DATE NOT NULL
);

CREATE TABLE delivery (
    delivery_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    partner_id INT,

    assignment_status ENUM(
        'ASSIGNED',
        'ACCEPTED',
        'REJECTED',
        'COMPLETED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'ASSIGNED',

    pickup_time DATETIME,
    estimated_delivery_time DATETIME,
    delivered_time DATETIME,

    delivery_status ENUM(
        'WAITING',
        'PICKED_UP',
        'IN_TRANSIT',
        'DELIVERED',
        'FAILED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'WAITING',

    CONSTRAINT fk_delivery_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_delivery_partner
        FOREIGN KEY (partner_id)
        REFERENCES delivery_partner(partner_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE order_status_history (
    status_history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,

    status ENUM(
        'PLACED',
        'CONFIRMED',
        'PREPARING',
        'READY_FOR_PICKUP',
        'OUT_FOR_DELIVERY',
        'DELIVERED',
        'CANCELLED',
        'REJECTED'
    ) NOT NULL,

    status_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(300),

    CONSTRAINT fk_status_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    item_id INT,
    rating TINYINT NOT NULL,
    review_text VARCHAR(500),
    review_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_review_target
        UNIQUE (
            order_id,
            customer_id,
            restaurant_id,
            item_id
        ),

    CONSTRAINT chk_review_rating
        CHECK (rating BETWEEN 1 AND 5),

    CONSTRAINT fk_review_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_review_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_review_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_review_item
        FOREIGN KEY (item_id)
        REFERENCES menu_item(item_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE coupon_redemption (
    redemption_id INT PRIMARY KEY AUTO_INCREMENT,
    coupon_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_id INT NOT NULL UNIQUE,
    redeemed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    discount_amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_redemption_discount
        CHECK (discount_amount >= 0),

    CONSTRAINT fk_redemption_coupon
        FOREIGN KEY (coupon_id)
        REFERENCES coupon(coupon_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_redemption_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_redemption_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE refund (
    refund_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_id INT NOT NULL,
    order_id INT NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL,
    refund_reason VARCHAR(300) NOT NULL,

    refund_status ENUM(
        'REQUESTED',
        'PROCESSING',
        'COMPLETED',
        'FAILED'
    ) NOT NULL,

    refund_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_refund_amount
        CHECK (refund_amount > 0),

    CONSTRAINT fk_refund_payment
        FOREIGN KEY (payment_id)
        REFERENCES payment(payment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_refund_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


/*==============================================================
 SAMPLE DATA
==============================================================*/

INSERT INTO food_category
(category_name, description)
VALUES
('South Indian', 'Dosa, idli and related dishes'),
('North Indian', 'Curries, breads and rice dishes'),
('Chinese', 'Indo-Chinese dishes'),
('Fast Food', 'Burgers, pizza and snacks'),
('Desserts', 'Sweets and desserts'),
('Beverages', 'Hot and cold drinks');

INSERT INTO customer
(customer_name, email, mobile_number, password_hash, is_active)
VALUES
('Aarav Sharma', 'aarav@example.com', '9000000001', 'hash1', TRUE),
('Diya Patel', 'diya@example.com', '9000000002', 'hash2', TRUE),
('Rohan Das', 'rohan@example.com', '9000000003', 'hash3', TRUE),
('Meera Iyer', 'meera@example.com', '9000000004', 'hash4', TRUE),
('Kabir Singh', 'kabir@example.com', '9000000005', 'hash5', TRUE),
('Ananya Rao', 'ananya@example.com', '9000000006', 'hash6', TRUE),
('Vikram Nair', 'vikram@example.com', '9000000007', 'hash7', TRUE),
('Ishita Sen', 'ishita@example.com', '9000000008', 'hash8', TRUE),
('Neel Joshi', 'neel@example.com', '9000000009', 'hash9', TRUE),
('Tara Mishra', 'tara@example.com', '9000000010', 'hash10', FALSE);

INSERT INTO customer_address
(customer_id, address_line1, address_line2, city, state,
 pincode, address_type, is_default)
VALUES
(1, '101 Lake View Apartments', NULL, 'Bhubaneswar',
 'Odisha', '751001', 'HOME', TRUE),

(1, 'Infocity Campus', 'Patia', 'Bhubaneswar',
 'Odisha', '751024', 'WORK', FALSE),

(2, '22 Saheed Nagar', NULL, 'Bhubaneswar',
 'Odisha', '751007', 'HOME', TRUE),

(3, '19 Jayadev Vihar', NULL, 'Bhubaneswar',
 'Odisha', '751013', 'HOME', TRUE),

(4, '8 Kharavel Nagar', NULL, 'Bhubaneswar',
 'Odisha', '751001', 'HOME', TRUE),

(5, '44 Rasulgarh', NULL, 'Bhubaneswar',
 'Odisha', '751010', 'HOME', TRUE),

(6, '12 Chandrasekharpur', NULL, 'Bhubaneswar',
 'Odisha', '751016', 'HOME', TRUE),

(7, '17 Old Town', NULL, 'Bhubaneswar',
 'Odisha', '751002', 'HOME', TRUE),

(8, '77 Patia', NULL, 'Bhubaneswar',
 'Odisha', '751024', 'HOME', TRUE),

(9, '9 Nayapalli', NULL, 'Bhubaneswar',
 'Odisha', '751012', 'HOME', TRUE),

(10, '31 Baramunda', NULL, 'Bhubaneswar',
 'Odisha', '751003', 'HOME', TRUE);

INSERT INTO restaurant
(restaurant_name, address, city, contact_number, email,
 opening_time, closing_time, is_active)
VALUES
('Spice Route', 'Janpath Road', 'Bhubaneswar',
 '9100000001', 'spice@example.com',
 '10:00:00', '23:00:00', TRUE),

('Dosa Corner', 'Patia Square', 'Bhubaneswar',
 '9100000002', 'dosa@example.com',
 '07:00:00', '22:00:00', TRUE),

('Dragon Bowl', 'Saheed Nagar', 'Bhubaneswar',
 '9100000003', 'dragon@example.com',
 '11:00:00', '23:30:00', TRUE),

('Urban Bites', 'Nayapalli', 'Bhubaneswar',
 '9100000004', 'urban@example.com',
 '09:00:00', '23:00:00', TRUE),

('Sweet Truth', 'Jayadev Vihar', 'Bhubaneswar',
 '9100000005', 'sweet@example.com',
 '10:00:00', '22:30:00', TRUE),

('Coastal Kitchen', 'Old Town', 'Bhubaneswar',
 '9100000006', 'coastal@example.com',
 '11:00:00', '22:00:00', FALSE);

INSERT INTO menu_item
(restaurant_id, category_id, item_name, description,
 price, is_vegetarian, is_available)
VALUES
(1,2,'Paneer Butter Masala','Paneer in tomato gravy',280,TRUE,TRUE),
(1,2,'Chicken Biryani','Basmati rice with chicken',320,FALSE,TRUE),
(1,2,'Butter Naan','Tandoor-baked bread',55,TRUE,TRUE),
(1,6,'Masala Chaas','Spiced buttermilk',70,TRUE,TRUE),
(2,1,'Masala Dosa','Dosa with potato filling',140,TRUE,TRUE),
(2,1,'Idli Sambar','Steamed idli with sambar',90,TRUE,TRUE),
(2,1,'Mysore Dosa','Spicy chutney dosa',170,TRUE,TRUE),
(2,6,'Filter Coffee','South Indian coffee',65,TRUE,TRUE),
(3,3,'Veg Hakka Noodles','Vegetable noodles',210,TRUE,TRUE),
(3,3,'Chicken Manchurian','Chicken Manchurian',290,FALSE,TRUE),
(3,3,'Chilli Paneer','Paneer with peppers',250,TRUE,TRUE),
(3,6,'Lemon Iced Tea','Chilled lemon tea',95,TRUE,TRUE),
(4,4,'Classic Veg Burger','Vegetable patty burger',180,TRUE,TRUE),
(4,4,'Chicken Cheese Burger','Chicken burger',240,FALSE,TRUE),
(4,4,'Farmhouse Pizza','Vegetable pizza',360,TRUE,TRUE),
(4,4,'French Fries','Crispy fries',120,TRUE,FALSE),
(5,5,'Gulab Jamun','Two-piece serving',90,TRUE,TRUE),
(5,5,'Chocolate Brownie','Chocolate brownie',160,TRUE,TRUE),
(5,5,'Rasmalai','Two-piece serving',130,TRUE,TRUE),
(5,6,'Cold Coffee','Coffee with ice cream',150,TRUE,TRUE),
(6,2,'Dalma','Traditional lentil dish',190,TRUE,TRUE),
(6,2,'Pakhala Platter','Traditional rice platter',230,TRUE,TRUE);

INSERT INTO cart (customer_id)
SELECT customer_id
FROM customer
WHERE customer_id <= 9;

INSERT INTO cart_item
(cart_id, item_id, quantity)
VALUES
(1,1,1),
(1,3,2),
(2,5,2),
(3,9,1),
(4,17,3);

INSERT INTO coupon
(coupon_code, discount_type, discount_value,
 minimum_order_value, maximum_discount,
 valid_from, valid_until, usage_limit_per_customer,
 total_usage_limit, is_active)
VALUES
('WELCOME20','PERCENTAGE',20,200,100,
 '2025-01-01','2030-12-31',1,1000,TRUE),

('FLAT75','FIXED',75,400,75,
 '2025-01-01','2030-12-31',3,500,TRUE),

('SWEET10','PERCENTAGE',10,150,60,
 '2025-01-01','2030-12-31',2,300,TRUE),

('OLD50','FIXED',50,300,50,
 '2023-01-01','2023-12-31',1,100,FALSE);

INSERT INTO delivery_partner
(partner_name, mobile_number, vehicle_number,
 vehicle_type, availability_status, joined_at)
VALUES
('Arjun Rout','9200000001','OD02AA1001',
 'BIKE','AVAILABLE','2024-01-10'),

('Priya Behera','9200000002','OD02AA1002',
 'SCOOTER','BUSY','2024-02-15'),

('Manoj Sahu','9200000003','OD02AA1003',
 'EV','AVAILABLE','2024-03-20'),

('Ritu Mohanty','9200000004','OD02AA1004',
 'BICYCLE','OFFLINE','2024-04-05'),

('Sanjay Das','9200000005','OD02AA1005',
 'BIKE','AVAILABLE','2024-05-12'),

('Kiran Nayak','9200000006','OD02AA1006',
 'SCOOTER','AVAILABLE','2024-06-18');

INSERT INTO orders
(customer_id, restaurant_id, address_id, coupon_id,
 order_date, order_status, subtotal, delivery_charge,
 discount_amount, final_amount, cancellation_reason)
VALUES
(1,1,1,1,'2026-01-05 12:10:00','DELIVERED',390,40,78,352,NULL),
(2,2,3,NULL,'2026-01-08 08:30:00','DELIVERED',280,30,0,310,NULL),
(1,3,2,2,'2026-02-11 19:15:00','DELIVERED',500,40,75,465,NULL),
(3,4,4,NULL,'2026-02-14 20:00:00','DELIVERED',480,40,0,520,NULL),
(4,5,5,3,'2026-03-02 17:40:00','DELIVERED',340,30,34,336,NULL),

(5,1,6,NULL,'2026-03-10 13:05:00','CANCELLED',
 320,40,0,360,'Customer requested cancellation'),

(6,2,7,NULL,'2026-03-12 09:20:00','DELIVERED',335,30,0,365,NULL),
(7,3,8,NULL,'2026-04-01 20:10:00','DELIVERED',580,40,0,620,NULL),
(8,4,9,2,'2026-04-05 19:30:00','DELIVERED',600,40,75,565,NULL),
(1,5,1,NULL,'2026-04-09 16:20:00','DELIVERED',320,30,0,350,NULL),
(2,1,3,NULL,'2026-05-01 12:00:00','DELIVERED',655,40,0,695,NULL),
(3,2,4,NULL,'2026-05-06 08:10:00','DELIVERED',345,30,0,375,NULL),
(4,3,5,NULL,'2026-05-12 21:00:00','DELIVERED',500,40,0,540,NULL),
(5,4,6,NULL,'2026-06-03 19:00:00','DELIVERED',720,40,0,760,NULL),
(6,5,7,3,'2026-06-08 18:30:00','DELIVERED',450,30,45,435,NULL),
(7,1,8,NULL,'2026-07-01 13:15:00','DELIVERED',710,40,0,750,NULL),
(8,2,9,NULL,'2026-07-14 09:00:00','DELIVERED',460,30,0,490,NULL),
(1,4,1,2,'2026-08-02 20:20:00','DELIVERED',600,40,75,565,NULL),
(2,3,3,NULL,'2026-08-10 19:10:00','DELIVERED',790,40,0,830,NULL),
(3,5,4,NULL,'2026-09-04 17:00:00','DELIVERED',480,30,0,510,NULL),
(4,1,5,NULL,'2026-09-18 13:50:00','CONFIRMED',390,40,0,430,NULL),
(5,2,6,NULL,'2026-10-01 08:40:00','PREPARING',350,30,0,380,NULL),
(6,3,7,NULL,'2026-10-11 20:00:00','PLACED',305,40,0,345,NULL),

(7,4,8,NULL,'2026-10-20 19:30:00','REJECTED',
 180,40,0,220,'Restaurant capacity reached');

INSERT INTO order_item
(order_id, item_id, quantity, unit_price)
VALUES
(1,1,1,280),
(1,3,2,55),
(2,5,2,140),
(3,9,1,210),
(3,10,1,290),
(4,14,2,240),
(5,17,2,90),
(5,18,1,160),
(6,2,1,320),
(7,5,1,140),
(7,6,1,90),
(7,7,1,40),
(7,8,1,65),
(8,10,2,290),
(9,15,1,360),
(9,14,1,240),
(10,18,2,160),
(11,1,1,280),
(11,2,1,320),
(11,3,1,55),
(12,5,2,140),
(12,8,1,65),
(13,9,1,210),
(13,10,1,290),
(14,15,2,360),
(15,17,1,90),
(15,18,1,160),
(15,19,1,130),
(15,20,1,70),
(16,1,1,280),
(16,2,1,320),
(16,3,2,55),
(17,5,2,140),
(17,7,1,180),
(18,13,2,180),
(18,14,1,240),
(19,9,1,210),
(19,10,2,290),
(20,18,3,160),
(21,1,1,280),
(21,3,2,55),
(22,5,2,140),
(22,6,1,70),
(23,9,1,210),
(23,12,1,95),
(24,13,1,180);

INSERT INTO payment
(order_id, payment_method, transaction_reference,
 payment_amount, payment_status, payment_date)
VALUES
(1,'UPI','TXN001',352,'SUCCESS','2026-01-05 12:11:00'),
(2,'CASH_ON_DELIVERY','COD002',310,'SUCCESS','2026-01-08 09:10:00'),
(3,'UPI','TXN003A',465,'FAILED','2026-02-11 19:16:00'),
(3,'CREDIT_CARD','TXN003B',465,'SUCCESS','2026-02-11 19:18:00'),
(4,'DEBIT_CARD','TXN004',520,'SUCCESS','2026-02-14 20:02:00'),
(5,'UPI','TXN005',336,'SUCCESS','2026-03-02 17:42:00'),
(6,'UPI','TXN006',360,'REFUNDED','2026-03-10 13:06:00'),
(7,'UPI','TXN007',365,'SUCCESS','2026-03-12 09:21:00'),
(8,'CREDIT_CARD','TXN008',620,'SUCCESS','2026-04-01 20:12:00'),
(9,'UPI','TXN009',565,'SUCCESS','2026-04-05 19:31:00'),
(10,'CASH_ON_DELIVERY','COD010',350,'SUCCESS','2026-04-09 17:00:00'),
(11,'DEBIT_CARD','TXN011',695,'SUCCESS','2026-05-01 12:01:00'),
(12,'UPI','TXN012',375,'SUCCESS','2026-05-06 08:11:00'),
(13,'UPI','TXN013',540,'SUCCESS','2026-05-12 21:01:00'),
(14,'CREDIT_CARD','TXN014',760,'SUCCESS','2026-06-03 19:01:00'),
(15,'UPI','TXN015',435,'SUCCESS','2026-06-08 18:31:00'),
(16,'DEBIT_CARD','TXN016',750,'SUCCESS','2026-07-01 13:16:00'),
(17,'UPI','TXN017',490,'SUCCESS','2026-07-14 09:01:00'),
(18,'UPI','TXN018',565,'SUCCESS','2026-08-02 20:21:00'),
(19,'CREDIT_CARD','TXN019',830,'SUCCESS','2026-08-10 19:11:00'),
(20,'UPI','TXN020',510,'SUCCESS','2026-09-04 17:01:00');

INSERT INTO delivery
(order_id, partner_id, assignment_status, pickup_time,
 estimated_delivery_time, delivered_time, delivery_status)
VALUES
(1,1,'COMPLETED','2026-01-05 12:35:00',
 '2026-01-05 13:05:00','2026-01-05 13:00:00','DELIVERED'),

(2,1,'COMPLETED','2026-01-08 08:50:00',
 '2026-01-08 09:15:00','2026-01-08 09:10:00','DELIVERED'),

(3,1,'COMPLETED','2026-02-11 19:45:00',
 '2026-02-11 20:20:00','2026-02-11 20:15:00','DELIVERED'),

(4,1,'COMPLETED','2026-02-14 20:25:00',
 '2026-02-14 20:55:00','2026-02-14 20:50:00','DELIVERED'),

(5,1,'COMPLETED','2026-03-02 18:00:00',
 '2026-03-02 18:30:00','2026-03-02 18:25:00','DELIVERED'),

(7,1,'COMPLETED','2026-03-12 09:45:00',
 '2026-03-12 10:10:00','2026-03-12 10:05:00','DELIVERED'),

(8,1,'COMPLETED','2026-04-01 20:35:00',
 '2026-04-01 21:05:00','2026-04-01 21:00:00','DELIVERED'),

(9,2,'COMPLETED','2026-04-05 19:55:00',
 '2026-04-05 20:25:00','2026-04-05 20:20:00','DELIVERED'),

(10,2,'COMPLETED','2026-04-09 16:45:00',
 '2026-04-09 17:15:00','2026-04-09 17:10:00','DELIVERED'),

(11,2,'COMPLETED','2026-05-01 12:30:00',
 '2026-05-01 13:00:00','2026-05-01 12:55:00','DELIVERED'),

(12,2,'COMPLETED','2026-05-06 08:35:00',
 '2026-05-06 09:00:00','2026-05-06 08:58:00','DELIVERED'),

(13,2,'COMPLETED','2026-05-12 21:25:00',
 '2026-05-12 21:55:00','2026-05-12 21:50:00','DELIVERED'),

(14,2,'COMPLETED','2026-06-03 19:30:00',
 '2026-06-03 20:00:00','2026-06-03 19:55:00','DELIVERED'),

(15,3,'COMPLETED','2026-06-08 19:00:00',
 '2026-06-08 19:30:00','2026-06-08 19:25:00','DELIVERED'),

(16,3,'COMPLETED','2026-07-01 13:45:00',
 '2026-07-01 14:15:00','2026-07-01 14:10:00','DELIVERED'),

(17,3,'COMPLETED','2026-07-14 09:25:00',
 '2026-07-14 09:55:00','2026-07-14 09:50:00','DELIVERED'),

(18,3,'COMPLETED','2026-08-02 20:45:00',
 '2026-08-02 21:15:00','2026-08-02 21:10:00','DELIVERED'),

(19,3,'COMPLETED','2026-08-10 19:40:00',
 '2026-08-10 20:10:00','2026-08-10 20:05:00','DELIVERED'),

(20,3,'COMPLETED','2026-09-04 17:25:00',
 '2026-09-04 17:55:00','2026-09-04 17:50:00','DELIVERED'),

(21,4,'ACCEPTED',NULL,
 '2026-09-18 14:40:00',NULL,'WAITING'),

(22,5,'ACCEPTED',NULL,
 '2026-10-01 09:30:00',NULL,'WAITING');

INSERT INTO order_status_history
(order_id, status, status_time, remarks)
VALUES
(1,'PLACED','2026-01-05 12:10:00','Order created'),
(1,'CONFIRMED','2026-01-05 12:12:00','Restaurant accepted'),
(1,'PREPARING','2026-01-05 12:15:00','Kitchen started'),
(1,'OUT_FOR_DELIVERY','2026-01-05 12:35:00','Picked up'),
(1,'DELIVERED','2026-01-05 13:00:00','Delivered'),

(3,'PLACED','2026-02-11 19:15:00','Order created'),
(3,'CONFIRMED','2026-02-11 19:20:00','Restaurant accepted'),
(3,'OUT_FOR_DELIVERY','2026-02-11 19:45:00','Picked up'),
(3,'DELIVERED','2026-02-11 20:15:00','Delivered'),

(6,'PLACED','2026-03-10 13:05:00','Order created'),
(6,'CANCELLED','2026-03-10 13:15:00',
 'Customer requested cancellation'),

(21,'PLACED','2026-09-18 13:50:00','Order created'),
(21,'CONFIRMED','2026-09-18 13:53:00','Restaurant accepted'),

(22,'PLACED','2026-10-01 08:40:00','Order created'),
(22,'CONFIRMED','2026-10-01 08:42:00','Restaurant accepted'),
(22,'PREPARING','2026-10-01 08:45:00','Kitchen started');

INSERT INTO review
(order_id, customer_id, restaurant_id, item_id,
 rating, review_text, review_date)
VALUES
(1,1,1,1,5,'Excellent paneer dish','2026-01-06 10:00:00'),
(2,2,2,5,4,'Crisp and tasty dosa','2026-01-09 09:00:00'),
(3,1,3,10,4,'Good taste and packing','2026-02-12 09:00:00'),
(4,3,4,14,3,'Burger was good','2026-02-15 09:00:00'),
(5,4,5,18,5,'Fresh brownie','2026-03-03 09:00:00'),
(7,6,2,6,4,'Soft idli','2026-03-13 09:00:00'),
(8,7,3,10,5,'Great Manchurian','2026-04-02 09:00:00'),
(9,8,4,15,4,'Pizza arrived hot','2026-04-06 09:00:00'),
(11,2,1,2,5,'Excellent biryani','2026-05-02 09:00:00'),
(13,4,3,9,4,'Good noodles','2026-05-13 09:00:00'),
(15,6,5,17,5,'Very good sweets','2026-06-09 09:00:00');

INSERT INTO coupon_redemption
(coupon_id, customer_id, order_id, redeemed_at, discount_amount)
VALUES
(1,1,1,'2026-01-05 12:10:00',78),
(2,1,3,'2026-02-11 19:15:00',75),
(3,4,5,'2026-03-02 17:40:00',34),
(2,8,9,'2026-04-05 19:30:00',75),
(3,6,15,'2026-06-08 18:30:00',45),
(2,1,18,'2026-08-02 20:20:00',75);

INSERT INTO refund
(payment_id, order_id, refund_amount,
 refund_reason, refund_status, refund_date)
VALUES
(7,6,360,'Order cancelled by customer',
 'COMPLETED','2026-03-12 11:00:00');


/*==============================================================
 INSERT, UPDATE AND DELETE EXAMPLES
==============================================================*/

INSERT INTO food_category
(category_name, description)
VALUES
('Healthy', 'Salads and balanced meals');

UPDATE menu_item
SET price = 185.00
WHERE item_id = 13;

DELETE FROM food_category
WHERE category_name = 'Healthy';



--  Display all registered customers
SELECT *
FROM customer;

--  Display all active restaurants
SELECT *
FROM restaurant
WHERE is_active = TRUE;

--  Find all vegetarian food items
SELECT
    item_id,
    item_name,
    price
FROM menu_item
WHERE is_vegetarian = TRUE;

-- Display food items belonging to restaurant 1
SELECT
    item_id,
    item_name,
    price,
    is_available
FROM menu_item
WHERE restaurant_id = 1;

-- Find food items with a price greater than 200
SELECT
    item_id,
    item_name,
    price
FROM menu_item
WHERE price > 200
ORDER BY price DESC;

--  Display orders placed by customer 1
SELECT *
FROM orders
WHERE customer_id = 1
ORDER BY order_date DESC;

--  Display orders placed on 1 May 2026
SELECT *
FROM orders
WHERE DATE(order_date) = '2026-05-01';

-- Display all available delivery partners
SELECT *
FROM delivery_partner
WHERE availability_status = 'AVAILABLE';


--  Display customers with their addresses
SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    a.address_line1,
    a.city,
    a.state,
    a.pincode,
    a.address_type,
    a.is_default
FROM customer c
LEFT JOIN customer_address a
    ON a.customer_id = c.customer_id
ORDER BY
    c.customer_id,
    a.is_default DESC;

-- Display restaurants with their menu
SELECT
    r.restaurant_name,
    m.item_name,
    fc.category_name,
    m.price,
    m.is_available
FROM restaurant r
INNER JOIN menu_item m
    ON m.restaurant_id = r.restaurant_id
INNER JOIN food_category fc
    ON fc.category_id = m.category_id
ORDER BY
    r.restaurant_name,
    m.item_name;

--  Display complete order details
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    r.restaurant_name,
    m.item_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_total,
    o.order_status,
    o.final_amount
FROM orders o
INNER JOIN customer c
    ON c.customer_id = o.customer_id
INNER JOIN restaurant r
    ON r.restaurant_id = o.restaurant_id
INNER JOIN order_item oi
    ON oi.order_id = o.order_id
INNER JOIN menu_item m
    ON m.item_id = oi.item_id
ORDER BY
    o.order_id,
    oi.order_item_id;

--  Count orders placed by each customer
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customer c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_orders DESC;

-- Count available items in each restaurant
SELECT
    r.restaurant_id,
    r.restaurant_name,
    COUNT(m.item_id) AS available_items
FROM restaurant r
LEFT JOIN menu_item m
    ON m.restaurant_id = r.restaurant_id
    AND m.is_available = TRUE
GROUP BY
    r.restaurant_id,
    r.restaurant_name
ORDER BY available_items DESC;

--  Calculate sales generated by each restaurant
SELECT
    r.restaurant_id,
    r.restaurant_name,
    COALESCE(SUM(o.final_amount), 0) AS total_sales
FROM restaurant r
LEFT JOIN orders o
    ON o.restaurant_id = r.restaurant_id
    AND o.order_status = 'DELIVERED'
GROUP BY
    r.restaurant_id,
    r.restaurant_name
ORDER BY total_sales DESC;

--  Find the most frequently ordered food item
SELECT
    m.item_id,
    m.item_name,
    SUM(oi.quantity) AS total_quantity
FROM order_item oi
INNER JOIN menu_item m
    ON m.item_id = oi.item_id
INNER JOIN orders o
    ON o.order_id = oi.order_id
WHERE o.order_status = 'DELIVERED'
GROUP BY
    m.item_id,
    m.item_name
ORDER BY total_quantity DESC
LIMIT 1;

--  Find customers who have never placed an order
SELECT
    c.customer_id,
    c.customer_name
FROM customer c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

--  Find partners with more than five completed deliveries
SELECT
    dp.partner_id,
    dp.partner_name,
    COUNT(d.delivery_id) AS completed_deliveries
FROM delivery_partner dp
INNER JOIN delivery d
    ON d.partner_id = dp.partner_id
WHERE d.delivery_status = 'DELIVERED'
GROUP BY
    dp.partner_id,
    dp.partner_name
HAVING COUNT(d.delivery_id) > 5;

--  Calculate the average rating of each restaurant
SELECT
    r.restaurant_id,
    r.restaurant_name,
    ROUND(AVG(rv.rating), 2) AS average_rating
FROM restaurant r
LEFT JOIN review rv
    ON rv.restaurant_id = r.restaurant_id
GROUP BY
    r.restaurant_id,
    r.restaurant_name
ORDER BY average_rating DESC;



--  Find the customer who spent the highest amount
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.final_amount) AS total_spent
FROM customer c
INNER JOIN orders o
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'DELIVERED'
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY total_spent DESC
LIMIT 1;

--  Find the restaurant with the highest revenue
SELECT
    r.restaurant_id,
    r.restaurant_name,
    SUM(o.final_amount) AS revenue
FROM restaurant r
INNER JOIN orders o
    ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'DELIVERED'
GROUP BY
    r.restaurant_id,
    r.restaurant_name
ORDER BY revenue DESC
LIMIT 1;

--  Find the second most expensive food item
SELECT
    item_id,
    item_name,
    price
FROM menu_item
WHERE price = (
    SELECT MAX(price)
    FROM menu_item
    WHERE price < (
        SELECT MAX(price)
        FROM menu_item
    )
);

--  Find restaurants rated above the overall average
SELECT
    r.restaurant_id,
    r.restaurant_name,
    ROUND(AVG(rv.rating), 2) AS restaurant_average
FROM restaurant r
INNER JOIN review rv
    ON rv.restaurant_id = r.restaurant_id
GROUP BY
    r.restaurant_id,
    r.restaurant_name
HAVING AVG(rv.rating) > (
    SELECT AVG(rating)
    FROM review
);

--  Find customers with more orders than average
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS order_count
FROM customer c
INNER JOIN orders o
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(customer_order_count)
    FROM (
        SELECT
            customer_id,
            COUNT(*) AS customer_order_count
        FROM orders
        GROUP BY customer_id
    ) AS order_counts
);

--  Find food items that have never been ordered
SELECT
    m.item_id,
    m.item_name
FROM menu_item m
LEFT JOIN order_item oi
    ON oi.item_id = m.item_id
WHERE oi.order_item_id IS NULL;

--  Find the top three best-selling food items
SELECT
    m.item_id,
    m.item_name,
    SUM(oi.quantity) AS quantity_sold
FROM menu_item m
INNER JOIN order_item oi
    ON oi.item_id = m.item_id
INNER JOIN orders o
    ON o.order_id = oi.order_id
WHERE o.order_status = 'DELIVERED'
GROUP BY
    m.item_id,
    m.item_name
ORDER BY quantity_sold DESC
LIMIT 3;

--  Find customers who used coupons
SELECT DISTINCT
    c.customer_id,
    c.customer_name,
    cp.coupon_code
FROM coupon_redemption cr
INNER JOIN customer c
    ON c.customer_id = cr.customer_id
INNER JOIN coupon cp
    ON cp.coupon_id = cr.coupon_id
ORDER BY c.customer_name;

--  Find restaurants that have not received any orders
SELECT
    r.restaurant_id,
    r.restaurant_name
FROM restaurant r
LEFT JOIN orders o
    ON o.restaurant_id = r.restaurant_id
WHERE o.order_id IS NULL;

--  Generate a monthly restaurant revenue report
SELECT
    r.restaurant_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
    SUM(o.final_amount) AS monthly_revenue
FROM restaurant r
INNER JOIN orders o
    ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'DELIVERED'
GROUP BY
    r.restaurant_id,
    r.restaurant_name,
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY
    revenue_month,
    r.restaurant_name;

--  Find the partner with the highest delivery count
WITH delivery_counts AS (
    SELECT
        dp.partner_id,
        dp.partner_name,
        COUNT(d.delivery_id) AS completed_count
    FROM delivery_partner dp
    LEFT JOIN delivery d
        ON d.partner_id = dp.partner_id
        AND d.delivery_status = 'DELIVERED'
    GROUP BY
        dp.partner_id,
        dp.partner_name
)
SELECT *
FROM delivery_counts
WHERE completed_count = (
    SELECT MAX(completed_count)
    FROM delivery_counts
);

--  Find customers with orders but no reviews
SELECT
    c.customer_id,
    c.customer_name
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM review rv
    WHERE rv.customer_id = c.customer_id
);

/*==============================================================
 GETTING DATA FROM RELATED TABLES
==============================================================*/

-- Shows customers who have placed orders
SELECT
    c.customer_name,
    o.order_id,
    o.order_status
FROM customer c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;


-- Shows all customers, even if they have not placed an order
SELECT
    c.customer_name,
    o.order_id
FROM customer c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;


-- Same example using RIGHT JOIN
SELECT
    c.customer_name,
    o.order_id
FROM orders o
RIGHT JOIN customer c
    ON c.customer_id = o.customer_id;


/*==============================================================
ACCESS TO ORDER AND REVENUE DETAILS
==============================================================*/

CREATE OR REPLACE VIEW vw_order_summary AS
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    r.restaurant_name,
    o.order_status,
    o.subtotal,
    o.delivery_charge,
    o.discount_amount,
    o.final_amount
FROM orders o
INNER JOIN customer c
    ON c.customer_id = o.customer_id
INNER JOIN restaurant r
    ON r.restaurant_id = o.restaurant_id;

CREATE OR REPLACE VIEW vw_restaurant_monthly_revenue AS
SELECT
    o.restaurant_id,
    r.restaurant_name,
    DATE_FORMAT(o.order_date, '%Y-%m') AS revenue_month,
    SUM(o.final_amount) AS monthly_revenue
FROM orders o
INNER JOIN restaurant r
    ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'DELIVERED'
GROUP BY
    o.restaurant_id,
    r.restaurant_name,
    DATE_FORMAT(o.order_date, '%Y-%m');


/*==============================================================
 DATA SEARCH rders, menu items
  and delivery details.
==============================================================*/

-- Helps retrieve a customer's latest orders
CREATE INDEX idx_order_customer_date
ON orders(customer_id, order_date);

-- Helps restaurant order and sales reports
CREATE INDEX idx_order_restaurant_status
ON orders(restaurant_id, order_status);

-- Helps retrieve available menu items for a restaurant
CREATE INDEX idx_menu_restaurant_available
ON menu_item(restaurant_id, is_available);

-- Helps count completed deliveries for a partner
CREATE INDEX idx_delivery_partner_status
ON delivery(partner_id, delivery_status);


/*==============================================================
  CHECKING THE DB
==============================================================*/

SHOW TABLES;

