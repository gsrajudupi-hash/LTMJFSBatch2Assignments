-- 1. MASTER TABLES

CREATE TABLE customers (
customer_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
full_name VARCHAR(120) NOT NULL,
email VARCHAR(254) NOT NULL,
mobile VARCHAR(20) NOT NULL,
password_hash VARCHAR(255) NOT NULL,
account_status ENUM('ACTIVE','BLOCKED','PENDING_DELETION','DELETED') NOT NULL DEFAULT 'ACTIVE',
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
deleted_at DATETIME NULL,
CONSTRAINT uq_customers_email UNIQUE (email),
CONSTRAINT uq_customers_mobile UNIQUE (mobile),
INDEX idx_customers_status (account_status)
) ENGINE=InnoDB;

INSERT INTO customers (full_name,email,mobile,password_hash) VALUES
('Aarav Sharma','aarav@example.com','9000000001','$2b$demo_hash_aarav'),
('Diya Reddy','diya@example.com','9000000002','$2b$demo_hash_diya'),
('Kabir Rao','kabir@example.com','9000000003','$2b$demo_hash_kabir'),
('Meera Iyer','meera@example.com','9000000004','$2b$demo_hash_meera'),
('Rohan Das','rohan@example.com','9000000005','$2b$demo_hash_rohan');

---------------------------
CREATE TABLE customer_addresses (
address_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
customer_id BIGINT UNSIGNED NOT NULL,
address_label VARCHAR(40) NOT NULL DEFAULT 'Home',
recipient_name VARCHAR(120) NOT NULL,
recipient_mobile VARCHAR(20) NOT NULL,
address_line1 VARCHAR(200) NOT NULL,
address_line2 VARCHAR(200) NULL,
landmark VARCHAR(120) NULL,
city VARCHAR(100) NOT NULL,
state VARCHAR(100) NOT NULL,
postal_code VARCHAR(15) NOT NULL,
latitude DECIMAL(10,7) NULL,
longitude DECIMAL(10,7) NULL,
is_default BOOLEAN NOT NULL DEFAULT FALSE,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_address_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
INDEX idx_address_customer (customer_id),
INDEX idx_address_location (city, postal_code)
) ENGINE=InnoDB;


INSERT INTO customer_addresses
(customer_id,address_label,recipient_name,recipient_mobile,address_line1,city,state,postal_code,is_default)
VALUES
(1,'Home','Aarav Sharma','9000000001','12 Lake View Road','Hyderabad','Telangana','500081',TRUE),
(2,'Home','Diya Reddy','9000000002','8 Green Park','Hyderabad','Telangana','500032',TRUE),
(3,'Office','Kabir Rao','9000000003','Cyber Towers','Hyderabad','Telangana','500081',TRUE),
(4,'Home','Meera Iyer','9000000004','22 Temple Street','Chennai','Tamil Nadu','600017',TRUE),
(5,'Home','Rohan Das','9000000005','5 Park Lane','Hyderabad','Telangana','500034',TRUE);

-------------------------------------------
CREATE TABLE restaurants (
restaurant_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
restaurant_name VARCHAR(150) NOT NULL,
description VARCHAR(500) NULL,
email VARCHAR(254) NULL,
phone VARCHAR(20) NOT NULL,
address_line1 VARCHAR(200) NOT NULL,
address_line2 VARCHAR(200) NULL,
city VARCHAR(100) NOT NULL,
state VARCHAR(100) NOT NULL,
postal_code VARCHAR(15) NOT NULL,
latitude DECIMAL(10,7) NULL,
longitude DECIMAL(10,7) NULL,
average_rating DECIMAL(3,2) NOT NULL DEFAULT 0.00,
is_active BOOLEAN NOT NULL DEFAULT TRUE,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT uq_restaurant_email UNIQUE (email),
CONSTRAINT chk_restaurant_rating CHECK (average_rating BETWEEN 0 AND 5),
INDEX idx_restaurant_location_active (city, postal_code, is_active),
INDEX idx_restaurant_active (is_active)
) ;

