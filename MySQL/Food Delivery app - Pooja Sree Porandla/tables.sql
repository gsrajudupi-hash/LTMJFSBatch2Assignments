CREATE DATABASE food_delivery_db; 
USE food_delivery_db; 
CREATE TABLE customers ( 

customer_id INT AUTO_INCREMENT PRIMARY KEY, 
first_name VARCHAR(50) NOT NULL, 
last_name VARCHAR(50), 
email VARCHAR(120) NOT NULL UNIQUE, 
mobile_number VARCHAR(15) NOT NULL UNIQUE, 
password_hash VARCHAR(255) NOT NULL, 
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
account_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE', 
CHECK(account_status IN ('ACTIVE','INACTIVE','BLOCKED')) 
); 

CREATE TABLE customer_addresses ( 
address_id INT AUTO_INCREMENT PRIMARY KEY, 
customer_id INT NOT NULL, 
address_type VARCHAR(30) NOT NULL, 
house_number VARCHAR(50), 
street VARCHAR(100) NOT NULL, 
city VARCHAR(60) NOT NULL, 
state VARCHAR(60) NOT NULL, 
pincode VARCHAR(10) NOT NULL, 
is_default BOOLEAN NOT NULL DEFAULT FALSE, 
FOREIGN KEY(customer_id) REFERENCES customers(customer_id) 
); 

CREATE TABLE restaurants ( 
restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
restaurant_name VARCHAR(120) NOT NULL, 
address VARCHAR(255) NOT NULL, 
city VARCHAR(60) NOT NULL, 
contact_number VARCHAR(15) UNIQUE, 
email VARCHAR(120) UNIQUE, 
opening_time TIME, 
closing_time TIME, 
is_active BOOLEAN NOT NULL DEFAULT TRUE 
); 

CREATE TABLE food_categories ( 
category_id INT AUTO_INCREMENT PRIMARY KEY, 
category_name VARCHAR(60) NOT NULL UNIQUE, 
description VARCHAR(255) 
); 

CREATE TABLE menu_items ( 
item_id INT AUTO_INCREMENT PRIMARY KEY, 
restaurant_id INT NOT NULL, 
category_id INT NOT NULL, 
item_name VARCHAR(120) NOT NULL, 
description VARCHAR(255), 
price DECIMAL(10,2) NOT NULL, 
food_type VARCHAR(20) NOT NULL, 
is_available BOOLEAN NOT NULL DEFAULT TRUE, 
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
FOREIGN KEY(restaurant_id) REFERENCES restaurants(restaurant_id), 
FOREIGN KEY(category_id) REFERENCES food_categories(category_id), 
CHECK(price>=0), CHECK(food_type IN ('VEG','NON_VEG','VEGAN')) 
); 

CREATE TABLE carts ( 

cart_id INT AUTO_INCREMENT PRIMARY KEY, 

customer_id INT NOT NULL UNIQUE, 

created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 

updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 

FOREIGN KEY(customer_id) REFERENCES customers(customer_id) 

); 

CREATE TABLE cart_items ( 

cart_item_id INT AUTO_INCREMENT PRIMARY KEY, cart_id INT NOT NULL, item_id INT NOT NULL, quantity INT NOT NULL, 

added_at DATETIME DEFAULT CURRENT_TIMESTAMP, 

FOREIGN KEY(cart_id) REFERENCES carts(cart_id), FOREIGN KEY(item_id) REFERENCES menu_items(item_id), UNIQUE(cart_id,item_id), CHECK(quantity>0) 

); 

CREATE TABLE orders ( 

order_id INT AUTO_INCREMENT PRIMARY KEY, customer_id INT NOT NULL, restaurant_id INT NOT NULL, address_id INT NOT NULL, 

order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 

subtotal DECIMAL(10,2) NOT NULL, delivery_charge DECIMAL(10,2) NOT NULL DEFAULT 0, discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0, 

total_amount DECIMAL(10,2) NOT NULL, 

order_status VARCHAR(30) NOT NULL DEFAULT 'PLACED', 

FOREIGN KEY(customer_id) REFERENCES customers(customer_id), FOREIGN KEY(restaurant_id) REFERENCES restaurants(restaurant_id), FOREIGN KEY(address_id) REFERENCES customer_addresses(address_id), 

CHECK(subtotal>=0 AND delivery_charge>=0 AND discount_amount>=0 AND total_amount>=0), CHECK(order_status IN ('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP', 'OUT_FOR_DELIVERY','DELIVERED','CANCELLED')) 

); 

CREATE TABLE order_items ( 

order_item_id INT AUTO_INCREMENT PRIMARY KEY, order_id INT NOT NULL, item_id INT NOT NULL, quantity INT NOT NULL, 

item_price DECIMAL(10,2) NOT NULL, total_price DECIMAL(10,2) NOT NULL, FOREIGN KEY(order_id) REFERENCES orders(order_id), 

FOREIGN KEY(item_id) REFERENCES menu_items(item_id), 

UNIQUE(order_id,item_id), CHECK(quantity>0 AND item_price>=0 AND total_price>=0) 

); 

