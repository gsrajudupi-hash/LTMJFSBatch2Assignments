
DROP DATABASE IF EXISTS online_food_delivery;

CREATE DATABASE online_food_delivery CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE online_food_delivery;

CREATE TABLE customer (
 customer_id BIGINT PRIMARY KEY AUTO_INCREMENT, full_name VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE, mobile VARCHAR(15) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL, status ENUM('ACTIVE','INACTIVE','ANONYMIZED') NOT NULL DEFAULT 'ACTIVE',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customer_address (
 address_id BIGINT PRIMARY KEY AUTO_INCREMENT, customer_id BIGINT NOT NULL, label VARCHAR(30) NOT NULL,
 line1 VARCHAR(150) NOT NULL, line2 VARCHAR(150), city VARCHAR(80) NOT NULL, state VARCHAR(80) NOT NULL,
 postal_code VARCHAR(10) NOT NULL, latitude DECIMAL(9,6), longitude DECIMAL(9,6), is_default BOOLEAN NOT NULL DEFAULT FALSE,
 CONSTRAINT fk_address_customer FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ;

CREATE TABLE restaurant (
 restaurant_id BIGINT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(120) NOT NULL, email VARCHAR(150) NOT NULL UNIQUE,
 phone VARCHAR(15) NOT NULL UNIQUE, address_line VARCHAR(200) NOT NULL, city VARCHAR(80) NOT NULL,
 opens_at TIME NOT NULL, closes_at TIME NOT NULL, is_active BOOLEAN NOT NULL DEFAULT TRUE,
 average_rating DECIMAL(3,2) NOT NULL DEFAULT 0 CHECK(average_rating BETWEEN 0 AND 5)
) ;

CREATE TABLE food_category (
 category_id BIGINT PRIMARY KEY AUTO_INCREMENT, category_name VARCHAR(80) NOT NULL UNIQUE,
 description VARCHAR(255), is_active BOOLEAN NOT NULL DEFAULT TRUE
) ;

CREATE TABLE menu_item (
 menu_item_id BIGINT PRIMARY KEY AUTO_INCREMENT, restaurant_id BIGINT NOT NULL, category_id BIGINT NOT NULL,
 item_name VARCHAR(120) NOT NULL, description VARCHAR(300), price DECIMAL(10,2) NOT NULL CHECK(price > 0),
 is_vegetarian BOOLEAN NOT NULL, is_available BOOLEAN NOT NULL DEFAULT TRUE, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_restaurant_item(restaurant_id,item_name),
 CONSTRAINT fk_menu_restaurant FOREIGN KEY(restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE RESTRICT,
 CONSTRAINT fk_menu_category FOREIGN KEY(category_id) REFERENCES food_category(category_id) ON DELETE RESTRICT
) ;

CREATE TABLE coupon (
 coupon_id BIGINT PRIMARY KEY AUTO_INCREMENT, coupon_code VARCHAR(30) NOT NULL UNIQUE,
 discount_type ENUM('PERCENTAGE','FIXED') NOT NULL, discount_value DECIMAL(10,2) NOT NULL CHECK(discount_value > 0),
 min_order_value DECIMAL(10,2) NOT NULL DEFAULT 0, max_discount DECIMAL(10,2), valid_from DATE NOT NULL,
 valid_to DATE NOT NULL, per_customer_limit INT NOT NULL DEFAULT 1 CHECK(per_customer_limit > 0), is_active BOOLEAN NOT NULL DEFAULT TRUE,
 CHECK(valid_to >= valid_from)
) ;

CREATE TABLE cart (
 cart_id BIGINT PRIMARY KEY AUTO_INCREMENT, customer_id BIGINT NOT NULL, restaurant_id BIGINT NOT NULL,
 status ENUM('ACTIVE','CONVERTED','ABANDONED') NOT NULL DEFAULT 'ACTIVE', created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL,
 CONSTRAINT fk_cart_customer FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT,
 CONSTRAINT fk_cart_restaurant FOREIGN KEY(restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE RESTRICT
) ;

CREATE TABLE cart_item (
 cart_item_id BIGINT PRIMARY KEY AUTO_INCREMENT, cart_id BIGINT NOT NULL, menu_item_id BIGINT NOT NULL,
 quantity INT NOT NULL CHECK(quantity > 0), unit_price_snapshot DECIMAL(10,2) NOT NULL CHECK(unit_price_snapshot > 0), added_at DATETIME NOT NULL,
 UNIQUE KEY uq_cart_menu(cart_id,menu_item_id),
 CONSTRAINT fk_cartitem_cart FOREIGN KEY(cart_id) REFERENCES cart(cart_id) ON DELETE CASCADE,
 CONSTRAINT fk_cartitem_menu FOREIGN KEY(menu_item_id) REFERENCES menu_item(menu_item_id) ON DELETE RESTRICT
) ;

CREATE TABLE orders (
 order_id BIGINT PRIMARY KEY AUTO_INCREMENT, customer_id BIGINT NOT NULL, restaurant_id BIGINT NOT NULL,
 address_id BIGINT NOT NULL, coupon_id BIGINT NULL, order_time DATETIME NOT NULL,
 status ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NOT NULL,
 subtotal DECIMAL(10,2) NOT NULL CHECK(subtotal >= 0), delivery_charge DECIMAL(10,2) NOT NULL CHECK(delivery_charge >= 0),
 discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK(discount_amount >= 0), final_amount DECIMAL(10,2) NOT NULL CHECK(final_amount >= 0),
 estimated_delivery_at DATETIME, cancellation_reason VARCHAR(255),
 CONSTRAINT fk_order_customer FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT,
 CONSTRAINT fk_order_restaurant FOREIGN KEY(restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE RESTRICT,
 CONSTRAINT fk_order_address FOREIGN KEY(address_id) REFERENCES customer_address(address_id) ON DELETE RESTRICT,
 CONSTRAINT fk_order_coupon FOREIGN KEY(coupon_id) REFERENCES coupon(coupon_id) ON DELETE SET NULL,
 CHECK(final_amount = subtotal + delivery_charge - discount_amount)
) ;

CREATE TABLE order_item (
 order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT, order_id BIGINT NOT NULL, menu_item_id BIGINT NOT NULL,
 item_name_snapshot VARCHAR(120) NOT NULL, quantity INT NOT NULL CHECK(quantity > 0), unit_price DECIMAL(10,2) NOT NULL CHECK(unit_price > 0),
 line_total DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
 CONSTRAINT fk_orderitem_order FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
 CONSTRAINT fk_orderitem_menu FOREIGN KEY(menu_item_id) REFERENCES menu_item(menu_item_id) ON DELETE RESTRICT
) ;

CREATE TABLE payment (
 payment_id BIGINT PRIMARY KEY AUTO_INCREMENT, order_id BIGINT NOT NULL,
 payment_method ENUM('UPI','CREDIT_CARD','DEBIT_CARD','COD') NOT NULL, transaction_ref VARCHAR(100) UNIQUE,
 amount DECIMAL(10,2) NOT NULL CHECK(amount > 0), payment_status ENUM('PENDING','SUCCESS','FAILED','REFUNDED') NOT NULL,
 paid_at DATETIME, created_at DATETIME NOT NULL,
 CONSTRAINT fk_payment_order FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE RESTRICT
) ;

CREATE TABLE delivery_partner (
 partner_id BIGINT PRIMARY KEY AUTO_INCREMENT, full_name VARCHAR(100) NOT NULL, mobile VARCHAR(15) NOT NULL UNIQUE,
 vehicle_number VARCHAR(30) NOT NULL UNIQUE, vehicle_type ENUM('BIKE','SCOOTER','BICYCLE') NOT NULL,
 availability_status ENUM('AVAILABLE','BUSY','OFFLINE') NOT NULL, joined_at DATE NOT NULL
) ;

CREATE TABLE delivery (
 delivery_id BIGINT PRIMARY KEY AUTO_INCREMENT, order_id BIGINT NOT NULL UNIQUE, partner_id BIGINT NOT NULL,
 assignment_status ENUM('ASSIGNED','ACCEPTED','REJECTED','COMPLETED','CANCELLED') NOT NULL, assigned_at DATETIME NOT NULL,
 accepted_at DATETIME, pickup_at DATETIME, delivered_at DATETIME,
 delivery_status ENUM('ASSIGNED','ACCEPTED','PICKED_UP','IN_TRANSIT','DELIVERED','CANCELLED') NOT NULL,
 CONSTRAINT fk_delivery_order FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE RESTRICT,
 CONSTRAINT fk_delivery_partner FOREIGN KEY(partner_id) REFERENCES delivery_partner(partner_id) ON DELETE RESTRICT
) ;

CREATE TABLE order_status_history (
 history_id BIGINT PRIMARY KEY AUTO_INCREMENT, order_id BIGINT NOT NULL,
 status ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NOT NULL,
 changed_at DATETIME NOT NULL, changed_by_type ENUM('CUSTOMER','RESTAURANT','PARTNER','SYSTEM','ADMIN') NOT NULL, remarks VARCHAR(255),
 CONSTRAINT fk_history_order FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
 INDEX idx_history_order_time(order_id,changed_at)
) ;

CREATE TABLE review (
 review_id BIGINT PRIMARY KEY AUTO_INCREMENT, customer_id BIGINT NOT NULL, order_id BIGINT NOT NULL,
 restaurant_id BIGINT NOT NULL, menu_item_id BIGINT NULL, rating TINYINT NOT NULL CHECK(rating BETWEEN 1 AND 5),
 comments VARCHAR(500), reviewed_at DATETIME NOT NULL,
 UNIQUE KEY uq_review_scope(customer_id,order_id,menu_item_id),
 CONSTRAINT fk_review_customer FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT,
 CONSTRAINT fk_review_order FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE RESTRICT,
 CONSTRAINT fk_review_restaurant FOREIGN KEY(restaurant_id) REFERENCES restaurant(restaurant_id) ON DELETE RESTRICT,
 CONSTRAINT fk_review_menu FOREIGN KEY(menu_item_id) REFERENCES menu_item(menu_item_id) ON DELETE RESTRICT
) ;

CREATE TABLE coupon_redemption (
 redemption_id BIGINT PRIMARY KEY AUTO_INCREMENT, coupon_id BIGINT NOT NULL, customer_id BIGINT NOT NULL,
 order_id BIGINT NOT NULL UNIQUE, discount_amount DECIMAL(10,2) NOT NULL CHECK(discount_amount >= 0), redeemed_at DATETIME NOT NULL,
 CONSTRAINT fk_redemption_coupon FOREIGN KEY(coupon_id) REFERENCES coupon(coupon_id) ON DELETE RESTRICT,
 CONSTRAINT fk_redemption_customer FOREIGN KEY(customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT,
 CONSTRAINT fk_redemption_order FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE RESTRICT,
 INDEX idx_redemption_limit(coupon_id,customer_id)
) ;

CREATE TABLE refund (
 refund_id BIGINT PRIMARY KEY AUTO_INCREMENT, payment_id BIGINT NOT NULL, order_id BIGINT NOT NULL,
 refund_reference VARCHAR(100) NOT NULL UNIQUE, refund_amount DECIMAL(10,2) NOT NULL CHECK(refund_amount > 0),
 refund_status ENUM('INITIATED','PROCESSED','FAILED') NOT NULL, reason VARCHAR(255) NOT NULL,
 initiated_at DATETIME NOT NULL, processed_at DATETIME,
 CONSTRAINT fk_refund_payment FOREIGN KEY(payment_id) REFERENCES payment(payment_id) ON DELETE RESTRICT,
 CONSTRAINT fk_refund_order FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE RESTRICT
) ;

CREATE INDEX idx_menu_search ON menu_item(restaurant_id,category_id,is_available,price);
CREATE INDEX idx_order_customer_time ON orders(customer_id,order_time);
CREATE INDEX idx_order_restaurant_status ON orders(restaurant_id,status,order_time);

SHOW DATABASES ;

SHOW TABLES ;

CREATE OR REPLACE VIEW vw_restaurant_monthly_revenue AS
SELECT r.restaurant_id, r.name, DATE_FORMAT(o.order_time,'%Y-%m') revenue_month,
       SUM(o.final_amount) revenue
FROM restaurant r JOIN orders o ON o.restaurant_id=r.restaurant_id
WHERE o.status='DELIVERED'
GROUP BY r.restaurant_id,r.name,DATE_FORMAT(o.order_time,'%Y-%m');
 
DELIMITER $$
CREATE TRIGGER trg_review_delivered_order
BEFORE INSERT ON review FOR EACH ROW
BEGIN
  IF NOT EXISTS (SELECT 1 FROM orders o WHERE o.order_id=NEW.order_id
                 AND o.customer_id=NEW.customer_id AND o.status='DELIVERED') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Review requires a delivered order owned by the customer';
  END IF;
END$$
CREATE TRIGGER trg_coupon_redemption_limit
BEFORE INSERT ON coupon_redemption FOR EACH ROW
BEGIN
  DECLARE used_count INT; DECLARE allowed_count INT;
  SELECT COUNT(*) INTO used_count FROM coupon_redemption
   WHERE coupon_id=NEW.coupon_id AND customer_id=NEW.customer_id;
  SELECT per_customer_limit INTO allowed_count FROM coupon WHERE coupon_id=NEW.coupon_id;
  IF used_count >= allowed_count THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Per-customer coupon limit exceeded';
  END IF;
END$$
DELIMITER ;




**********************************************************************************************************************************************
//Insert Queries

INSERT INTO customer (customer_id, full_name, email, mobile, password_hash, status, created_at) VALUES
(1, 'Customer 01', 'customer01@example.com', '9000000001', '$2y$hash01', 'ACTIVE', '2024-11-28 10:00:00'),
(2, 'Customer 02', 'customer02@example.com', '9000000002', '$2y$hash02', 'ACTIVE', '2024-11-29 10:00:00'),
(3, 'Customer 03', 'customer03@example.com', '9000000003', '$2y$hash03', 'ACTIVE', '2024-11-30 10:00:00'),
(4, 'Customer 04', 'customer04@example.com', '9000000004', '$2y$hash04', 'ACTIVE', '2024-12-01 10:00:00'),
(5, 'Customer 05', 'customer05@example.com', '9000000005', '$2y$hash05', 'ACTIVE', '2024-12-02 10:00:00'),
(6, 'Customer 06', 'customer06@example.com', '9000000006', '$2y$hash06', 'ACTIVE', '2024-12-03 10:00:00'),
(7, 'Customer 07', 'customer07@example.com', '9000000007', '$2y$hash07', 'ACTIVE', '2024-12-04 10:00:00'),
(8, 'Customer 08', 'customer08@example.com', '9000000008', '$2y$hash08', 'ACTIVE', '2024-12-05 10:00:00'),
(9, 'Customer 09', 'customer09@example.com', '9000000009', '$2y$hash09', 'ACTIVE', '2024-12-06 10:00:00'),
(10, 'Customer 10', 'customer10@example.com', '9000000010', '$2y$hash10', 'ACTIVE', '2024-12-07 10:00:00'),
(11, 'Customer 11', 'customer11@example.com', '9000000011', '$2y$hash11', 'ACTIVE', '2024-12-08 10:00:00'),
(12, 'Customer 12', 'customer12@example.com', '9000000012', '$2y$hash12', 'ACTIVE', '2024-12-09 10:00:00'),
(13, 'Customer 13', 'customer13@example.com', '9000000013', '$2y$hash13', 'ACTIVE', '2024-12-10 10:00:00'),
(14, 'Customer 14', 'customer14@example.com', '9000000014', '$2y$hash14', 'ACTIVE', '2024-12-11 10:00:00'),
(15, 'Customer 15', 'customer15@example.com', '9000000015', '$2y$hash15', 'ACTIVE', '2024-12-12 10:00:00'),
(16, 'Customer 16', 'customer16@example.com', '9000000016', '$2y$hash16', 'ACTIVE', '2024-12-13 10:00:00'),
(17, 'Customer 17', 'customer17@example.com', '9000000017', '$2y$hash17', 'ACTIVE', '2024-12-14 10:00:00'),
(18, 'Customer 18', 'customer18@example.com', '9000000018', '$2y$hash18', 'ACTIVE', '2024-12-15 10:00:00'),
(19, 'Customer 19', 'customer19@example.com', '9000000019', '$2y$hash19', 'ACTIVE', '2024-12-16 10:00:00'),
(20, 'Customer 20', 'customer20@example.com', '9000000020', '$2y$hash20', 'ACTIVE', '2024-12-17 10:00:00'),
(21, 'Customer 21', 'customer21@example.com', '9000000021', '$2y$hash21', 'ACTIVE', '2024-12-18 10:00:00'),
(22, 'Customer 22', 'customer22@example.com', '9000000022', '$2y$hash22', 'ACTIVE', '2024-12-19 10:00:00'),
(23, 'Customer 23', 'customer23@example.com', '9000000023', '$2y$hash23', 'ACTIVE', '2024-12-20 10:00:00'),
(24, 'Customer 24', 'customer24@example.com', '9000000024', '$2y$hash24', 'ACTIVE', '2024-12-21 10:00:00'),
(25, 'Customer 25', 'customer25@example.com', '9000000025', '$2y$hash25', 'ACTIVE', '2024-12-22 10:00:00'),
(26, 'Customer 26', 'customer26@example.com', '9000000026', '$2y$hash26', 'ACTIVE', '2024-12-23 10:00:00'),
(27, 'Customer 27', 'customer27@example.com', '9000000027', '$2y$hash27', 'ACTIVE', '2024-12-24 10:00:00'),
(28, 'Customer 28', 'customer28@example.com', '9000000028', '$2y$hash28', 'ACTIVE', '2024-12-25 10:00:00'),
(29, 'Customer 29', 'customer29@example.com', '9000000029', '$2y$hash29', 'INACTIVE', '2024-12-26 10:00:00'),
(30, 'Customer 30', 'customer30@example.com', '9000000030', '$2y$hash30', 'INACTIVE', '2024-12-27 10:00:00');
 
INSERT INTO customer_address (address_id, customer_id, label, line1, line2, city, state, postal_code, latitude, longitude, is_default) VALUES
(1, 1, 'Home', '101, Lake View Road', 'Sector 2', 'Hyderabad', 'Telangana', '500001', 17.3851, 78.4868, 1),
(2, 2, 'Home', '102, Lake View Road', 'Sector 3', 'Hyderabad', 'Telangana', '500002', 17.3852, 78.4869, 1),
(3, 3, 'Home', '103, Lake View Road', 'Sector 4', 'Hyderabad', 'Telangana', '500003', 17.3853, 78.487, 1),
(4, 4, 'Home', '104, Lake View Road', 'Sector 5', 'Hyderabad', 'Telangana', '500004', 17.3854, 78.4871, 1),
(5, 5, 'Home', '105, Lake View Road', 'Sector 6', 'Hyderabad', 'Telangana', '500005', 17.3855, 78.4872, 1),
(6, 6, 'Home', '106, Lake View Road', 'Sector 7', 'Hyderabad', 'Telangana', '500006', 17.3856, 78.4873, 1),
(7, 7, 'Home', '107, Lake View Road', 'Sector 8', 'Hyderabad', 'Telangana', '500007', 17.3857, 78.4874, 1),
(8, 8, 'Home', '108, Lake View Road', 'Sector 9', 'Hyderabad', 'Telangana', '500008', 17.385800000000003, 78.4875, 1),
(9, 9, 'Home', '109, Lake View Road', 'Sector 10', 'Hyderabad', 'Telangana', '500009', 17.385900000000003, 78.4876, 1),
(10, 10, 'Home', '110, Lake View Road', 'Sector 1', 'Hyderabad', 'Telangana', '500010', 17.386000000000003, 78.4877, 1),
(11, 11, 'Home', '111, Lake View Road', 'Sector 2', 'Hyderabad', 'Telangana', '500011', 17.386100000000003, 78.4878, 1),
(12, 12, 'Home', '112, Lake View Road', 'Sector 3', 'Hyderabad', 'Telangana', '500012', 17.386200000000002, 78.4879, 1),
(13, 13, 'Home', '113, Lake View Road', 'Sector 4', 'Hyderabad', 'Telangana', '500013', 17.386300000000002, 78.488, 1),
(14, 14, 'Home', '114, Lake View Road', 'Sector 5', 'Hyderabad', 'Telangana', '500014', 17.386400000000002, 78.4881, 1),
(15, 15, 'Home', '115, Lake View Road', 'Sector 6', 'Hyderabad', 'Telangana', '500015', 17.3865, 78.48819999999999, 1),
(16, 16, 'Home', '116, Lake View Road', 'Sector 7', 'Hyderabad', 'Telangana', '500016', 17.3866, 78.4883, 1),
(17, 17, 'Home', '117, Lake View Road', 'Sector 8', 'Hyderabad', 'Telangana', '500017', 17.3867, 78.4884, 1),
(18, 18, 'Home', '118, Lake View Road', 'Sector 9', 'Hyderabad', 'Telangana', '500018', 17.3868, 78.4885, 1),
(19, 19, 'Home', '119, Lake View Road', 'Sector 10', 'Hyderabad', 'Telangana', '500019', 17.3869, 78.4886, 1),
(20, 20, 'Home', '120, Lake View Road', 'Sector 1', 'Hyderabad', 'Telangana', '500020', 17.387, 78.4887, 1),
(21, 21, 'Home', '121, Lake View Road', 'Sector 2', 'Hyderabad', 'Telangana', '500021', 17.3871, 78.4888, 1),
(22, 22, 'Home', '122, Lake View Road', 'Sector 3', 'Hyderabad', 'Telangana', '500022', 17.3872, 78.4889, 1),
(23, 23, 'Home', '123, Lake View Road', 'Sector 4', 'Hyderabad', 'Telangana', '500023', 17.387300000000003, 78.489, 1),
(24, 24, 'Home', '124, Lake View Road', 'Sector 5', 'Hyderabad', 'Telangana', '500024', 17.387400000000003, 78.4891, 1),
(25, 25, 'Home', '125, Lake View Road', 'Sector 6', 'Hyderabad', 'Telangana', '500025', 17.387500000000003, 78.4892, 1),
(26, 26, 'Home', '126, Lake View Road', 'Sector 7', 'Hyderabad', 'Telangana', '500026', 17.387600000000003, 78.4893, 1),
(27, 27, 'Home', '127, Lake View Road', 'Sector 8', 'Hyderabad', 'Telangana', '500027', 17.387700000000002, 78.4894, 1),
(28, 28, 'Home', '128, Lake View Road', 'Sector 9', 'Hyderabad', 'Telangana', '500028', 17.387800000000002, 78.48949999999999, 1),
(29, 29, 'Home', '129, Lake View Road', 'Sector 10', 'Hyderabad', 'Telangana', '500029', 17.387900000000002, 78.4896, 1),
(30, 30, 'Home', '130, Lake View Road', 'Sector 1', 'Hyderabad', 'Telangana', '500030', 17.388, 78.4897, 1);
 
INSERT INTO restaurant (restaurant_id, name, email, phone, address_line, city, opens_at, closes_at, is_active, average_rating) VALUES
(1, 'Hyderabad Kitchen 01', 'restaurant01@example.com', '8000000001', '1, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.3),
(2, 'Hyderabad Kitchen 02', 'restaurant02@example.com', '8000000002', '2, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.4),
(3, 'Hyderabad Kitchen 03', 'restaurant03@example.com', '8000000003', '3, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.5),
(4, 'Hyderabad Kitchen 04', 'restaurant04@example.com', '8000000004', '4, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.6),
(5, 'Hyderabad Kitchen 05', 'restaurant05@example.com', '8000000005', '5, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.7),
(6, 'Hyderabad Kitchen 06', 'restaurant06@example.com', '8000000006', '6, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.8),
(7, 'Hyderabad Kitchen 07', 'restaurant07@example.com', '8000000007', '7, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.9),
(8, 'Hyderabad Kitchen 08', 'restaurant08@example.com', '8000000008', '8, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.0),
(9, 'Hyderabad Kitchen 09', 'restaurant09@example.com', '8000000009', '9, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.1),
(10, 'Hyderabad Kitchen 10', 'restaurant10@example.com', '8000000010', '10, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.2),
(11, 'Hyderabad Kitchen 11', 'restaurant11@example.com', '8000000011', '11, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.3),
(12, 'Hyderabad Kitchen 12', 'restaurant12@example.com', '8000000012', '12, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.4),
(13, 'Hyderabad Kitchen 13', 'restaurant13@example.com', '8000000013', '13, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.5),
(14, 'Hyderabad Kitchen 14', 'restaurant14@example.com', '8000000014', '14, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.6),
(15, 'Hyderabad Kitchen 15', 'restaurant15@example.com', '8000000015', '15, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.7),
(16, 'Hyderabad Kitchen 16', 'restaurant16@example.com', '8000000016', '16, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.8),
(17, 'Hyderabad Kitchen 17', 'restaurant17@example.com', '8000000017', '17, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.9),
(18, 'Hyderabad Kitchen 18', 'restaurant18@example.com', '8000000018', '18, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.2),
(19, 'Hyderabad Kitchen 19', 'restaurant19@example.com', '8000000019', '19, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.3),
(20, 'Hyderabad Kitchen 20', 'restaurant20@example.com', '8000000020', '20, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.4),
(21, 'Hyderabad Kitchen 21', 'restaurant21@example.com', '8000000021', '21, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.5),
(22, 'Hyderabad Kitchen 22', 'restaurant22@example.com', '8000000022', '22, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.6),
(23, 'Hyderabad Kitchen 23', 'restaurant23@example.com', '8000000023', '23, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.7),
(24, 'Hyderabad Kitchen 24', 'restaurant24@example.com', '8000000024', '24, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.8),
(25, 'Hyderabad Kitchen 25', 'restaurant25@example.com', '8000000025', '25, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 3.9),
(26, 'Hyderabad Kitchen 26', 'restaurant26@example.com', '8000000026', '26, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.0),
(27, 'Hyderabad Kitchen 27', 'restaurant27@example.com', '8000000027', '27, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.1),
(28, 'Hyderabad Kitchen 28', 'restaurant28@example.com', '8000000028', '28, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 1, 4.2),
(29, 'Hyderabad Kitchen 29', 'restaurant29@example.com', '8000000029', '29, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 0, 4.3),
(30, 'Hyderabad Kitchen 30', 'restaurant30@example.com', '8000000030', '30, Food Street', 'Hyderabad', '09:00:00', '23:00:00', 0, 4.4);
 
INSERT INTO food_category (category_id, category_name, description, is_active) VALUES
(1, 'South Indian', 'South Indian menu classification', 1),
(2, 'North Indian', 'North Indian menu classification', 1),
(3, 'Chinese', 'Chinese menu classification', 1),
(4, 'Fast Food', 'Fast Food menu classification', 1),
(5, 'Desserts', 'Desserts menu classification', 1),
(6, 'Beverages', 'Beverages menu classification', 1),
(7, 'Biryani', 'Biryani menu classification', 1),
(8, 'Seafood', 'Seafood menu classification', 1),
(9, 'Continental', 'Continental menu classification', 1),
(10, 'Italian', 'Italian menu classification', 1),
(11, 'Mexican', 'Mexican menu classification', 1),
(12, 'Thai', 'Thai menu classification', 1),
(13, 'Bakery', 'Bakery menu classification', 1),
(14, 'Salads', 'Salads menu classification', 1),
(15, 'Soups', 'Soups menu classification', 1),
(16, 'Street Food', 'Street Food menu classification', 1),
(17, 'Healthy', 'Healthy menu classification', 1),
(18, 'Vegan', 'Vegan menu classification', 1),
(19, 'Breakfast', 'Breakfast menu classification', 1),
(20, 'Rice Bowls', 'Rice Bowls menu classification', 1),
(21, 'Kebabs', 'Kebabs menu classification', 1),
(22, 'Punjabi', 'Punjabi menu classification', 1),
(23, 'Andhra', 'Andhra menu classification', 1),
(24, 'Hyderabadi', 'Hyderabadi menu classification', 1),
(25, 'Ice Cream', 'Ice Cream menu classification', 1),
(26, 'Juices', 'Juices menu classification', 1),
(27, 'Coffee', 'Coffee menu classification', 1),
(28, 'Tea', 'Tea menu classification', 1),
(29, 'Snacks', 'Snacks menu classification', 1),
(30, 'Combo Meals', 'Combo Meals menu classification', 1);
 
INSERT INTO menu_item (menu_item_id, restaurant_id, category_id, item_name, description, price, is_vegetarian, is_available, created_at) VALUES
(1, 1, 1, 'South Indian Special', 'Freshly prepared south indian signature item', 117, 1, 1, '2025-06-16 10:00:00'),
(2, 2, 2, 'North Indian Special', 'Freshly prepared north indian signature item', 134, 1, 1, '2025-06-17 10:00:00'),
(3, 3, 3, 'Chinese Special', 'Freshly prepared chinese signature item', 151, 0, 1, '2025-06-18 10:00:00'),
(4, 4, 4, 'Fast Food Special', 'Freshly prepared fast food signature item', 168, 1, 1, '2025-06-19 10:00:00'),
(5, 5, 5, 'Desserts Special', 'Freshly prepared desserts signature item', 185, 1, 1, '2025-06-20 10:00:00'),
(6, 6, 6, 'Beverages Special', 'Freshly prepared beverages signature item', 202, 0, 1, '2025-06-21 10:00:00'),
(7, 7, 7, 'Biryani Special', 'Freshly prepared biryani signature item', 219, 1, 1, '2025-06-22 10:00:00'),
(8, 8, 8, 'Seafood Special', 'Freshly prepared seafood signature item', 236, 1, 1, '2025-06-23 10:00:00'),
(9, 9, 9, 'Continental Special', 'Freshly prepared continental signature item', 253, 0, 1, '2025-06-24 10:00:00'),
(10, 10, 10, 'Italian Special', 'Freshly prepared italian signature item', 270, 1, 1, '2025-06-25 10:00:00'),
(11, 11, 11, 'Mexican Special', 'Freshly prepared mexican signature item', 287, 1, 1, '2025-06-26 10:00:00'),
(12, 12, 12, 'Thai Special', 'Freshly prepared thai signature item', 304, 0, 1, '2025-06-27 10:00:00'),
(13, 13, 13, 'Bakery Special', 'Freshly prepared bakery signature item', 321, 1, 1, '2025-06-28 10:00:00'),
(14, 14, 14, 'Salads Special', 'Freshly prepared salads signature item', 338, 1, 1, '2025-06-29 10:00:00'),
(15, 15, 15, 'Soups Special', 'Freshly prepared soups signature item', 355, 0, 1, '2025-06-30 10:00:00'),
(16, 16, 16, 'Street Food Special', 'Freshly prepared street food signature item', 372, 1, 1, '2025-07-01 10:00:00'),
(17, 17, 17, 'Healthy Special', 'Freshly prepared healthy signature item', 389, 1, 1, '2025-07-02 10:00:00'),
(18, 18, 18, 'Vegan Special', 'Freshly prepared vegan signature item', 406, 0, 1, '2025-07-03 10:00:00'),
(19, 19, 19, 'Breakfast Special', 'Freshly prepared breakfast signature item', 423, 1, 1, '2025-07-04 10:00:00'),
(20, 20, 20, 'Rice Bowls Special', 'Freshly prepared rice bowls signature item', 440, 1, 1, '2025-07-05 10:00:00'),
(21, 21, 21, 'Kebabs Special', 'Freshly prepared kebabs signature item', 457, 0, 1, '2025-07-06 10:00:00'),
(22, 22, 22, 'Punjabi Special', 'Freshly prepared punjabi signature item', 474, 1, 1, '2025-07-07 10:00:00'),
(23, 23, 23, 'Andhra Special', 'Freshly prepared andhra signature item', 491, 1, 1, '2025-07-08 10:00:00'),
(24, 24, 24, 'Hyderabadi Special', 'Freshly prepared hyderabadi signature item', 508, 0, 1, '2025-07-09 10:00:00'),
(25, 25, 25, 'Ice Cream Special', 'Freshly prepared ice cream signature item', 105, 1, 1, '2025-07-10 10:00:00'),
(26, 26, 26, 'Juices Special', 'Freshly prepared juices signature item', 122, 1, 1, '2025-07-11 10:00:00'),
(27, 27, 27, 'Coffee Special', 'Freshly prepared coffee signature item', 139, 0, 1, '2025-07-12 10:00:00'),
(28, 28, 28, 'Tea Special', 'Freshly prepared tea signature item', 156, 1, 0, '2025-07-13 10:00:00'),
(29, 29, 29, 'Snacks Special', 'Freshly prepared snacks signature item', 173, 1, 0, '2025-07-14 10:00:00'),
(30, 30, 30, 'Combo Meals Special', 'Freshly prepared combo meals signature item', 190, 0, 0, '2025-07-15 10:00:00');
 
INSERT INTO coupon (coupon_id, coupon_code, discount_type, discount_value, min_order_value, max_discount, valid_from, valid_to, per_customer_limit, is_active) VALUES
(1, 'FOOD01', 'PERCENTAGE', 15, 200, 150, '2026-01-01', '2026-12-31', 2, 1),
(2, 'FOOD02', 'FIXED', 60, 200, NULL, '2026-01-01', '2026-12-31', 3, 1),
(3, 'FOOD03', 'PERCENTAGE', 25, 200, 150, '2026-01-01', '2026-12-31', 1, 1),
(4, 'FOOD04', 'FIXED', 80, 200, NULL, '2026-01-01', '2026-12-31', 2, 1),
(5, 'FOOD05', 'PERCENTAGE', 10, 200, 150, '2026-01-01', '2026-12-31', 3, 1),
(6, 'FOOD06', 'FIXED', 40, 200, NULL, '2026-01-01', '2026-12-31', 1, 1),
(7, 'FOOD07', 'PERCENTAGE', 20, 200, 150, '2026-01-01', '2026-12-31', 2, 1),
(8, 'FOOD08', 'FIXED', 60, 200, NULL, '2026-01-01', '2026-12-31', 3, 1),
(9, 'FOOD09', 'PERCENTAGE', 30, 200, 150, '2026-01-01', '2026-12-31', 1, 1),
(10, 'FOOD10', 'FIXED', 80, 200, NULL, '2026-01-01', '2026-12-31', 2, 1),
(11, 'FOOD11', 'PERCENTAGE', 15, 200, 150, '2026-01-01', '2026-12-31', 3, 1),
(12, 'FOOD12', 'FIXED', 40, 200, NULL, '2026-01-01', '2026-12-31', 1, 1),
(13, 'FOOD13', 'PERCENTAGE', 25, 200, 150, '2026-01-01', '2026-12-31', 2, 1),
(14, 'FOOD14', 'FIXED', 60, 200, NULL, '2026-01-01', '2026-12-31', 3, 1),
(15, 'FOOD15', 'PERCENTAGE', 10, 200, 150, '2026-01-01', '2026-12-31', 1, 1),
(16, 'FOOD16', 'FIXED', 80, 200, NULL, '2026-01-01', '2026-12-31', 2, 1),
(17, 'FOOD17', 'PERCENTAGE', 20, 200, 150, '2026-01-01', '2026-12-31', 3, 1),
(18, 'FOOD18', 'FIXED', 40, 200, NULL, '2026-01-01', '2026-12-31', 1, 1),
(19, 'FOOD19', 'PERCENTAGE', 30, 200, 150, '2026-01-01', '2026-12-31', 2, 1),
(20, 'FOOD20', 'FIXED', 60, 200, NULL, '2026-01-01', '2026-12-31', 3, 1),
(21, 'FOOD21', 'PERCENTAGE', 15, 200, 150, '2026-01-01', '2026-12-31', 1, 1),
(22, 'FOOD22', 'FIXED', 80, 200, NULL, '2026-01-01', '2026-12-31', 2, 1),
(23, 'FOOD23', 'PERCENTAGE', 25, 200, 150, '2026-01-01', '2026-12-31', 3, 1),
(24, 'FOOD24', 'FIXED', 40, 200, NULL, '2026-01-01', '2026-12-31', 1, 1),
(25, 'FOOD25', 'PERCENTAGE', 10, 200, 150, '2026-01-01', '2026-12-31', 2, 1),
(26, 'FOOD26', 'FIXED', 60, 200, NULL, '2026-01-01', '2026-12-31', 3, 1),
(27, 'FOOD27', 'PERCENTAGE', 20, 200, 150, '2026-01-01', '2026-12-31', 1, 1),
(28, 'FOOD28', 'FIXED', 80, 200, NULL, '2026-01-01', '2026-12-31', 2, 1),
(29, 'FOOD29', 'PERCENTAGE', 30, 200, 150, '2026-01-01', '2026-12-31', 3, 1),
(30, 'FOOD30', 'FIXED', 40, 200, NULL, '2026-01-01', '2026-12-31', 1, 1);
 
INSERT INTO cart (cart_id, customer_id, restaurant_id, status, created_at, updated_at) VALUES
(1, 1, 1, 'CONVERTED', '2026-01-02 10:00:00', '2026-01-02 11:00:00'),
(2, 2, 2, 'CONVERTED', '2026-01-03 10:00:00', '2026-01-03 11:00:00'),
(3, 3, 3, 'CONVERTED', '2026-01-04 10:00:00', '2026-01-04 11:00:00'),
(4, 4, 4, 'CONVERTED', '2026-01-05 10:00:00', '2026-01-05 11:00:00'),
(5, 5, 5, 'CONVERTED', '2026-01-06 10:00:00', '2026-01-06 11:00:00'),
(6, 6, 6, 'CONVERTED', '2026-01-07 10:00:00', '2026-01-07 11:00:00'),
(7, 7, 7, 'CONVERTED', '2026-01-08 10:00:00', '2026-01-08 11:00:00'),
(8, 8, 8, 'CONVERTED', '2026-01-09 10:00:00', '2026-01-09 11:00:00'),
(9, 9, 9, 'CONVERTED', '2026-01-10 10:00:00', '2026-01-10 11:00:00'),
(10, 10, 10, 'CONVERTED', '2026-01-11 10:00:00', '2026-01-11 11:00:00'),
(11, 11, 11, 'CONVERTED', '2026-01-12 10:00:00', '2026-01-12 11:00:00'),
(12, 12, 12, 'CONVERTED', '2026-01-13 10:00:00', '2026-01-13 11:00:00'),
(13, 13, 13, 'CONVERTED', '2026-01-14 10:00:00', '2026-01-14 11:00:00'),
(14, 14, 14, 'CONVERTED', '2026-01-15 10:00:00', '2026-01-15 11:00:00'),
(15, 15, 15, 'CONVERTED', '2026-01-16 10:00:00', '2026-01-16 11:00:00'),
(16, 16, 16, 'ABANDONED', '2026-01-17 10:00:00', '2026-01-17 11:00:00'),
(17, 17, 17, 'ABANDONED', '2026-01-18 10:00:00', '2026-01-18 11:00:00'),
(18, 18, 18, 'ABANDONED', '2026-01-19 10:00:00', '2026-01-19 11:00:00'),
(19, 19, 19, 'ABANDONED', '2026-01-20 10:00:00', '2026-01-20 11:00:00'),
(20, 20, 20, 'ABANDONED', '2026-01-21 10:00:00', '2026-01-21 11:00:00'),
(21, 21, 21, 'ACTIVE', '2026-01-22 10:00:00', '2026-01-22 11:00:00'),
(22, 22, 22, 'ACTIVE', '2026-01-23 10:00:00', '2026-01-23 11:00:00'),
(23, 23, 23, 'ACTIVE', '2026-01-24 10:00:00', '2026-01-24 11:00:00'),
(24, 24, 24, 'ACTIVE', '2026-01-25 10:00:00', '2026-01-25 11:00:00'),
(25, 25, 25, 'ACTIVE', '2026-01-26 10:00:00', '2026-01-26 11:00:00'),
(26, 26, 26, 'ACTIVE', '2026-01-27 10:00:00', '2026-01-27 11:00:00'),
(27, 27, 27, 'ACTIVE', '2026-01-28 10:00:00', '2026-01-28 11:00:00'),
(28, 28, 28, 'ACTIVE', '2026-01-29 10:00:00', '2026-01-29 11:00:00'),
(29, 29, 29, 'ACTIVE', '2026-01-30 10:00:00', '2026-01-30 11:00:00'),
(30, 30, 30, 'ACTIVE', '2026-01-31 10:00:00', '2026-01-31 11:00:00');
 
INSERT INTO cart_item (cart_item_id, cart_id, menu_item_id, quantity, unit_price_snapshot, added_at) VALUES
(1, 1, 1, 2, 117, '2026-01-02 10:10:00'),
(2, 2, 2, 3, 134, '2026-01-03 10:10:00'),
(3, 3, 3, 1, 151, '2026-01-04 10:10:00'),
(4, 4, 4, 2, 168, '2026-01-05 10:10:00'),
(5, 5, 5, 3, 185, '2026-01-06 10:10:00'),
(6, 6, 6, 1, 202, '2026-01-07 10:10:00'),
(7, 7, 7, 2, 219, '2026-01-08 10:10:00'),
(8, 8, 8, 3, 236, '2026-01-09 10:10:00'),
(9, 9, 9, 1, 253, '2026-01-10 10:10:00'),
(10, 10, 10, 2, 270, '2026-01-11 10:10:00'),
(11, 11, 11, 3, 287, '2026-01-12 10:10:00'),
(12, 12, 12, 1, 304, '2026-01-13 10:10:00'),
(13, 13, 13, 2, 321, '2026-01-14 10:10:00'),
(14, 14, 14, 3, 338, '2026-01-15 10:10:00'),
(15, 15, 15, 1, 355, '2026-01-16 10:10:00'),
(16, 16, 16, 2, 372, '2026-01-17 10:10:00'),
(17, 17, 17, 3, 389, '2026-01-18 10:10:00'),
(18, 18, 18, 1, 406, '2026-01-19 10:10:00'),
(19, 19, 19, 2, 423, '2026-01-20 10:10:00'),
(20, 20, 20, 3, 440, '2026-01-21 10:10:00'),
(21, 21, 21, 1, 457, '2026-01-22 10:10:00'),
(22, 22, 22, 2, 474, '2026-01-23 10:10:00'),
(23, 23, 23, 3, 491, '2026-01-24 10:10:00'),
(24, 24, 24, 1, 508, '2026-01-25 10:10:00'),
(25, 25, 25, 2, 105, '2026-01-26 10:10:00'),
(26, 26, 26, 3, 122, '2026-01-27 10:10:00'),
(27, 27, 27, 1, 139, '2026-01-28 10:10:00'),
(28, 28, 28, 2, 156, '2026-01-29 10:10:00'),
(29, 29, 29, 3, 173, '2026-01-30 10:10:00'),
(30, 30, 30, 1, 190, '2026-01-31 10:10:00');
 
INSERT INTO orders (order_id, customer_id, restaurant_id, address_id, coupon_id, order_time, status, subtotal, delivery_charge, discount_amount, final_amount, estimated_delivery_at, cancellation_reason) VALUES
(1, 1, 1, 1, 1, '2026-01-02 10:00:00', 'DELIVERED', 234, 35.00, 25, 244.00, '2026-01-02 10:45:00', NULL),
(2, 2, 2, 2, 2, '2026-01-03 10:00:00', 'DELIVERED', 402, 35.00, 30, 407.00, '2026-01-03 10:45:00', NULL),
(3, 3, 3, 3, 3, '2026-01-04 10:00:00', 'DELIVERED', 151, 35.00, 35, 151.00, '2026-01-04 10:45:00', NULL),
(4, 4, 4, 4, 4, '2026-01-05 10:00:00', 'DELIVERED', 336, 35.00, 20, 351.00, '2026-01-05 10:45:00', NULL),
(5, 5, 5, 5, 5, '2026-01-06 10:00:00', 'DELIVERED', 555, 35.00, 25, 565.00, '2026-01-06 10:45:00', NULL),
(6, 6, 6, 6, 6, '2026-01-07 10:00:00', 'DELIVERED', 202, 35.00, 30, 207.00, '2026-01-07 10:45:00', NULL),
(7, 7, 7, 7, 7, '2026-01-08 10:00:00', 'DELIVERED', 438, 35.00, 35, 438.00, '2026-01-08 10:45:00', NULL),
(8, 8, 8, 8, 8, '2026-01-09 10:00:00', 'DELIVERED', 708, 35.00, 20, 723.00, '2026-01-09 10:45:00', NULL),
(9, 9, 9, 9, 9, '2026-01-10 10:00:00', 'DELIVERED', 253, 35.00, 25, 263.00, '2026-01-10 10:45:00', NULL),
(10, 10, 10, 10, 10, '2026-01-11 10:00:00', 'DELIVERED', 540, 35.00, 30, 545.00, '2026-01-11 10:45:00', NULL),
(11, 11, 11, 11, 11, '2026-01-12 10:00:00', 'DELIVERED', 861, 35.00, 35, 861.00, '2026-01-12 10:45:00', NULL),
(12, 12, 12, 12, 12, '2026-01-13 10:00:00', 'DELIVERED', 304, 35.00, 20, 319.00, '2026-01-13 10:45:00', NULL),
(13, 13, 13, 13, 13, '2026-01-14 10:00:00', 'DELIVERED', 642, 35.00, 25, 652.00, '2026-01-14 10:45:00', NULL),
(14, 14, 14, 14, 14, '2026-01-15 10:00:00', 'DELIVERED', 1014, 35.00, 30, 1019.00, '2026-01-15 10:45:00', NULL),
(15, 15, 15, 15, 15, '2026-01-16 10:00:00', 'DELIVERED', 355, 35.00, 35, 355.00, '2026-01-16 10:45:00', NULL),
(16, 16, 16, 16, NULL, '2026-01-17 10:00:00', 'DELIVERED', 744, 35.00, 0, 779.00, '2026-01-17 10:45:00', NULL),
(17, 17, 17, 17, NULL, '2026-01-18 10:00:00', 'DELIVERED', 1167, 35.00, 0, 1202.00, '2026-01-18 10:45:00', NULL),
(18, 18, 18, 18, NULL, '2026-01-19 10:00:00', 'DELIVERED', 406, 35.00, 0, 441.00, '2026-01-19 10:45:00', NULL),
(19, 19, 19, 19, NULL, '2026-01-20 10:00:00', 'DELIVERED', 846, 35.00, 0, 881.00, '2026-01-20 10:45:00', NULL),
(20, 20, 20, 20, NULL, '2026-01-21 10:00:00', 'DELIVERED', 1320, 35.00, 0, 1355.00, '2026-01-21 10:45:00', NULL),
(21, 1, 21, 1, NULL, '2026-01-22 10:00:00', 'DELIVERED', 457, 35.00, 0, 492.00, '2026-01-22 10:45:00', NULL),
(22, 2, 22, 2, NULL, '2026-01-23 10:00:00', 'DELIVERED', 948, 35.00, 0, 983.00, '2026-01-23 10:45:00', NULL),
(23, 3, 23, 3, NULL, '2026-01-24 10:00:00', 'DELIVERED', 1473, 35.00, 0, 1508.00, '2026-01-24 10:45:00', NULL),
(24, 4, 24, 4, NULL, '2026-01-25 10:00:00', 'DELIVERED', 508, 35.00, 0, 543.00, '2026-01-25 10:45:00', NULL),
(25, 5, 25, 5, NULL, '2026-01-26 10:00:00', 'CANCELLED', 210, 35.00, 0, 245.00, '2026-01-26 10:45:00', 'Customer requested cancellation'),
(26, 6, 1, 6, NULL, '2026-01-27 10:00:00', 'CANCELLED', 351, 35.00, 0, 386.00, '2026-01-27 10:45:00', 'Customer requested cancellation'),
(27, 7, 2, 7, NULL, '2026-01-28 10:00:00', 'CANCELLED', 134, 35.00, 0, 169.00, '2026-01-28 10:45:00', 'Customer requested cancellation'),
(28, 8, 3, 8, NULL, '2026-01-29 10:00:00', 'OUT_FOR_DELIVERY', 302, 35.00, 0, 337.00, '2026-01-29 10:45:00', NULL),
(29, 9, 4, 9, NULL, '2026-01-30 10:00:00', 'OUT_FOR_DELIVERY', 504, 35.00, 0, 539.00, '2026-01-30 10:45:00', NULL),
(30, 10, 5, 10, NULL, '2026-01-31 10:00:00', 'OUT_FOR_DELIVERY', 185, 35.00, 0, 220.00, '2026-01-31 10:45:00', NULL);
 
INSERT INTO order_item (order_item_id, order_id, menu_item_id, item_name_snapshot, quantity, unit_price) VALUES
(1, 1, 1, 'South Indian Special', 2, 117),
(2, 2, 2, 'North Indian Special', 3, 134),
(3, 3, 3, 'Chinese Special', 1, 151),
(4, 4, 4, 'Fast Food Special', 2, 168),
(5, 5, 5, 'Desserts Special', 3, 185),
(6, 6, 6, 'Beverages Special', 1, 202),
(7, 7, 7, 'Biryani Special', 2, 219),
(8, 8, 8, 'Seafood Special', 3, 236),
(9, 9, 9, 'Continental Special', 1, 253),
(10, 10, 10, 'Italian Special', 2, 270),
(11, 11, 11, 'Mexican Special', 3, 287),
(12, 12, 12, 'Thai Special', 1, 304),
(13, 13, 13, 'Bakery Special', 2, 321),
(14, 14, 14, 'Salads Special', 3, 338),
(15, 15, 15, 'Soups Special', 1, 355),
(16, 16, 16, 'Street Food Special', 2, 372),
(17, 17, 17, 'Healthy Special', 3, 389),
(18, 18, 18, 'Vegan Special', 1, 406),
(19, 19, 19, 'Breakfast Special', 2, 423),
(20, 20, 20, 'Rice Bowls Special', 3, 440),
(21, 21, 21, 'Kebabs Special', 1, 457),
(22, 22, 22, 'Punjabi Special', 2, 474),
(23, 23, 23, 'Andhra Special', 3, 491),
(24, 24, 24, 'Hyderabadi Special', 1, 508),
(25, 25, 25, 'Ice Cream Special', 2, 105),
(26, 26, 1, 'South Indian Special', 3, 117),
(27, 27, 2, 'North Indian Special', 1, 134),
(28, 28, 3, 'Chinese Special', 2, 151),
(29, 29, 4, 'Fast Food Special', 3, 168),
(30, 30, 5, 'Desserts Special', 1, 185);
 
INSERT INTO payment (payment_id, order_id, payment_method, transaction_ref, amount, payment_status, paid_at, created_at) VALUES
(1, 1, 'UPI', 'TXN20260001', 244.00, 'SUCCESS', '2026-01-02 10:02:00', '2026-01-02 10:01:00'),
(2, 2, 'CREDIT_CARD', 'TXN20260002', 407.00, 'SUCCESS', '2026-01-03 10:02:00', '2026-01-03 10:01:00'),
(3, 3, 'DEBIT_CARD', 'TXN20260003', 151.00, 'SUCCESS', '2026-01-04 10:02:00', '2026-01-04 10:01:00'),
(4, 4, 'COD', NULL, 351.00, 'SUCCESS', '2026-01-05 10:02:00', '2026-01-05 10:01:00'),
(5, 5, 'UPI', 'TXN20260005', 565.00, 'SUCCESS', '2026-01-06 10:02:00', '2026-01-06 10:01:00'),
(6, 6, 'CREDIT_CARD', 'TXN20260006', 207.00, 'SUCCESS', '2026-01-07 10:02:00', '2026-01-07 10:01:00'),
(7, 7, 'DEBIT_CARD', 'TXN20260007', 438.00, 'SUCCESS', '2026-01-08 10:02:00', '2026-01-08 10:01:00'),
(8, 8, 'COD', NULL, 723.00, 'SUCCESS', '2026-01-09 10:02:00', '2026-01-09 10:01:00'),
(9, 9, 'UPI', 'TXN20260009', 263.00, 'SUCCESS', '2026-01-10 10:02:00', '2026-01-10 10:01:00'),
(10, 10, 'CREDIT_CARD', 'TXN20260010', 545.00, 'SUCCESS', '2026-01-11 10:02:00', '2026-01-11 10:01:00'),
(11, 11, 'DEBIT_CARD', 'TXN20260011', 861.00, 'SUCCESS', '2026-01-12 10:02:00', '2026-01-12 10:01:00'),
(12, 12, 'COD', NULL, 319.00, 'SUCCESS', '2026-01-13 10:02:00', '2026-01-13 10:01:00'),
(13, 13, 'UPI', 'TXN20260013', 652.00, 'SUCCESS', '2026-01-14 10:02:00', '2026-01-14 10:01:00'),
(14, 14, 'CREDIT_CARD', 'TXN20260014', 1019.00, 'SUCCESS', '2026-01-15 10:02:00', '2026-01-15 10:01:00'),
(15, 15, 'DEBIT_CARD', 'TXN20260015', 355.00, 'SUCCESS', '2026-01-16 10:02:00', '2026-01-16 10:01:00'),
(16, 16, 'COD', NULL, 779.00, 'SUCCESS', '2026-01-17 10:02:00', '2026-01-17 10:01:00'),
(17, 17, 'UPI', 'TXN20260017', 1202.00, 'SUCCESS', '2026-01-18 10:02:00', '2026-01-18 10:01:00'),
(18, 18, 'CREDIT_CARD', 'TXN20260018', 441.00, 'SUCCESS', '2026-01-19 10:02:00', '2026-01-19 10:01:00'),
(19, 19, 'DEBIT_CARD', 'TXN20260019', 881.00, 'SUCCESS', '2026-01-20 10:02:00', '2026-01-20 10:01:00'),
(20, 20, 'COD', NULL, 1355.00, 'SUCCESS', '2026-01-21 10:02:00', '2026-01-21 10:01:00'),
(21, 21, 'UPI', 'TXN20260021', 492.00, 'SUCCESS', '2026-01-22 10:02:00', '2026-01-22 10:01:00'),
(22, 22, 'CREDIT_CARD', 'TXN20260022', 983.00, 'SUCCESS', '2026-01-23 10:02:00', '2026-01-23 10:01:00'),
(23, 23, 'DEBIT_CARD', 'TXN20260023', 1508.00, 'SUCCESS', '2026-01-24 10:02:00', '2026-01-24 10:01:00'),
(24, 24, 'COD', NULL, 543.00, 'SUCCESS', '2026-01-25 10:02:00', '2026-01-25 10:01:00'),
(25, 25, 'UPI', 'TXN20260025', 245.00, 'REFUNDED', '2026-01-26 10:02:00', '2026-01-26 10:01:00'),
(26, 26, 'CREDIT_CARD', 'TXN20260026', 386.00, 'REFUNDED', '2026-01-27 10:02:00', '2026-01-27 10:01:00'),
(27, 27, 'DEBIT_CARD', 'TXN20260027', 169.00, 'REFUNDED', '2026-01-28 10:02:00', '2026-01-28 10:01:00'),
(28, 28, 'COD', NULL, 337.00, 'SUCCESS', '2026-01-29 10:02:00', '2026-01-29 10:01:00'),
(29, 29, 'UPI', 'TXN20260029', 539.00, 'SUCCESS', '2026-01-30 10:02:00', '2026-01-30 10:01:00'),
(30, 30, 'CREDIT_CARD', 'TXN20260030', 220.00, 'SUCCESS', '2026-01-31 10:02:00', '2026-01-31 10:01:00');
 
INSERT INTO delivery_partner (partner_id, full_name, mobile, vehicle_number, vehicle_type, availability_status, joined_at) VALUES
(1, 'Delivery Partner 01', '7000000001', 'TS09AB0001', 'SCOOTER', 'BUSY', '2025-01-02'),
(2, 'Delivery Partner 02', '7000000002', 'TS09AB0002', 'BICYCLE', 'OFFLINE', '2025-01-03'),
(3, 'Delivery Partner 03', '7000000003', 'TS09AB0003', 'BIKE', 'AVAILABLE', '2025-01-04'),
(4, 'Delivery Partner 04', '7000000004', 'TS09AB0004', 'SCOOTER', 'BUSY', '2025-01-05'),
(5, 'Delivery Partner 05', '7000000005', 'TS09AB0005', 'BICYCLE', 'OFFLINE', '2025-01-06'),
(6, 'Delivery Partner 06', '7000000006', 'TS09AB0006', 'BIKE', 'AVAILABLE', '2025-01-07'),
(7, 'Delivery Partner 07', '7000000007', 'TS09AB0007', 'SCOOTER', 'BUSY', '2025-01-08'),
(8, 'Delivery Partner 08', '7000000008', 'TS09AB0008', 'BICYCLE', 'OFFLINE', '2025-01-09'),
(9, 'Delivery Partner 09', '7000000009', 'TS09AB0009', 'BIKE', 'AVAILABLE', '2025-01-10'),
(10, 'Delivery Partner 10', '7000000010', 'TS09AB0010', 'SCOOTER', 'BUSY', '2025-01-11'),
(11, 'Delivery Partner 11', '7000000011', 'TS09AB0011', 'BICYCLE', 'OFFLINE', '2025-01-12'),
(12, 'Delivery Partner 12', '7000000012', 'TS09AB0012', 'BIKE', 'AVAILABLE', '2025-01-13'),
(13, 'Delivery Partner 13', '7000000013', 'TS09AB0013', 'SCOOTER', 'BUSY', '2025-01-14'),
(14, 'Delivery Partner 14', '7000000014', 'TS09AB0014', 'BICYCLE', 'OFFLINE', '2025-01-15'),
(15, 'Delivery Partner 15', '7000000015', 'TS09AB0015', 'BIKE', 'AVAILABLE', '2025-01-16'),
(16, 'Delivery Partner 16', '7000000016', 'TS09AB0016', 'SCOOTER', 'BUSY', '2025-01-17'),
(17, 'Delivery Partner 17', '7000000017', 'TS09AB0017', 'BICYCLE', 'OFFLINE', '2025-01-18'),
(18, 'Delivery Partner 18', '7000000018', 'TS09AB0018', 'BIKE', 'AVAILABLE', '2025-01-19'),
(19, 'Delivery Partner 19', '7000000019', 'TS09AB0019', 'SCOOTER', 'BUSY', '2025-01-20'),
(20, 'Delivery Partner 20', '7000000020', 'TS09AB0020', 'BICYCLE', 'OFFLINE', '2025-01-21'),
(21, 'Delivery Partner 21', '7000000021', 'TS09AB0021', 'BIKE', 'AVAILABLE', '2025-01-22'),
(22, 'Delivery Partner 22', '7000000022', 'TS09AB0022', 'SCOOTER', 'BUSY', '2025-01-23'),
(23, 'Delivery Partner 23', '7000000023', 'TS09AB0023', 'BICYCLE', 'OFFLINE', '2025-01-24'),
(24, 'Delivery Partner 24', '7000000024', 'TS09AB0024', 'BIKE', 'AVAILABLE', '2025-01-25'),
(25, 'Delivery Partner 25', '7000000025', 'TS09AB0025', 'SCOOTER', 'BUSY', '2025-01-26'),
(26, 'Delivery Partner 26', '7000000026', 'TS09AB0026', 'BICYCLE', 'OFFLINE', '2025-01-27'),
(27, 'Delivery Partner 27', '7000000027', 'TS09AB0027', 'BIKE', 'AVAILABLE', '2025-01-28'),
(28, 'Delivery Partner 28', '7000000028', 'TS09AB0028', 'SCOOTER', 'BUSY', '2025-01-29'),
(29, 'Delivery Partner 29', '7000000029', 'TS09AB0029', 'BICYCLE', 'OFFLINE', '2025-01-30'),
(30, 'Delivery Partner 30', '7000000030', 'TS09AB0030', 'BIKE', 'AVAILABLE', '2025-01-31');
 
INSERT INTO delivery (delivery_id, order_id, partner_id, assignment_status, assigned_at, accepted_at, pickup_at, delivered_at, delivery_status) VALUES
(1, 1, 1, 'COMPLETED', '2026-01-02 10:20:00', '2026-01-02 10:22:00', '2026-01-02 10:35:00', '2026-01-02 10:55:00', 'DELIVERED'),
(2, 2, 2, 'COMPLETED', '2026-01-03 10:20:00', '2026-01-03 10:22:00', '2026-01-03 10:35:00', '2026-01-03 10:55:00', 'DELIVERED'),
(3, 3, 3, 'COMPLETED', '2026-01-04 10:20:00', '2026-01-04 10:22:00', '2026-01-04 10:35:00', '2026-01-04 10:55:00', 'DELIVERED'),
(4, 4, 4, 'COMPLETED', '2026-01-05 10:20:00', '2026-01-05 10:22:00', '2026-01-05 10:35:00', '2026-01-05 10:55:00', 'DELIVERED'),
(5, 5, 5, 'COMPLETED', '2026-01-06 10:20:00', '2026-01-06 10:22:00', '2026-01-06 10:35:00', '2026-01-06 10:55:00', 'DELIVERED'),
(6, 6, 6, 'COMPLETED', '2026-01-07 10:20:00', '2026-01-07 10:22:00', '2026-01-07 10:35:00', '2026-01-07 10:55:00', 'DELIVERED'),
(7, 7, 7, 'COMPLETED', '2026-01-08 10:20:00', '2026-01-08 10:22:00', '2026-01-08 10:35:00', '2026-01-08 10:55:00', 'DELIVERED'),
(8, 8, 8, 'COMPLETED', '2026-01-09 10:20:00', '2026-01-09 10:22:00', '2026-01-09 10:35:00', '2026-01-09 10:55:00', 'DELIVERED'),
(9, 9, 9, 'COMPLETED', '2026-01-10 10:20:00', '2026-01-10 10:22:00', '2026-01-10 10:35:00', '2026-01-10 10:55:00', 'DELIVERED'),
(10, 10, 10, 'COMPLETED', '2026-01-11 10:20:00', '2026-01-11 10:22:00', '2026-01-11 10:35:00', '2026-01-11 10:55:00', 'DELIVERED'),
(11, 11, 1, 'COMPLETED', '2026-01-12 10:20:00', '2026-01-12 10:22:00', '2026-01-12 10:35:00', '2026-01-12 10:55:00', 'DELIVERED'),
(12, 12, 2, 'COMPLETED', '2026-01-13 10:20:00', '2026-01-13 10:22:00', '2026-01-13 10:35:00', '2026-01-13 10:55:00', 'DELIVERED'),
(13, 13, 3, 'COMPLETED', '2026-01-14 10:20:00', '2026-01-14 10:22:00', '2026-01-14 10:35:00', '2026-01-14 10:55:00', 'DELIVERED'),
(14, 14, 4, 'COMPLETED', '2026-01-15 10:20:00', '2026-01-15 10:22:00', '2026-01-15 10:35:00', '2026-01-15 10:55:00', 'DELIVERED'),
(15, 15, 5, 'COMPLETED', '2026-01-16 10:20:00', '2026-01-16 10:22:00', '2026-01-16 10:35:00', '2026-01-16 10:55:00', 'DELIVERED'),
(16, 16, 6, 'COMPLETED', '2026-01-17 10:20:00', '2026-01-17 10:22:00', '2026-01-17 10:35:00', '2026-01-17 10:55:00', 'DELIVERED'),
(17, 17, 7, 'COMPLETED', '2026-01-18 10:20:00', '2026-01-18 10:22:00', '2026-01-18 10:35:00', '2026-01-18 10:55:00', 'DELIVERED'),
(18, 18, 8, 'COMPLETED', '2026-01-19 10:20:00', '2026-01-19 10:22:00', '2026-01-19 10:35:00', '2026-01-19 10:55:00', 'DELIVERED'),
(19, 19, 9, 'COMPLETED', '2026-01-20 10:20:00', '2026-01-20 10:22:00', '2026-01-20 10:35:00', '2026-01-20 10:55:00', 'DELIVERED'),
(20, 20, 10, 'COMPLETED', '2026-01-21 10:20:00', '2026-01-21 10:22:00', '2026-01-21 10:35:00', '2026-01-21 10:55:00', 'DELIVERED'),
(21, 21, 1, 'COMPLETED', '2026-01-22 10:20:00', '2026-01-22 10:22:00', '2026-01-22 10:35:00', '2026-01-22 10:55:00', 'DELIVERED'),
(22, 22, 2, 'COMPLETED', '2026-01-23 10:20:00', '2026-01-23 10:22:00', '2026-01-23 10:35:00', '2026-01-23 10:55:00', 'DELIVERED'),
(23, 23, 3, 'COMPLETED', '2026-01-24 10:20:00', '2026-01-24 10:22:00', '2026-01-24 10:35:00', '2026-01-24 10:55:00', 'DELIVERED'),
(24, 24, 4, 'COMPLETED', '2026-01-25 10:20:00', '2026-01-25 10:22:00', '2026-01-25 10:35:00', '2026-01-25 10:55:00', 'DELIVERED'),
(25, 25, 5, 'CANCELLED', '2026-01-26 10:20:00', NULL, NULL, NULL, 'CANCELLED'),
(26, 26, 6, 'CANCELLED', '2026-01-27 10:20:00', NULL, NULL, NULL, 'CANCELLED'),
(27, 27, 7, 'CANCELLED', '2026-01-28 10:20:00', NULL, NULL, NULL, 'CANCELLED'),
(28, 28, 8, 'ACCEPTED', '2026-01-29 10:20:00', '2026-01-29 10:22:00', '2026-01-29 10:35:00', NULL, 'IN_TRANSIT'),
(29, 29, 9, 'ACCEPTED', '2026-01-30 10:20:00', '2026-01-30 10:22:00', '2026-01-30 10:35:00', NULL, 'IN_TRANSIT'),
(30, 30, 10, 'ACCEPTED', '2026-01-31 10:20:00', '2026-01-31 10:22:00', '2026-01-31 10:35:00', NULL, 'IN_TRANSIT');
 
INSERT INTO order_status_history (history_id, order_id, status, changed_at, changed_by_type, remarks) VALUES
(1, 1, 'DELIVERED', '2026-01-02 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(2, 2, 'DELIVERED', '2026-01-03 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(3, 3, 'DELIVERED', '2026-01-04 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(4, 4, 'DELIVERED', '2026-01-05 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(5, 5, 'DELIVERED', '2026-01-06 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(6, 6, 'DELIVERED', '2026-01-07 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(7, 7, 'DELIVERED', '2026-01-08 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(8, 8, 'DELIVERED', '2026-01-09 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(9, 9, 'DELIVERED', '2026-01-10 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(10, 10, 'DELIVERED', '2026-01-11 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(11, 11, 'DELIVERED', '2026-01-12 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(12, 12, 'DELIVERED', '2026-01-13 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(13, 13, 'DELIVERED', '2026-01-14 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(14, 14, 'DELIVERED', '2026-01-15 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(15, 15, 'DELIVERED', '2026-01-16 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(16, 16, 'DELIVERED', '2026-01-17 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(17, 17, 'DELIVERED', '2026-01-18 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(18, 18, 'DELIVERED', '2026-01-19 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(19, 19, 'DELIVERED', '2026-01-20 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(20, 20, 'DELIVERED', '2026-01-21 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(21, 21, 'DELIVERED', '2026-01-22 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(22, 22, 'DELIVERED', '2026-01-23 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(23, 23, 'DELIVERED', '2026-01-24 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(24, 24, 'DELIVERED', '2026-01-25 10:05:00', 'SYSTEM', 'Current status recorded as DELIVERED'),
(25, 25, 'CANCELLED', '2026-01-26 10:05:00', 'SYSTEM', 'Current status recorded as CANCELLED'),
(26, 26, 'CANCELLED', '2026-01-27 10:05:00', 'SYSTEM', 'Current status recorded as CANCELLED'),
(27, 27, 'CANCELLED', '2026-01-28 10:05:00', 'SYSTEM', 'Current status recorded as CANCELLED'),
(28, 28, 'OUT_FOR_DELIVERY', '2026-01-29 10:05:00', 'SYSTEM', 'Current status recorded as OUT_FOR_DELIVERY'),
(29, 29, 'OUT_FOR_DELIVERY', '2026-01-30 10:05:00', 'SYSTEM', 'Current status recorded as OUT_FOR_DELIVERY'),
(30, 30, 'OUT_FOR_DELIVERY', '2026-01-31 10:05:00', 'SYSTEM', 'Current status recorded as OUT_FOR_DELIVERY');
 
INSERT INTO review (review_id, customer_id, order_id, restaurant_id, menu_item_id, rating, comments, reviewed_at) VALUES 

(1, 1, 1, 1, 1, 2, 'Verified review sample 01', '2026-01-03 10:00:00'), 

(2, 2, 2, 2, 2, 3, 'Verified review sample 02', '2026-01-04 10:00:00'), 

(3, 3, 3, 3, 3, 4, 'Verified review sample 03', '2026-01-05 10:00:00'), 

(4, 4, 4, 4, 4, 5, 'Verified review sample 04', '2026-01-06 10:00:00'), 

(5, 5, 5, 5, 5, 1, 'Verified review sample 05', '2026-01-07 10:00:00'), 

(6, 6, 6, 6, 6, 2, 'Verified review sample 06', '2026-01-08 10:00:00'), 

(7, 7, 7, 7, 7, 3, 'Verified review sample 07', '2026-01-09 10:00:00'), 

(8, 8, 8, 8, 8, 4, 'Verified review sample 08', '2026-01-10 10:00:00'), 

(9, 9, 9, 9, 9, 5, 'Verified review sample 09', '2026-01-11 10:00:00'), 

(10, 10, 10, 10, 10, 1, 'Verified review sample 10', '2026-01-12 10:00:00'), 

(11, 11, 11, 11, 11, 2, 'Verified review sample 11', '2026-01-13 10:00:00'), 

(12, 12, 12, 12, 12, 3, 'Verified review sample 12', '2026-01-14 10:00:00'), 

(13, 13, 13, 13, 13, 4, 'Verified review sample 13', '2026-01-15 10:00:00'), 

(14, 14, 14, 14, 14, 5, 'Verified review sample 14', '2026-01-16 10:00:00'), 

(15, 15, 15, 15, 15, 1, 'Verified review sample 15', '2026-01-17 10:00:00'), 

(16, 16, 16, 16, 16, 2, 'Verified review sample 16', '2026-01-18 10:00:00'), 

(17, 17, 17, 17, 17, 3, 'Verified review sample 17', '2026-01-19 10:00:00'), 

(18, 18, 18, 18, 18, 4, 'Verified review sample 18', '2026-01-20 10:00:00'), 

(19, 19, 19, 19, 19, 5, 'Verified review sample 19', '2026-01-21 10:00:00'), 

(20, 20, 20, 20, 20, 1, 'Verified review sample 20', '2026-01-22 10:00:00'), 

(21, 1, 21, 21, 21, 2, 'Verified review sample 21', '2026-01-23 10:00:00'), 

(22, 2, 22, 22, 22, 3, 'Verified review sample 22', '2026-01-24 10:00:00'), 

(23, 3, 23, 23, 23, 4, 'Verified review sample 23', '2026-01-25 10:00:00'), 

(24, 4, 24, 24, 24, 5, 'Verified review sample 24', '2026-01-26 10:00:00'), 

(25, 1, 1, 1, NULL, 1, 'Verified review sample 25', '2026-01-03 10:00:00'), 

(26, 2, 2, 2, NULL, 2, 'Verified review sample 26', '2026-01-04 10:00:00'), 

(27, 3, 3, 3, NULL, 3, 'Verified review sample 27', '2026-01-05 10:00:00'), 

(28, 4, 4, 4, NULL, 4, 'Verified review sample 28', '2026-01-06 10:00:00'), 

(29, 5, 5, 5, NULL, 5, 'Verified review sample 29', '2026-01-07 10:00:00'), 

(30, 6, 6, 6, NULL, 1, 'Verified review sample 30', '2026-01-08 10:00:00'); 
 
INSERT INTO coupon_redemption (redemption_id, coupon_id, customer_id, order_id, discount_amount, redeemed_at) VALUES
(1, 1, 1, 1, 25, '2026-01-02 10:00:00'),
(2, 2, 2, 2, 30, '2026-01-03 10:00:00'),
(3, 3, 3, 3, 35, '2026-01-04 10:00:00'),
(4, 4, 4, 4, 20, '2026-01-05 10:00:00'),
(5, 5, 5, 5, 25, '2026-01-06 10:00:00'),
(6, 6, 6, 6, 30, '2026-01-07 10:00:00'),
(7, 7, 7, 7, 35, '2026-01-08 10:00:00'),
(8, 8, 8, 8, 20, '2026-01-09 10:00:00'),
(9, 9, 9, 9, 25, '2026-01-10 10:00:00'),
(10, 10, 10, 10, 30, '2026-01-11 10:00:00'),
(11, 11, 11, 11, 35, '2026-01-12 10:00:00'),
(12, 12, 12, 12, 20, '2026-01-13 10:00:00'),
(13, 13, 13, 13, 25, '2026-01-14 10:00:00'),
(14, 14, 14, 14, 30, '2026-01-15 10:00:00'),
(15, 15, 15, 15, 35, '2026-01-16 10:00:00'),
(16, 1, 16, 16, 20, '2026-01-17 10:00:00'),
(17, 2, 17, 17, 25, '2026-01-18 10:00:00'),
(18, 3, 18, 18, 30, '2026-01-19 10:00:00'),
(19, 4, 19, 19, 35, '2026-01-20 10:00:00'),
(20, 5, 20, 20, 20, '2026-01-21 10:00:00'),
(21, 6, 1, 21, 25, '2026-01-22 10:00:00'),
(22, 7, 2, 22, 30, '2026-01-23 10:00:00'),
(23, 8, 3, 23, 35, '2026-01-24 10:00:00'),
(24, 9, 4, 24, 20, '2026-01-25 10:00:00'),
(25, 10, 5, 25, 25, '2026-01-26 10:00:00'),
(26, 11, 6, 26, 30, '2026-01-27 10:00:00'),
(27, 12, 7, 27, 35, '2026-01-28 10:00:00'),
(28, 13, 8, 28, 20, '2026-01-29 10:00:00'),
(29, 14, 9, 29, 25, '2026-01-30 10:00:00'),
(30, 15, 10, 30, 30, '2026-01-31 10:00:00');
 
INSERT INTO refund (refund_id, payment_id, order_id, refund_reference, refund_amount, refund_status, reason, initiated_at, processed_at) VALUES
(1, 1, 1, 'RFN20260001', 51.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-04 10:00:00', NULL),
(2, 2, 2, 'RFN20260002', 52.00, 'FAILED', 'Adjustment or cancellation refund', '2026-01-05 10:00:00', NULL),
(3, 3, 3, 'RFN20260003', 53.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-01-06 10:00:00', '2026-01-06 12:00:00'),
(4, 4, 4, 'RFN20260004', 54.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-07 10:00:00', NULL),
(5, 5, 5, 'RFN20260005', 55.00, 'FAILED', 'Adjustment or cancellation refund', '2026-01-08 10:00:00', NULL),
(6, 6, 6, 'RFN20260006', 56.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-01-09 10:00:00', '2026-01-09 12:00:00'),
(7, 7, 7, 'RFN20260007', 57.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-10 10:00:00', NULL),
(8, 8, 8, 'RFN20260008', 58.00, 'FAILED', 'Adjustment or cancellation refund', '2026-01-11 10:00:00', NULL),
(9, 9, 9, 'RFN20260009', 59.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-01-12 10:00:00', '2026-01-12 12:00:00'),
(10, 10, 10, 'RFN20260010', 60.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-13 10:00:00', NULL),
(11, 11, 11, 'RFN20260011', 61.00, 'FAILED', 'Adjustment or cancellation refund', '2026-01-14 10:00:00', NULL),
(12, 12, 12, 'RFN20260012', 62.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-01-15 10:00:00', '2026-01-15 12:00:00'),
(13, 13, 13, 'RFN20260013', 63.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-16 10:00:00', NULL),
(14, 14, 14, 'RFN20260014', 64.00, 'FAILED', 'Adjustment or cancellation refund', '2026-01-17 10:00:00', NULL),
(15, 15, 15, 'RFN20260015', 65.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-01-18 10:00:00', '2026-01-18 12:00:00'),
(16, 16, 16, 'RFN20260016', 66.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-19 10:00:00', NULL),
(17, 17, 17, 'RFN20260017', 67.00, 'FAILED', 'Adjustment or cancellation refund', '2026-01-20 10:00:00', NULL),
(18, 18, 18, 'RFN20260018', 68.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-01-21 10:00:00', '2026-01-21 12:00:00'),
(19, 19, 19, 'RFN20260019', 69.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-22 10:00:00', NULL),
(20, 20, 20, 'RFN20260020', 70.00, 'FAILED', 'Adjustment or cancellation refund', '2026-01-23 10:00:00', NULL),
(21, 21, 21, 'RFN20260021', 71.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-01-24 10:00:00', '2026-01-24 12:00:00'),
(22, 22, 22, 'RFN20260022', 72.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-25 10:00:00', NULL),
(23, 23, 23, 'RFN20260023', 73.00, 'FAILED', 'Adjustment or cancellation refund', '2026-01-26 10:00:00', NULL),
(24, 24, 24, 'RFN20260024', 74.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-01-27 10:00:00', '2026-01-27 12:00:00'),
(25, 25, 25, 'RFN20260025', 75.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-28 10:00:00', NULL),
(26, 26, 26, 'RFN20260026', 76.00, 'FAILED', 'Adjustment or cancellation refund', '2026-01-29 10:00:00', NULL),
(27, 27, 27, 'RFN20260027', 77.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-01-30 10:00:00', '2026-01-30 12:00:00'),
(28, 28, 28, 'RFN20260028', 78.00, 'INITIATED', 'Adjustment or cancellation refund', '2026-01-31 10:00:00', NULL),
(29, 29, 29, 'RFN20260029', 79.00, 'FAILED', 'Adjustment or cancellation refund', '2026-02-01 10:00:00', NULL),
(30, 30, 30, 'RFN20260030', 80.00, 'PROCESSED', 'Adjustment or cancellation refund', '2026-02-02 10:00:00', '2026-02-02 12:00:00');




************************************************************************************************************************************************************

-- 1. All registered customers

SELECT customer_id, full_name, email, mobile, status, created_at FROM customer ORDER BY customer_id;

-- 2. All active restaurants

SELECT restaurant_id, name, city, opens_at, closes_at, average_rating FROM restaurant WHERE is_active = TRUE ORDER BY name;

-- 3. All vegetarian food items

SELECT menu_item_id, item_name, price FROM menu_item WHERE is_vegetarian = TRUE ORDER BY item_name;

-- 4. Items for a particular restaurant

SET @restaurant_id = 1;
SELECT menu_item_id, item_name, price, is_available FROM menu_item WHERE restaurant_id = @restaurant_id ORDER BY item_name;

-- 5. Food items priced above ₹200

SELECT menu_item_id, item_name, price FROM menu_item WHERE price > 200 ORDER BY price DESC;

-- 6. Orders for a particular customer

SET @customer_id = 1;
SELECT order_id, order_time, status, final_amount FROM orders WHERE customer_id = @customer_id ORDER BY order_time DESC;

-- 7. Orders on a particular date

SET @order_date = '2026-01-10';
SELECT * FROM orders WHERE order_time >= @order_date AND order_time < DATE_ADD(@order_date, INTERVAL 1 DAY);

-- 8. Available delivery partners

SELECT partner_id, full_name, mobile, vehicle_number FROM delivery_partner WHERE availability_status = 'AVAILABLE' ORDER BY full_name;

-- 9. Customers with delivery addresses

SELECT c.customer_id, c.full_name, a.address_id, a.label, a.line1, a.city, a.postal_code, a.is_default FROM customer c LEFT JOIN customer_address a ON a.customer_id = c.customer_id ORDER BY c.customer_id, a.is_default DESC;

-- 10. Restaurants with their menu

SELECT r.restaurant_id, r.name AS restaurant_name, m.menu_item_id, m.item_name, m.price, m.is_available FROM restaurant r LEFT JOIN menu_item m ON m.restaurant_id = r.restaurant_id ORDER BY r.name, m.item_name;

-- 11. Complete order header details

SELECT o.order_id, o.order_time, o.status, c.full_name AS customer_name, r.name AS restaurant_name, a.line1, a.city, o.subtotal, o.delivery_charge, o.discount_amount, o.final_amount FROM orders o JOIN customer c ON c.customer_id=o.customer_id JOIN restaurant r ON r.restaurant_id=o.restaurant_id JOIN customer_address a ON a.address_id=o.address_id ORDER BY o.order_time DESC;

-- 12. Number of orders by customer

SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS order_count FROM customer c LEFT JOIN orders o ON o.customer_id=c.customer_id GROUP BY c.customer_id,c.full_name ORDER BY order_count DESC,c.customer_id;

-- 13. Available item count by restaurant

SELECT r.restaurant_id, r.name, SUM(CASE WHEN m.is_available THEN 1 ELSE 0 END) AS available_item_count FROM restaurant r LEFT JOIN menu_item m ON m.restaurant_id=r.restaurant_id GROUP BY r.restaurant_id,r.name ORDER BY available_item_count DESC;

-- 14. Sales generated by restaurant

SELECT r.restaurant_id, r.name, COALESCE(SUM(CASE WHEN o.status='DELIVERED' THEN o.final_amount ELSE 0 END),0) AS total_sales FROM restaurant r LEFT JOIN orders o ON o.restaurant_id=r.restaurant_id GROUP BY r.restaurant_id,r.name ORDER BY total_sales DESC;

-- 15. Most frequently ordered item

SELECT m.menu_item_id, m.item_name, SUM(oi.quantity) AS quantity_ordered FROM order_item oi JOIN menu_item m ON m.menu_item_id=oi.menu_item_id JOIN orders o ON o.order_id=oi.order_id WHERE o.status <> 'CANCELLED' GROUP BY m.menu_item_id,m.item_name ORDER BY quantity_ordered DESC,m.menu_item_id LIMIT 1;

-- 16. Customers who never ordered

SELECT c.customer_id,c.full_name,c.email FROM customer c LEFT JOIN orders o ON o.customer_id=c.customer_id WHERE o.order_id IS NULL ORDER BY c.customer_id;

-- 17. Partners with more than five completed deliveries

SELECT p.partner_id,p.full_name,COUNT(*) AS completed_deliveries FROM delivery_partner p JOIN delivery d ON d.partner_id=p.partner_id WHERE d.delivery_status='DELIVERED' GROUP BY p.partner_id,p.full_name HAVING COUNT(*) > 5 ORDER BY completed_deliveries DESC;

-- 18. Average restaurant rating

SELECT r.restaurant_id,r.name,ROUND(AVG(rv.rating),2) AS average_rating,COUNT(rv.review_id) AS review_count FROM restaurant r LEFT JOIN review rv ON rv.restaurant_id=r.restaurant_id GROUP BY r.restaurant_id,r.name ORDER BY average_rating DESC;

-- 19. Highest-spending customer

SELECT c.customer_id,c.full_name,SUM(o.final_amount) AS total_spent FROM customer c JOIN orders o ON o.customer_id=c.customer_id WHERE o.status='DELIVERED' GROUP BY c.customer_id,c.full_name ORDER BY total_spent DESC LIMIT 1;

-- 20. Highest-revenue restaurant

SELECT r.restaurant_id,r.name,SUM(o.final_amount) AS revenue FROM restaurant r JOIN orders o ON o.restaurant_id=r.restaurant_id WHERE o.status='DELIVERED' GROUP BY r.restaurant_id,r.name ORDER BY revenue DESC LIMIT 1;

-- 21. Second most expensive food item

SELECT menu_item_id,item_name,price FROM (SELECT m.*,DENSE_RANK() OVER(ORDER BY price DESC) AS price_rank FROM menu_item m) x WHERE price_rank=2 ORDER BY menu_item_id;

-- 22. Restaurants above the overall average rating

WITH restaurant_avg AS (SELECT restaurant_id,AVG(rating) avg_rating FROM review GROUP BY restaurant_id), overall AS (SELECT AVG(rating) overall_avg FROM review) SELECT r.restaurant_id,r.name,ROUND(ra.avg_rating,2) avg_rating FROM restaurant r JOIN restaurant_avg ra ON ra.restaurant_id=r.restaurant_id CROSS JOIN overall o WHERE ra.avg_rating>o.overall_avg ORDER BY ra.avg_rating DESC;

-- 23. Customers above average order count

WITH counts AS (SELECT c.customer_id,c.full_name,COUNT(o.order_id) order_count FROM customer c LEFT JOIN orders o ON o.customer_id=c.customer_id GROUP BY c.customer_id,c.full_name) SELECT * FROM counts WHERE order_count>(SELECT AVG(order_count) FROM counts) ORDER BY order_count DESC;

-- 24. Food items never ordered

SELECT m.menu_item_id,m.item_name,r.name AS restaurant_name FROM menu_item m JOIN restaurant r ON r.restaurant_id=m.restaurant_id LEFT JOIN order_item oi ON oi.menu_item_id=m.menu_item_id WHERE oi.order_item_id IS NULL ORDER BY m.menu_item_id;

-- 25. Top three best-selling food items

SELECT m.menu_item_id,m.item_name,SUM(oi.quantity) units_sold FROM order_item oi JOIN menu_item m ON m.menu_item_id=oi.menu_item_id JOIN orders o ON o.order_id=oi.order_id WHERE o.status='DELIVERED' GROUP BY m.menu_item_id,m.item_name ORDER BY units_sold DESC,m.menu_item_id LIMIT 3;

-- 26. Customers who used coupons

SELECT DISTINCT c.customer_id,c.full_name,cp.coupon_code FROM coupon_redemption cr JOIN customer c ON c.customer_id=cr.customer_id JOIN coupon cp ON cp.coupon_id=cr.coupon_id ORDER BY c.customer_id,cp.coupon_code;

-- 27. Restaurants without orders

SELECT r.restaurant_id,r.name FROM restaurant r LEFT JOIN orders o ON o.restaurant_id=r.restaurant_id WHERE o.order_id IS NULL ORDER BY r.restaurant_id;

-- 28. Monthly restaurant revenue

SELECT r.restaurant_id,r.name,DATE_FORMAT(o.order_time,'%Y-%m') revenue_month,SUM(o.final_amount) revenue FROM restaurant r JOIN orders o ON o.restaurant_id=r.restaurant_id WHERE o.status='DELIVERED' GROUP BY r.restaurant_id,r.name,DATE_FORMAT(o.order_time,'%Y-%m') ORDER BY revenue_month,r.name;

-- 29. Partners with the highest completed-delivery count

WITH counts AS (SELECT p.partner_id,p.full_name,COUNT(d.delivery_id) completed_count FROM delivery_partner p LEFT JOIN delivery d ON d.partner_id=p.partner_id AND d.delivery_status='DELIVERED' GROUP BY p.partner_id,p.full_name) SELECT * FROM counts WHERE completed_count=(SELECT MAX(completed_count) FROM counts);

-- 30. Ordering customers who never reviewed

SELECT DISTINCT c.customer_id,c.full_name FROM customer c JOIN orders o ON o.customer_id=c.customer_id LEFT JOIN review rv ON rv.customer_id=c.customer_id WHERE rv.review_id IS NULL ORDER BY c.customer_id;