INSERT INTO restaurants
(restaurant_name,description,email,phone,address_line1,city,state,postal_code,average_rating,is_active)
VALUES
('Spice Route','South and North Indian meals','spice@example.com','9100000001','1 Food
Street','Hyderabad','Telangana','500081',4.50,TRUE),
('Wok Express','Chinese and Asian food','wok@example.com','9100000002','2 Market
Road','Hyderabad','Telangana','500032',4.20,TRUE),
('Green Bowl','Healthy vegetarian meals','green@example.com','9100000003','3 Garden Avenue','Chennai','Tamil
Nadu','600017',4.70,TRUE),
('Old Town Cafe','Cafe and snacks','oldtown@example.com','9100000004','4 Central
Road','Hyderabad','Telangana','500034',0.00,FALSE);

--------------------------------
CREATE TABLE restaurant_operating_hours (
operating_hour_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
restaurant_id BIGINT UNSIGNED NOT NULL,
day_of_week TINYINT UNSIGNED NOT NULL COMMENT '1=Monday ... 7=Sunday',
opens_at TIME NULL,
closes_at TIME NULL,
is_closed BOOLEAN NOT NULL DEFAULT FALSE,
CONSTRAINT fk_hours_restaurant FOREIGN KEY (restaurant_id)
REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
CONSTRAINT uq_restaurant_day UNIQUE (restaurant_id, day_of_week),
OFDMS | Complete MySQL 8.0 SQL Code Page 4
CONSTRAINT chk_day_of_week CHECK (day_of_week BETWEEN 1 AND 7),
CONSTRAINT chk_hours CHECK (
(is_closed = TRUE AND opens_at IS NULL AND closes_at IS NULL)
OR (is_closed = FALSE AND opens_at IS NOT NULL AND closes_at IS NOT NULL AND opens_at < closes_at)
)
) ;


INSERT INTO restaurant_operating_hours (restaurant_id,day_of_week,opens_at,closes_at,is_closed) VALUES
(1,1,'09:00:00','22:00:00',FALSE),(1,2,'09:00:00','22:00:00',FALSE),
(1,3,'09:00:00','22:00:00',FALSE),(1,4,'09:00:00','22:00:00',FALSE),
(1,5,'09:00:00','22:00:00',FALSE),(1,6,'09:00:00','23:00:00',FALSE),
(1,7,'09:00:00','23:00:00',FALSE),
(2,1,'10:00:00','22:00:00',FALSE),(2,2,'10:00:00','22:00:00',FALSE),
(2,3,'10:00:00','22:00:00',FALSE),(2,4,'10:00:00','22:00:00',FALSE),
(2,5,'10:00:00','22:00:00',FALSE),(2,6,'10:00:00','22:00:00',FALSE),
(2,7,'10:00:00','22:00:00',FALSE);
-------------------------------------------------------------------
CREATE TABLE food_categories (
category_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
category_name VARCHAR(100) NOT NULL,
description VARCHAR(300) NULL,
is_active BOOLEAN NOT NULL DEFAULT TRUE,
CONSTRAINT uq_category_name UNIQUE (category_name)
) ;


INSERT INTO food_categories (category_name,description) VALUES
('South Indian','Idli, dosa and meals'),('North Indian','Curries and breads'),
('Chinese','Noodles and rice'),('Fast Food','Burgers and wraps'),
('Desserts','Sweet dishes'),('Beverages','Hot and cold drinks');

---------------------------------
CREATE TABLE menu_items (
menu_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
restaurant_id BIGINT UNSIGNED NOT NULL,
category_id BIGINT UNSIGNED NOT NULL,
item_name VARCHAR(150) NOT NULL,
description VARCHAR(500) NULL,
price DECIMAL(10,2) NOT NULL,
food_type ENUM('VEG','NON_VEG','EGG') NOT NULL,
is_available BOOLEAN NOT NULL DEFAULT TRUE,
preparation_time_minutes SMALLINT UNSIGNED NOT NULL DEFAULT 20,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
CONSTRAINT fk_menu_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
CONSTRAINT fk_menu_category FOREIGN KEY (category_id) REFERENCES food_categories(category_id),
CONSTRAINT chk_menu_price CHECK (price >= 0),
INDEX idx_menu_restaurant_available (restaurant_id, is_available),
INDEX idx_menu_category (category_id),
INDEX idx_menu_name (item_name)
) ;


INSERT INTO menu_items
(restaurant_id,category_id,item_name,description,price,food_type,is_available,preparation_time_minutes)
VALUES
(1,1,'Masala Dosa','Crispy dosa with potato masala',120.00,'VEG',TRUE,15),
(1,1,'Idli Vada Combo','Idli and vada with chutney',90.00,'VEG',TRUE,12),
(1,2,'Paneer Butter Masala','Paneer in tomato gravy',240.00,'VEG',TRUE,25),
(1,2,'Chicken Biryani','Chicken dum biryani',280.00,'NON_VEG',TRUE,30),
(2,3,'Veg Hakka Noodles','Stir-fried noodles',180.00,'VEG',TRUE,18),
(2,3,'Chicken Fried Rice','Fried rice with chicken',230.00,'NON_VEG',TRUE,20),
(2,5,'Brownie','Chocolate brownie',110.00,'VEG',FALSE,10),
(3,4,'Falafel Wrap','Falafel and salad wrap',160.00,'VEG',TRUE,15),
(3,6,'Mango Smoothie','Fresh mango smoothie',130.00,'VEG',TRUE,8),
(4,4,'Classic Sandwich','Grilled vegetable sandwich',100.00,'VEG',TRUE,10);

-------------------------------------

-- 2. CART

CREATE TABLE carts (
cart_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
customer_id BIGINT UNSIGNED NOT NULL,
restaurant_id BIGINT UNSIGNED NULL,
cart_status ENUM('ACTIVE','CONVERTED','ABANDONED') NOT NULL DEFAULT 'ACTIVE',
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
CONSTRAINT fk_cart_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
CONSTRAINT fk_cart_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
INDEX idx_cart_customer_status (customer_id, cart_status)
) 


INSERT INTO carts (customer_id,restaurant_id) VALUES (1,1),(2,2);
--------------------------------------------------------
CREATE TABLE cart_items (
cart_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
cart_id BIGINT UNSIGNED NOT NULL,
menu_item_id BIGINT UNSIGNED NOT NULL,
quantity INT UNSIGNED NOT NULL,
added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_cart_item_cart FOREIGN KEY (cart_id) REFERENCES carts(cart_id) ON DELETE CASCADE,
CONSTRAINT fk_cart_item_menu FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id),
CONSTRAINT uq_cart_menu_item UNIQUE (cart_id, menu_item_id),
CONSTRAINT chk_cart_quantity CHECK (quantity > 0)
) 
INSERT INTO cart_items (cart_id,menu_item_id,quantity) VALUES (1,1,2),(1,3,1),(2,5,1);


-- 3. ORDERING

CREATE TABLE orders (
order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
order_number VARCHAR(30) NOT NULL,
customer_id BIGINT UNSIGNED NOT NULL,
restaurant_id BIGINT UNSIGNED NOT NULL,
delivery_address_id BIGINT UNSIGNED NULL,
-- Address snapshot: retained even if customer edits/deletes the address.
delivery_recipient_name VARCHAR(120) NOT NULL,
delivery_mobile VARCHAR(20) NOT NULL,
delivery_address_text VARCHAR(700) NOT NULL,
order_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
estimated_delivery_at DATETIME NULL,
subtotal DECIMAL(12,2) NOT NULL,
delivery_charge DECIMAL(10,2) NOT NULL DEFAULT 0.00,
discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
total_amount DECIMAL(12,2) NOT NULL,
order_status ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP',
'OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NOT NULL DEFAULT 'PLACED',
cancellation_reason VARCHAR(500) NULL,
cancelled_at DATETIME NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT uq_order_number UNIQUE (order_number),
CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
CONSTRAINT fk_order_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
CONSTRAINT fk_order_address FOREIGN KEY (delivery_address_id) REFERENCES customer_addresses(address_id)
ON DELETE SET NULL,
CONSTRAINT chk_order_amounts CHECK (

subtotal >= 0 AND delivery_charge >= 0 AND discount_amount >= 0
AND tax_amount >= 0 AND total_amount >= 0
),
INDEX idx_orders_customer_date (customer_id, order_datetime),
INDEX idx_orders_restaurant_date (restaurant_id, order_datetime),
INDEX idx_orders_status_date (order_status, order_datetime)
) ;

INSERT INTO orders
(order_number,customer_id,restaurant_id,delivery_address_id,delivery_recipient_name,
delivery_mobile,delivery_address_text,order_datetime,estimated_delivery_at,
subtotal,delivery_charge,discount_amount,tax_amount,total_amount,order_status)
VALUES
('OFD-2026-0001',1,1,1,'Aarav Sharma','9000000001','12 Lake View Road, Hyderabad',
'2026-01-05 12:10:00','2026-01-05 13:00:00',480.00,30.00,50.00,23.00,483.00,'DELIVERED'),
('OFD-2026-0002',2,2,2,'Diya Reddy','9000000002','8 Green Park, Hyderabad',
'2026-01-06 19:15:00','2026-01-06 20:00:00',410.00,30.00,0.00,20.50,460.50,'DELIVERED'),
('OFD-2026-0003',1,1,1,'Aarav Sharma','9000000001','12 Lake View Road, Hyderabad',
'2026-02-10 13:00:00','2026-02-10 13:45:00',280.00,25.00,0.00,14.00,319.00,'DELIVERED'),
('OFD-2026-0004',3,3,3,'Kabir Rao','9000000003','Cyber Towers, Hyderabad',
'2026-02-11 20:00:00','2026-02-11 20:45:00',290.00,25.00,30.00,14.50,299.50,'PREPARING'),
('OFD-2026-0005',4,1,4,'Meera Iyer','9000000004','22 Temple Street, Chennai',
'2026-03-01 10:30:00','2026-03-01 11:15:00',210.00,30.00,0.00,10.50,250.50,'CANCELLED'),
('OFD-2026-0006',2,2,2,'Diya Reddy','9000000002','8 Green Park, Hyderabad',
'2026-03-12 18:30:00','2026-03-12 19:15:00',230.00,30.00,20.00,11.50,251.50,'DELIVERED'),
('OFD-2026-0007',5,1,5,'Rohan Das','9000000005','5 Park Lane, Hyderabad',
'2026-04-02 12:00:00','2026-04-02 12:50:00',360.00,30.00,0.00,18.00,408.00,'PLACED');
------------------------------------------

CREATE TABLE order_items (
order_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
order_id BIGINT UNSIGNED NOT NULL,
menu_item_id BIGINT UNSIGNED NULL,
item_name_snapshot VARCHAR(150) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT UNSIGNED NOT NULL,
line_total DECIMAL(12,2) GENERATED ALWAYS AS (unit_price * quantity) STORED,
CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
CONSTRAINT fk_order_item_menu FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id)
ON DELETE SET NULL,
CONSTRAINT chk_order_item_price CHECK (unit_price >= 0),
CONSTRAINT chk_order_item_quantity CHECK (quantity > 0),
INDEX idx_order_items_menu (menu_item_id),
INDEX idx_order_items_order (order_id)
) ;

INSERT INTO order_items (order_id,menu_item_id,item_name_snapshot,unit_price,quantity) VALUES
(1,1,'Masala Dosa',120.00,2),(1,3,'Paneer Butter Masala',240.00,1),
(2,5,'Veg Hakka Noodles',180.00,1),(2,6,'Chicken Fried Rice',230.00,1),
(3,4,'Chicken Biryani',280.00,1),
(4,8,'Falafel Wrap',160.00,1),(4,9,'Mango Smoothie',130.00,1),
(5,1,'Masala Dosa',105.00,2),
(6,6,'Chicken Fried Rice',230.00,1),
(7,2,'Idli Vada Combo',90.00,4);
------------------------------------------

-- 4. PAYMENT, DELIVERY, TRACKING, REFUNDS

CREATE TABLE payments (
payment_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
order_id BIGINT UNSIGNED NOT NULL,
payment_method ENUM('UPI','CREDIT_CARD','DEBIT_CARD','CASH_ON_DELIVERY') NOT NULL,
transaction_reference VARCHAR(100) NULL,
payment_amount DECIMAL(12,2) NOT NULL,
payment_status ENUM('INITIATED','PENDING','SUCCESS','FAILED','REFUNDED') NOT NULL DEFAULT 'INITIATED',
attempted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
completed_at DATETIME NULL,
failure_reason VARCHAR(300) NULL,
CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
CONSTRAINT uq_payment_reference UNIQUE (transaction_reference),
CONSTRAINT chk_payment_amount CHECK (payment_amount >= 0),
INDEX idx_payment_order_status (order_id, payment_status)
) ;

INSERT INTO payments
(order_id,payment_method,transaction_reference,payment_amount,payment_status,attempted_at,completed_at,failure_r
eason)
VALUES
(1,'UPI','TXN-UPI-1001',483.00,'SUCCESS',SYSDATE(),SYSDATE(),NULL),
(2,'CREDIT_CARD','TXN-CC-1002',460.50,'SUCCESS',SYSDATE(),SYSDATE(),NULL),
(3,'UPI','TXN-UPI-1003-FAIL',319.00,'FAILED',SYSDATE(),NULL,'Bank declined'),
(3,'UPI','TXN-UPI-1003-OK',319.00,'SUCCESS',SYSDATE(),SYSDATE(),NULL),
(4,'CASH_ON_DELIVERY',NULL,299.50,'PENDING',SYSDATE(),NULL,NULL),
(5,'DEBIT_CARD','TXN-DC-1005',250.50,'SUCCESS',SYSDATE(),SYSDATE(),NULL),
(6,'UPI','TXN-UPI-1006',251.50,'SUCCESS',SYSDATE(),SYSDATE(),NULL);

--------------------------------------------------------------
CREATE TABLE delivery_partners (
delivery_partner_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
full_name VARCHAR(120) NOT NULL,
mobile VARCHAR(20) NOT NULL,
email VARCHAR(254) NULL,
vehicle_type ENUM('BIKE','SCOOTER','BICYCLE','OTHER') NOT NULL,
vehicle_number VARCHAR(30) NULL,
availability_status ENUM('AVAILABLE','BUSY','OFFLINE','SUSPENDED') NOT NULL DEFAULT 'OFFLINE',
joined_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT uq_partner_mobile UNIQUE (mobile),
CONSTRAINT uq_partner_email UNIQUE (email),
INDEX idx_partner_availability (availability_status)
) ;
INSERT INTO delivery_partners
(full_name,mobile,email,vehicle_type,vehicle_number,availability_status)
VALUES
('Vikram Singh','9200000001','vikram@example.com','BIKE','TS09AB1234','AVAILABLE'),
('Ananya Rao','9200000002','ananya@example.com','SCOOTER','TS10CD5678','BUSY'),
('Rahul Kumar','9200000003','rahul@example.com','BIKE','TN01EF9012','OFFLINE');

---------------------------------------------------
CREATE TABLE deliveries (
delivery_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
order_id BIGINT UNSIGNED NOT NULL,
delivery_partner_id BIGINT UNSIGNED NULL,
OFDMS | Complete MySQL 8.0 SQL Code Page 7
assignment_status ENUM('ASSIGNED','ACCEPTED','REJECTED','PICKED_UP','DELIVERED','FAILED')
NOT NULL DEFAULT 'ASSIGNED',
assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
accepted_at DATETIME NULL,
pickup_at DATETIME NULL,
delivered_at DATETIME NULL,
delivery_notes VARCHAR(500) NULL,
CONSTRAINT uq_delivery_order UNIQUE (order_id),
CONSTRAINT fk_delivery_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
CONSTRAINT fk_delivery_partner FOREIGN KEY (delivery_partner_id)
REFERENCES delivery_partners(delivery_partner_id) ON DELETE SET NULL,
INDEX idx_delivery_partner_status (delivery_partner_id, assignment_status)
) ;
INSERT INTO deliveries
(order_id,delivery_partner_id,assignment_status,assigned_at,accepted_at,pickup_at,delivered_at)
VALUES
(1,1,'DELIVERED','2026-01-05 12:20:00','2026-01-05 12:22:00','2026-01-05 12:40:00','2026-01-05 12:55:00'),
(2,2,'DELIVERED','2026-01-06 19:25:00','2026-01-06 19:27:00','2026-01-06 19:40:00','2026-01-06 19:58:00'),
(3,1,'DELIVERED','2026-02-10 13:10:00','2026-02-10 13:12:00','2026-02-10 13:25:00','2026-02-10 13:42:00'),
(4,2,'ACCEPTED','2026-02-11 20:05:00','2026-02-11 20:07:00',NULL,NULL),
(6,1,'DELIVERED','2026-03-12 18:40:00','2026-03-12 18:42:00','2026-03-12 18:55:00','2026-03-12 19:10:00');
---------------------------------------------------------
CREATE TABLE order_status_history (
history_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
order_id BIGINT UNSIGNED NOT NULL,
old_status ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP',
'OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NULL,
new_status ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP',
'OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NOT NULL,
changed_by VARCHAR(100) NOT NULL,
change_note VARCHAR(500) NULL,
changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_history_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
INDEX idx_history_order_time (order_id, changed_at)
) ;
----delete items
INSERT INTO order_status_history(order_id,old_status,new_status,changed_by,change_note,changed_at) VALUES
(1,NULL,'PLACED','CUSTOMER','Order created',SYSDATE()),
(1,'PLACED','CONFIRMED','RESTAURANT','Accepted by restaurant',SYSDATE()),
(1,'CONFIRMED','PREPARING','RESTAURANT','Cooking started',SYSDATE()),
(1,'PREPARING','READY_FOR_PICKUP','RESTAURANT','Packed',SYSDATE()),
(1,'READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERY_PARTNER','Picked up',SYSDATE()),
(1,'OUT_FOR_DELIVERY','DELIVERED','DELIVERY_PARTNER','Delivered',SYSDATE());

---------------------------------------------------------
CREATE TABLE refunds (
refund_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
payment_id BIGINT UNSIGNED NOT NULL,
order_id BIGINT UNSIGNED NOT NULL,
OFDMS | Complete MySQL 8.0 SQL Code Page 8
refund_reference VARCHAR(100) NULL,
refund_amount DECIMAL(12,2) NOT NULL,
refund_status ENUM('REQUESTED','PROCESSING','SUCCESS','FAILED') NOT NULL DEFAULT 'REQUESTED',
refund_reason VARCHAR(500) NOT NULL,
requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
processed_at DATETIME NULL,
CONSTRAINT fk_refund_payment FOREIGN KEY (payment_id) REFERENCES payments(payment_id),
CONSTRAINT fk_refund_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
CONSTRAINT uq_refund_reference UNIQUE (refund_reference),
CONSTRAINT chk_refund_amount CHECK (refund_amount > 0),
INDEX idx_refund_order (order_id, refund_status)
) ;

INSERT INTO refunds(payment_id,order_id,refund_reference,refund_amount,refund_status,refund_reason,requested_at,
processed_at)
VALUES (6,5,'REF-1005',250.50,'SUCCESS','Order cancelled; full refund',SYSDATE(),SYSDATE());

------------------------------------------------------------

-- 5. REVIEWS AND PROMOTIONS

CREATE TABLE reviews (
review_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
customer_id BIGINT UNSIGNED NOT NULL,
order_id BIGINT UNSIGNED NOT NULL,
restaurant_id BIGINT UNSIGNED NOT NULL,
menu_item_id BIGINT UNSIGNED NULL,
rating TINYINT UNSIGNED NOT NULL,
comments VARCHAR(1000) NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_review_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
CONSTRAINT fk_review_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
CONSTRAINT fk_review_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
CONSTRAINT fk_review_menu FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_item_id) ON DELETE SET NULL,
CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5),
CONSTRAINT uq_review_customer_order_item UNIQUE (customer_id, order_id, menu_item_id),
INDEX idx_review_restaurant (restaurant_id)
) ;
INSERT INTO reviews(customer_id,order_id,restaurant_id,menu_item_id,rating,comments,created_at)
VALUES
(1,1,1,NULL,5,'Excellent food and quick delivery', SYSDATE()),
(1,1,1,1,5,'Crispy and tasty dosa', SYSDATE()),
(2,2,2,NULL,4,'Good taste', SYSDATE()),