CREATE TABLE payments ( 

payment_id INT AUTO_INCREMENT PRIMARY KEY, order_id INT NOT NULL, payment_method VARCHAR(30) NOT NULL, transaction_reference VARCHAR(100) UNIQUE, payment_amount DECIMAL(10,2) NOT NULL, 

payment_date DATETIME DEFAULT CURRENT_TIMESTAMP, 

payment_status VARCHAR(20) NOT NULL, 

FOREIGN KEY(order_id) REFERENCES orders(order_id), CHECK(payment_method IN ('UPI','CREDIT_CARD','DEBIT_CARD','COD')), CHECK(payment_status IN ('PENDING','SUCCESS','FAILED','REFUNDED')), 

CHECK(payment_amount>=0) 

); 

CREATE TABLE delivery_partners ( 

partner_id INT AUTO_INCREMENT PRIMARY KEY, partner_name VARCHAR(100) NOT NULL, mobile_number VARCHAR(15) NOT NULL UNIQUE, vehicle_number VARCHAR(20) UNIQUE, vehicle_type VARCHAR(30), is_available BOOLEAN DEFAULT TRUE 

); 

CREATE TABLE deliveries ( 

delivery_id INT AUTO_INCREMENT PRIMARY KEY, order_id INT NOT NULL UNIQUE, partner_id INT, pickup_time DATETIME, delivered_time DATETIME, estimated_delivery_time DATETIME, 

delivery_status VARCHAR(30) NOT NULL DEFAULT 'ASSIGNED', 

FOREIGN KEY(order_id) REFERENCES orders(order_id), 

FOREIGN KEY(partner_id) REFERENCES delivery_partners(partner_id), 

CHECK(delivery_status IN ('ASSIGNED','ACCEPTED','PICKED_UP','IN_TRANSIT','DELIVERED','FAILED')) 

); 

CREATE TABLE order_status_history ( 

history_id INT AUTO_INCREMENT PRIMARY KEY, order_id INT NOT NULL, order_status VARCHAR(30) NOT NULL, 

status_updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, remarks VARCHAR(255), FOREIGN KEY(order_id) REFERENCES orders(order_id) 

); 

CREATE TABLE reviews ( 

review_id INT AUTO_INCREMENT PRIMARY KEY, customer_id INT NOT NULL, order_id INT NOT NULL, restaurant_id INT, item_id INT, 

rating INT NOT NULL, comments VARCHAR(500), review_date DATETIME DEFAULT CURRENT_TIMESTAMP, 

FOREIGN KEY(customer_id) REFERENCES customers(customer_id), FOREIGN KEY(order_id) REFERENCES orders(order_id), 

FOREIGN KEY(restaurant_id) REFERENCES restaurants(restaurant_id), FOREIGN KEY(item_id) REFERENCES menu_items(item_id), 

CHECK(rating BETWEEN 1 AND 5) 

); 

CREATE TABLE coupons ( 

coupon_id INT AUTO_INCREMENT PRIMARY KEY, coupon_code VARCHAR(30) NOT NULL UNIQUE, 
discount_type VARCHAR(20) NOT NULL, discount_value DECIMAL(10,2) NOT NULL, 
minimum_order_value DECIMAL(10,2) NOT NULL DEFAULT 0, maximum_discount DECIMAL(10,2), valid_from DATETIME NOT NULL, 

valid_until DATETIME NOT NULL, usage_limit INT, is_active BOOLEAN DEFAULT TRUE, CHECK(discount_type IN ('PERCENT','FIXED')), 

CHECK(discount_value>0 AND minimum_order_value>=0), CHECK(valid_until>valid_from) 

); 

CREATE TABLE coupon_redemptions ( 

redemption_id INT AUTO_INCREMENT PRIMARY KEY, coupon_id INT NOT NULL, customer_id INT NOT NULL, order_id INT NOT NULL UNIQUE, 

redeemed_at DATETIME DEFAULT CURRENT_TIMESTAMP, 

discount_amount DECIMAL(10,2) NOT NULL, 

FOREIGN KEY(coupon_id) REFERENCES coupons(coupon_id), FOREIGN KEY(customer_id) REFERENCES customers(customer_id), FOREIGN KEY(order_id) REFERENCES orders(order_id), CHECK(discount_amount>=0) 

); 

CREATE TABLE refunds ( 

refund_id INT AUTO_INCREMENT PRIMARY KEY, payment_id INT NOT NULL, order_id INT NOT NULL, refund_amount DECIMAL(10,2) NOT NULL, refund_reason VARCHAR(255), refund_status VARCHAR(30) DEFAULT 'PENDING', refund_date DATETIME DEFAULT CURRENT_TIMESTAMP, 

FOREIGN KEY(payment_id) REFERENCES payments(payment_id), FOREIGN KEY(order_id) REFERENCES orders(order_id), CHECK(refund_amount>0), 

CHECK(refund_status IN ('PENDING','PROCESSED','FAILED')) 

); 