(1,3,1,NULL,4,'Biryani was good', SYSDATE()),
(2,6,2,NULL,4,'Fresh and hot', SYSDATE());

------------------------------------------------------------------

CREATE TABLE coupons (
coupon_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
coupon_code VARCHAR(40) NOT NULL,
description VARCHAR(300) NULL,
discount_type ENUM('PERCENT','FIXED') NOT NULL,
discount_value DECIMAL(10,2) NOT NULL,
max_discount DECIMAL(10,2) NULL,
minimum_order_value DECIMAL(10,2) NOT NULL DEFAULT 0.00,
valid_from DATETIME NOT NULL,
valid_to DATETIME NOT NULL,
max_total_uses INT UNSIGNED NULL,
max_uses_per_customer INT UNSIGNED NOT NULL DEFAULT 1,
is_active BOOLEAN NOT NULL DEFAULT TRUE,
CONSTRAINT uq_coupon_code UNIQUE (coupon_code),
CONSTRAINT chk_coupon_value CHECK (discount_value > 0),
CONSTRAINT chk_coupon_dates CHECK (valid_to > valid_from),
CONSTRAINT chk_coupon_min CHECK (minimum_order_value >= 0),
CONSTRAINT chk_coupon_percent CHECK (discount_type <> 'PERCENT' OR discount_value <= 100)
) ;


INSERT INTO coupons
(coupon_code,description,discount_type,discount_value,max_discount,minimum_order_value,
valid_from,valid_to,max_total_uses,max_uses_per_customer,is_active)
VALUES
('WELCOME10','10 percent welcome offer','PERCENT',10.00,100.00,200.00,
SYSDATE(),SYSDATE(),1000,1,TRUE),
('SAVE50','Flat fifty off','FIXED',50.00,50.00,300.00,
SYSDATE(),SYSDATE(),500,2,TRUE);

-------------------------------------
CREATE TABLE coupon_redemptions (
redemption_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
coupon_id BIGINT UNSIGNED NOT NULL,
customer_id BIGINT UNSIGNED NOT NULL,
order_id BIGINT UNSIGNED NOT NULL,
discount_amount DECIMAL(10,2) NOT NULL,
redeemed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_redemption_coupon FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id),

CONSTRAINT fk_redemption_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
CONSTRAINT fk_redemption_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
CONSTRAINT uq_coupon_order UNIQUE (coupon_id, order_id),
CONSTRAINT chk_redemption_discount CHECK (discount_amount >= 0),
INDEX idx_redemption_customer_coupon (customer_id, coupon_id)
) ;



INSERT INTO coupon_redemptions(coupon_id,customer_id,order_id,discount_amount,redeemed_at)
VALUES (1,1,1,50.00,SYSDATE()),(2,3,4,30.00,SYSDATE());

-----------------------------------------------------------------

 

--
-