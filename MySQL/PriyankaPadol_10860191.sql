/*
Employee Name : Priyanka Padol
PSID          : 10860191
Case Study    : Food delivery app Database
*/


CREATE DATABASE my_food_delivery;

USE my_food_delivery;

/*
----------------Creating Customer table 
*/
CREATE TABLE customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	mobile VARCHAR (15) NOT NULL UNIQUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	is_active BOOLEAN DEFAULT TRUE
);

ALTER TABLE customers ADD COLUMN password_hash VARCHAR(255) NOT NULL;

INSERT INTO customers
(first_name, last_name, email, mobile, created_at, is_active, password_hash)
VALUES
('Aarav', 'Sharma', 'aarav@gmail.com', '9000000001', '2026-01-10 10:00:00', TRUE, 'hash_aarav'),
('Priya', 'Reddy', 'priya@gmail.com', '9000000002', '2026-01-15 11:00:00', TRUE, 'hash_priya'),
('Rahul', 'Verma', 'rahul@gmail.com', '9000000003', '2026-02-05 12:00:00', TRUE, 'hash_rahul'),
('Sneha', 'Patel', 'sneha@gmail.com', '9000000004', '2026-02-20 09:30:00', TRUE, 'hash_sneha'),
('Arjun', 'Nair', 'arjun@gmail.com', '9000000005', '2026-03-01 14:00:00', TRUE, 'hash_arjun'),
('Neha', 'Gupta', 'neha@gmail.com', '9000000006', '2026-03-10 14:30:00', TRUE, 'hash_neha'),
('Rohan', 'Singh', 'rohan@gmail.com', '9000000007', '2026-04-02 16:00:00', TRUE, 'hash_rohan'),
('Anjali', 'Mehta', 'anjali@gmail.com', '9000000008', '2026-04-12 17:30:00', TRUE, 'hash_anjali'),
('Karan', 'Joshi', 'karan@gmail.com', '9000000009', '2026-05-05 18:00:00', FALSE, 'hash_karan'),
('Pooja', 'Iyer', 'pooja@gmail.com', '9000000010', '2026-05-15 19:15:00', TRUE, 'hash_pooja');

/*
----------------Creating Address Table
*/
CREATE TABLE customer_addresses (
   address_id INT AUTO_INCREMENT PRIMARY KEY,
   customer_id INT NOT NULL,
   address_line1 VARCHAR(255) NOT NULL,
   address_line2 VARCHAR(255),
   city VARCHAR(100) NOT NULL,
   state VARCHAR(100) NOT NULL,
   pincode VARCHAR(10) NOT NULL,
   address_type VARCHAR(30),
   is_default BOOLEAN DEFAULT FALSE,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT fk_customer_address
   FOREIGN KEY (customer_id)
   REFERENCES customers(customer_id)
);

INSERT INTO customer_addresses
(customer_id, address_line1, address_line2, city, state, pincode, address_type, is_default)
VALUES
(1, 'Flat 201, Lake View Apartments', 'Madhapur', 'Hyderabad', 'Telangana', '500081', 'HOME', TRUE),
(1, 'Tech Park Building 5', 'Hitech City', 'Hyderabad', 'Telangana', '500081', 'WORK', FALSE),
(2, 'Flat 402, Green Residency', 'Kondapur', 'Hyderabad', 'Telangana', '500084', 'HOME', TRUE),
(3, 'House 12-100', 'Gachibowli', 'Hyderabad', 'Telangana', '500032', 'HOME', TRUE),
(3, 'DLF Cyber City', 'Gachibowli', 'Hyderabad', 'Telangana', '500032', 'WORK', FALSE),
(4, 'Flat 802, Orange Towers', 'Jubilee Hills', 'Hyderabad', 'Telangana', '500033', 'HOME', TRUE),
(5, 'Villa 19, Palm Meadows', 'Kompally', 'Hyderabad', 'Telangana', '500014', 'HOME', TRUE),
(6, 'Flat 301, Sai Residency', 'Manikonda', 'Hyderabad', 'Telangana', '500089', 'HOME', TRUE),
(7, 'House 7-21', 'Miyapur', 'Hyderabad', 'Telangana', '500049', 'HOME', TRUE),
(8, 'Flat 502, Rainbow Apartments', 'Kukatpally', 'Hyderabad', 'Telangana', '500072', 'HOME', TRUE),
(9, 'Flat 105, Silver Homes', 'Begumpet', 'Hyderabad', 'Telangana', '500016', 'HOME', TRUE),
(10, 'Flat 606, Metro Heights', 'Ameerpet', 'Hyderabad', 'Telangana', '500038', 'HOME', TRUE);

/*
-----------------Creating Restaurants Table
*/
CREATE TABLE restaurants (
   restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
   restaurant_name VARCHAR(150) NOT NULL,
   email VARCHAR(150) UNIQUE,
   contact_number VARCHAR(15) NOT NULL,
   address_line1 VARCHAR(255) NOT NULL,
   address_line2 VARCHAR(255),
   city VARCHAR(100) NOT NULL,
   state VARCHAR(100) NOT NULL,
   pincode VARCHAR(10) NOT NULL,
   is_active BOOLEAN DEFAULT TRUE,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO restaurants
(restaurant_name, email, contact_number,
 address_line1, address_line2,
 city, state, pincode, is_active)
VALUES
('Paradise Biryani', 'paradise@food.com', '9100000001',
 'Madhapur Main Road', NULL,
 'Hyderabad', 'Telangana', '500081', TRUE),
('Pizza Hub', 'pizza@food.com', '9100000002',
 'Road No 36', 'Jubilee Hills',
 'Hyderabad', 'Telangana', '500033', TRUE),
('South Spice', 'southspice@food.com', '9100000003',
 'Gachibowli Main Road', NULL,
 'Hyderabad', 'Telangana', '500032', TRUE),
('Burger Factory', 'burger@food.com', '9100000004',
 'Kondapur Main Road', NULL,
 'Hyderabad', 'Telangana', '500084', TRUE),
('Green Bowl', 'greenbowl@food.com', '9100000005',
 'Hitech City Road', NULL,
 'Hyderabad', 'Telangana', '500081', TRUE),
('Old Town Kitchen', 'oldtown@food.com', '9100000006',
 'Begumpet Main Road', NULL,
 'Hyderabad', 'Telangana', '500016', FALSE);

/*
------------------Creating operation hour table
*/
CREATE TABLE restaurant_operating_hours (
   operating_hour_id INT AUTO_INCREMENT PRIMARY KEY,
   restaurant_id INT NOT NULL,
   day_of_week VARCHAR(10) NOT NULL,
   opening_time TIME,
   closing_time TIME,
   is_closed BOOLEAN DEFAULT FALSE,
   CONSTRAINT fk_operating_restaurant
   FOREIGN KEY (restaurant_id)
   REFERENCES restaurants(restaurant_id),
   CONSTRAINT uq_restaurant_day
   UNIQUE (restaurant_id, day_of_week),
   CONSTRAINT chk_day
   CHECK (day_of_week IN (
       'MONDAY', 'TUESDAY', 'WEDNESDAY',
       'THURSDAY', 'FRIDAY', 'SATURDAY',
       'SUNDAY'
   ))
);

INSERT INTO restaurant_operating_hours
(restaurant_id, day_of_week, opening_time, closing_time, is_closed)
VALUES
(1, 'MONDAY', '10:00:00', '23:00:00', FALSE),
(1, 'TUESDAY', '10:00:00', '23:00:00', FALSE),
(1, 'WEDNESDAY', '10:00:00', '23:00:00', FALSE),
(1, 'THURSDAY', '10:00:00', '23:00:00', FALSE),
(1, 'FRIDAY', '10:00:00', '23:59:00', FALSE),
(1, 'SATURDAY', '10:00:00', '23:59:00', FALSE),
(1, 'SUNDAY', '10:00:00', '23:00:00', FALSE),
(2, 'MONDAY', '11:00:00', '23:00:00', FALSE),
(2, 'TUESDAY', '11:00:00', '23:00:00', FALSE),
(2, 'WEDNESDAY', NULL, NULL, TRUE),
(2, 'THURSDAY', '11:00:00', '23:00:00', FALSE),
(2, 'FRIDAY', '11:00:00', '23:59:00', FALSE),
(2, 'SATURDAY', '11:00:00', '23:59:00', FALSE),
(2, 'SUNDAY', '11:00:00', '23:00:00', FALSE),
(3, 'MONDAY', '07:00:00', '22:00:00', FALSE),
(3, 'TUESDAY', '07:00:00', '22:00:00', FALSE),
(3, 'WEDNESDAY', '07:00:00', '22:00:00', FALSE),
(3, 'THURSDAY', '07:00:00', '22:00:00', FALSE),
(3, 'FRIDAY', '07:00:00', '22:30:00', FALSE),
(3, 'SATURDAY', '07:00:00', '22:30:00', FALSE),
(3, 'SUNDAY', '07:00:00', '22:30:00', FALSE);

/*
-------------------creating food categories table
*/
CREATE TABLE food_categories (
   category_id INT AUTO_INCREMENT PRIMARY KEY,
   category_name VARCHAR(100) NOT NULL UNIQUE,
   description VARCHAR(255),
   is_active BOOLEAN DEFAULT TRUE,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO food_categories
(category_name, description)
VALUES
('Biryani', 'Rice dishes prepared with aromatic spices'),
('Pizza', 'Italian style pizzas'),
('South Indian', 'Traditional South Indian dishes'),
('Burgers', 'Vegetarian and non-vegetarian burgers'),
('Healthy', 'Healthy bowls and salads'),
('Beverages', 'Cold and hot beverages'),
('Desserts', 'Cakes and traditional desserts');

/*
--------------------creating menu items table
*/
CREATE TABLE menu_items (
   menu_item_id INT AUTO_INCREMENT PRIMARY KEY,
   restaurant_id INT NOT NULL,
   category_id INT NOT NULL,
   food_name VARCHAR(150) NOT NULL,
   description VARCHAR(500),
   price DECIMAL(10,2) NOT NULL,
   is_vegetarian BOOLEAN NOT NULL,
   is_available BOOLEAN DEFAULT TRUE,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
       ON UPDATE CURRENT_TIMESTAMP,
   CONSTRAINT fk_menu_restaurant
   FOREIGN KEY (restaurant_id)
   REFERENCES restaurants(restaurant_id),
   CONSTRAINT fk_menu_category
   FOREIGN KEY (category_id)
   REFERENCES food_categories(category_id),
   CONSTRAINT chk_food_price
   CHECK (price >= 0)
);

INSERT INTO menu_items
(restaurant_id, category_id, food_name, description,
 price, is_vegetarian, is_available)
VALUES
(1, 1, 'Chicken Dum Biryani',
 'Hyderabadi chicken dum biryani', 299.00, FALSE, TRUE),
(1, 1, 'Mutton Biryani',
 'Traditional mutton dum biryani', 399.00, FALSE, TRUE),
(1, 1, 'Veg Biryani',
 'Vegetable dum biryani', 229.00, TRUE, TRUE),
(1, 6, 'Sweet Lassi',
 'Traditional chilled lassi', 99.00, TRUE, TRUE),
(2, 2, 'Margherita Pizza',
 'Cheese and tomato pizza', 249.00, TRUE, TRUE),
(2, 2, 'Farmhouse Pizza',
 'Onion, capsicum and mushroom', 349.00, TRUE, TRUE),
(2, 2, 'Chicken Pepperoni Pizza',
 'Chicken pepperoni with mozzarella', 449.00, FALSE, TRUE),
(2, 6, 'Coke',
 'Chilled soft drink', 59.00, TRUE, TRUE),
(3, 3, 'Masala Dosa',
 'Dosa with potato masala', 129.00, TRUE, TRUE),
(3, 3, 'Idli Vada Combo',
 'Two idlis with one vada', 119.00, TRUE, TRUE),
(3, 3, 'Chicken Dosa',
 'Dosa stuffed with chicken', 199.00, FALSE, TRUE),
(3, 6, 'Filter Coffee',
 'South Indian filter coffee', 69.00, TRUE, TRUE),

(4, 4, 'Classic Veg Burger',
 'Veg patty with lettuce', 149.00, TRUE, TRUE),
(4, 4, 'Crispy Chicken Burger',
 'Crispy chicken with spicy mayo', 199.00, FALSE, TRUE),
(4, 4, 'Double Cheese Burger',
 'Double patty with cheese', 249.00, FALSE, TRUE),
(4, 6, 'Chocolate Shake',
 'Chocolate milkshake', 139.00, TRUE, TRUE),

(5, 5, 'Quinoa Veg Bowl',
 'Quinoa with roasted vegetables', 249.00, TRUE, TRUE),
(5, 5, 'Chicken Protein Bowl',
 'Chicken with brown rice and vegetables', 299.00, FALSE, TRUE),
(5, 5, 'Paneer Salad',
 'Paneer with fresh vegetables', 229.00, TRUE, TRUE),
(5, 6, 'Berry Smoothie',
 'Mixed berry smoothie', 149.00, TRUE, FALSE);

/*
-------------------creating carts table
*/
CREATE TABLE IF NOT EXISTS carts (
   cart_id INT AUTO_INCREMENT PRIMARY KEY,
   customer_id INT NOT NULL,
   cart_status VARCHAR(20) DEFAULT 'ACTIVE',
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
       ON UPDATE CURRENT_TIMESTAMP,
   CONSTRAINT fk_cart_customer
   FOREIGN KEY (customer_id)
   REFERENCES customers(customer_id),
   CONSTRAINT chk_cart_status
   CHECK (cart_status IN (
       'ACTIVE', 'CONVERTED', 'ABANDONED'
   ))
);

INSERT INTO carts
(customer_id, cart_status)
VALUES
(1, 'CONVERTED'),
(2, 'ACTIVE'),
(3, 'ABANDONED'),
(4, 'CONVERTED'),
(5, 'ACTIVE'),
(6, 'ACTIVE'),
(7, 'ABANDONED');

/*
----------------creating cart items table
*/
CREATE TABLE IF NOT EXISTS cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_item_cart
    FOREIGN KEY (cart_id)
    REFERENCES carts(cart_id),
    CONSTRAINT fk_cart_item_menu
    FOREIGN KEY (menu_item_id)
    REFERENCES menu_items(menu_item_id),
    CONSTRAINT uq_cart_menu
    UNIQUE (cart_id, menu_item_id),
    CONSTRAINT chk_cart_quantity
    CHECK (quantity > 0)
);

SHOW TABLES;

INSERT INTO cart_items
(cart_id, menu_item_id, quantity)
VALUES
(1, 1, 2),
(1, 4, 1),

(2, 5, 1),
(2, 8, 2),

(3, 13, 1),

(4, 9, 2),
(4, 12, 2),

(5, 17, 1),
(5, 19, 1),

(6, 14, 2),

(7, 6, 1);

/*
----------------creating table orders
*/

CREATE TABLE IF NOT EXISTS orders (
   order_id INT AUTO_INCREMENT PRIMARY KEY,
   customer_id INT NOT NULL,
   restaurant_id INT NOT NULL,
   delivery_address_id INT,
   delivery_address_line1 VARCHAR(255) NOT NULL,
   delivery_address_line2 VARCHAR(255),
   delivery_city VARCHAR(100) NOT NULL,
   delivery_state VARCHAR(100) NOT NULL,
   delivery_pincode VARCHAR(10) NOT NULL,
   order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
   subtotal DECIMAL(10,2) NOT NULL,
   delivery_charge DECIMAL(10,2) DEFAULT 0,
   discount_amount DECIMAL(10,2) DEFAULT 0,
   total_amount DECIMAL(10,2) NOT NULL,
   order_status VARCHAR(30) DEFAULT 'PLACED',
   CONSTRAINT fk_order_customer
   FOREIGN KEY (customer_id)
   REFERENCES customers(customer_id),
   CONSTRAINT fk_order_restaurant
   FOREIGN KEY (restaurant_id)
   REFERENCES restaurants(restaurant_id),
   CONSTRAINT fk_order_address
   FOREIGN KEY (delivery_address_id)
   REFERENCES customer_addresses(address_id)
   ON DELETE SET NULL,
   CONSTRAINT chk_order_status
   CHECK (order_status IN (
       'PLACED', 'CONFIRMED', 'PREPARING',
       'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY',
       'DELIVERED', 'CANCELLED'
   )),
   CONSTRAINT chk_order_amounts
   CHECK (
       subtotal >= 0 AND
       delivery_charge >= 0 AND
       discount_amount >= 0 AND
       total_amount >= 0
   )
);

INSERT INTO orders
(customer_id, restaurant_id, delivery_address_id,
 delivery_address_line1, delivery_address_line2,
 delivery_city, delivery_state, delivery_pincode,
 order_date, subtotal, delivery_charge,
 discount_amount, total_amount, order_status)
VALUES

(1, 1, 1,
 'Flat 201, Lake View Apartments', 'Madhapur',
 'Hyderabad', 'Telangana', '500081',
 '2026-06-10 13:15:00',
 697.00, 40.00, 100.00, 637.00, 'DELIVERED'),

(2, 2, 3,
 'Flat 402, Green Residency', 'Kondapur',
 'Hyderabad', 'Telangana', '500084',
 '2026-06-15 20:30:00',
 408.00, 30.00, 0.00, 438.00, 'DELIVERED'),

(3, 3, 4,
 'House 12-100', 'Gachibowli',
 'Hyderabad', 'Telangana', '500032',
 '2026-07-01 09:00:00',
 307.00, 25.00, 0.00, 332.00, 'CANCELLED'),

(1, 2, 1,
 'Flat 201, Lake View Apartments', 'Madhapur',
 'Hyderabad', 'Telangana', '500081',
 '2026-07-10 19:45:00',
 698.00, 30.00, 50.00, 678.00, 'DELIVERED'),

(4, 3, 6,
 'Flat 802, Orange Towers', 'Jubilee Hills',
 'Hyderabad', 'Telangana', '500033',
 '2026-08-05 08:30:00',
 307.00, 25.00, 0.00, 332.00, 'DELIVERED'),

(5, 4, 7,
 'Villa 19, Palm Meadows', 'Kompally',
 'Hyderabad', 'Telangana', '500014',
 '2026-08-22 21:00:00',
 537.00, 35.00, 75.00, 497.00, 'DELIVERED'),

(2, 1, 3,
 'Flat 402, Green Residency', 'Kondapur',
 'Hyderabad', 'Telangana', '500084',
 '2026-09-05 14:20:00',
 528.00, 40.00, 50.00, 518.00, 'DELIVERED'),

(6, 5, 8,
 'Flat 301, Sai Residency', 'Manikonda',
 'Hyderabad', 'Telangana', '500089',
 '2026-09-18 12:30:00',
 548.00, 30.00, 0.00, 578.00, 'DELIVERED'),

(7, 4, 9,
 'House 7-21', 'Miyapur',
 'Hyderabad', 'Telangana', '500049',
 '2026-10-02 20:10:00',
 398.00, 35.00, 0.00, 433.00, 'CANCELLED'),

(8, 3, 10,
 'Flat 502, Rainbow Apartments', 'Kukatpally',
 'Hyderabad', 'Telangana', '500072',
 '2026-10-10 08:45:00',
 307.00, 25.00, 30.00, 302.00, 'DELIVERED'),

(1, 4, 1,
 'Flat 201, Lake View Apartments', 'Madhapur',
 'Hyderabad', 'Telangana', '500081',
 '2026-11-01 20:00:00',
 537.00, 35.00, 50.00, 522.00, 'DELIVERED'),

(3, 1, 4,
 'House 12-100', 'Gachibowli',
 'Hyderabad', 'Telangana', '500032',
 '2026-11-10 13:30:00',
 398.00, 40.00, 0.00, 438.00, 'DELIVERED'),

(4, 2, 6,
 'Flat 802, Orange Towers', 'Jubilee Hills',
 'Hyderabad', 'Telangana', '500033',
 '2026-11-13 19:00:00',
 508.00, 30.00, 0.00, 538.00, 'OUT_FOR_DELIVERY'),

(5, 1, 7,
 'Villa 19, Palm Meadows', 'Kompally',
 'Hyderabad', 'Telangana', '500014',
 '2026-11-14 08:00:00',
 299.00, 40.00, 0.00, 339.00, 'PREPARING'),

(6, 3, 8,
 'Flat 301, Sai Residency', 'Manikonda',
 'Hyderabad', 'Telangana', '500089',
 '2026-11-14 08:30:00',
 198.00, 25.00, 0.00, 223.00, 'PLACED');

/*
---------------creating table order items
*/
CREATE TABLE IF NOT EXISTS order_items (
   order_item_id INT AUTO_INCREMENT PRIMARY KEY,
   order_id INT NOT NULL,
   menu_item_id INT NOT NULL,
   food_name_snapshot VARCHAR(150) NOT NULL,
   quantity INT NOT NULL,
   price_at_order DECIMAL(10,2) NOT NULL,
   item_total DECIMAL(10,2) NOT NULL,
   CONSTRAINT fk_order_item_order
   FOREIGN KEY (order_id)
   REFERENCES orders(order_id),
   CONSTRAINT fk_order_item_menu
   FOREIGN KEY (menu_item_id)
   REFERENCES menu_items(menu_item_id),
   CONSTRAINT chk_order_item_quantity
   CHECK (quantity > 0),
   CONSTRAINT chk_order_item_price
   CHECK (price_at_order >= 0 AND item_total >= 0)
);

INSERT INTO order_items
(order_id, menu_item_id, food_name_snapshot,
 quantity, price_at_order, item_total)
VALUES
(1, 1, 'Chicken Dum Biryani', 2, 299.00, 598.00),
(1, 4, 'Sweet Lassi', 1, 99.00, 99.00),

(2, 5, 'Margherita Pizza', 1, 249.00, 249.00),
(2, 8, 'Coke', 2, 59.00, 118.00),

(3, 9, 'Masala Dosa', 1, 129.00, 129.00),
(3, 10, 'Idli Vada Combo', 1, 119.00, 119.00),

(4, 6, 'Farmhouse Pizza', 2, 349.00, 698.00),

(5, 9, 'Masala Dosa', 1, 129.00, 129.00),
(5, 12, 'Filter Coffee', 2, 69.00, 138.00),

(6, 14, 'Crispy Chicken Burger', 2, 199.00, 398.00),
(6, 16, 'Chocolate Shake', 1, 139.00, 139.00),

(7, 3, 'Veg Biryani', 1, 229.00, 229.00),
(7, 1, 'Chicken Dum Biryani', 1, 299.00, 299.00),

(8, 17, 'Quinoa Veg Bowl', 1, 249.00, 249.00),
(8, 18, 'Chicken Protein Bowl', 1, 299.00, 299.00),

(9, 14, 'Crispy Chicken Burger', 2, 199.00, 398.00),

(10, 9, 'Masala Dosa', 1, 129.00, 129.00),
(10, 12, 'Filter Coffee', 2, 69.00, 138.00),

(11, 14, 'Crispy Chicken Burger', 2, 199.00, 398.00),
(11, 16, 'Chocolate Shake', 1, 139.00, 139.00),

(12, 2, 'Mutton Biryani', 1, 399.00, 399.00),

(13, 7, 'Chicken Pepperoni Pizza', 1, 449.00, 449.00),
(13, 8, 'Coke', 1, 59.00, 59.00),

(14, 1, 'Chicken Dum Biryani', 1, 299.00, 299.00),

(15, 9, 'Masala Dosa', 1, 129.00, 129.00),
(15, 12, 'Filter Coffee', 1, 69.00, 69.00);

/*
----------------creating table payments
*/

CREATE TABLE IF NOT EXISTS payments (
   payment_id INT AUTO_INCREMENT PRIMARY KEY,
   order_id INT NOT NULL,
   payment_method VARCHAR(30) NOT NULL,
   transaction_reference VARCHAR(100) UNIQUE,
   payment_amount DECIMAL(10,2) NOT NULL,
   payment_status VARCHAR(20) NOT NULL,
   payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT fk_payment_order
   FOREIGN KEY (order_id)
   REFERENCES orders(order_id),
   CONSTRAINT chk_payment_method
   CHECK (payment_method IN (
       'UPI', 'CREDIT_CARD',
       'DEBIT_CARD', 'CASH_ON_DELIVERY'
   )),
   CONSTRAINT chk_payment_status
   CHECK (payment_status IN (
       'PENDING', 'SUCCESS', 'FAILED',
       'REFUNDED', 'PARTIALLY_REFUNDED'
   )),
   CONSTRAINT chk_payment_amount
   CHECK (payment_amount >= 0)
);

INSERT INTO payments
(order_id, payment_method, transaction_reference,
 payment_amount, payment_status, payment_date)
VALUES
(1, 'UPI', 'TXN10001', 637.00, 'SUCCESS', '2026-06-10 13:16:00'),
(2, 'CREDIT_CARD', 'TXN10002', 438.00, 'SUCCESS', '2026-06-15 20:31:00'),

(3, 'UPI', 'TXN10003', 332.00, 'REFUNDED', '2026-07-01 09:01:00'),

(4, 'DEBIT_CARD', 'TXN10004', 678.00, 'SUCCESS', '2026-07-10 19:46:00'),
(5, 'UPI', 'TXN10005', 332.00, 'SUCCESS', '2026-08-05 08:31:00'),
(6, 'CREDIT_CARD', 'TXN10006', 497.00, 'SUCCESS', '2026-08-22 21:01:00'),
(7, 'UPI', 'TXN10007', 518.00, 'SUCCESS', '2026-09-05 14:21:00'),
(8, 'DEBIT_CARD', 'TXN10008', 578.00, 'SUCCESS', '2026-09-18 12:31:00'),

(9, 'CREDIT_CARD', 'TXN10009', 433.00, 'FAILED', '2026-10-02 20:11:00'),

(10, 'UPI', 'TXN10010', 302.00, 'SUCCESS', '2026-10-10 08:46:00'),
(11, 'CASH_ON_DELIVERY', NULL, 522.00, 'SUCCESS', '2026-11-01 20:50:00'),
(12, 'UPI', 'TXN10012', 438.00, 'SUCCESS', '2026-11-10 13:31:00'),

(13, 'UPI', 'TXN10013', 538.00, 'SUCCESS', '2026-11-13 19:01:00'),

(14, 'UPI', 'TXN10014', 339.00, 'SUCCESS', '2026-11-14 08:01:00'),

(15, 'CASH_ON_DELIVERY', NULL, 223.00, 'PENDING', '2026-11-14 08:30:00');

/*
------------------Creating table refunds
*/
CREATE TABLE IF NOT EXISTS refunds (
   refund_id INT AUTO_INCREMENT PRIMARY KEY,
   payment_id INT NOT NULL,
   order_id INT NOT NULL,
   refund_amount DECIMAL(10,2) NOT NULL,
   refund_reason VARCHAR(255),
   refund_status VARCHAR(20) DEFAULT 'PENDING',
   refund_date DATETIME DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT fk_refund_payment
   FOREIGN KEY (payment_id)
   REFERENCES payments(payment_id),
   CONSTRAINT fk_refund_order
   FOREIGN KEY (order_id)
   REFERENCES orders(order_id),
   CONSTRAINT chk_refund_amount
   CHECK (refund_amount > 0),
   CONSTRAINT chk_refund_status
   CHECK (refund_status IN (
       'PENDING', 'PROCESSED', 'FAILED'
   ))
);

INSERT INTO refunds
(payment_id, order_id, refund_amount,
 refund_reason, refund_status, refund_date)
VALUES
(3, 3, 332.00,
 'Customer cancelled before food preparation',
 'PROCESSED',
 '2026-07-01 10:00:00'),

(6, 6, 100.00,
 'One item was missing from the order',
 'PROCESSED',
 '2026-08-23 10:30:00'),

(10, 10, 50.00,
 'Food arrived late',
 'PROCESSED',
 '2026-10-11 09:00:00');

/*
------------------creating table delivery partners
*/
CREATE TABLE IF NOT EXISTS delivery_partners (
   partner_id INT AUTO_INCREMENT PRIMARY KEY,
   partner_name VARCHAR(100) NOT NULL,
   mobile VARCHAR(15) NOT NULL UNIQUE,
   vehicle_type VARCHAR(50),
   vehicle_number VARCHAR(30),
   is_available BOOLEAN DEFAULT TRUE,
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO delivery_partners
(partner_name, mobile, vehicle_type, vehicle_number, is_available)
VALUES
('Suresh Kumar', '9200000001', 'BIKE', 'TS09AB1234', TRUE),
('Ravi Reddy', '9200000002', 'SCOOTER', 'TS10CD4567', TRUE),
('Imran Khan', '9200000003', 'BIKE', 'TS11EF7890', FALSE),
('Mahesh Rao', '9200000004', 'E-BIKE', 'TS12GH1111', TRUE),
('Deepak Singh', '9200000005', 'BIKE', 'TS13IJ2222', TRUE);

/*
-----------------creatign table deliveries
*/
CREATE TABLE IF NOT EXISTS deliveries (
   delivery_id INT AUTO_INCREMENT PRIMARY KEY,
   order_id INT NOT NULL,
   partner_id INT NOT NULL,
   assignment_status VARCHAR(20) DEFAULT 'ASSIGNED',
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
   CONSTRAINT chk_assignment_status
   CHECK (assignment_status IN (
       'ASSIGNED', 'ACCEPTED', 'REJECTED',
       'PICKED_UP', 'DELIVERED', 'CANCELLED'
   ))
);

INSERT INTO deliveries
(order_id, partner_id, assignment_status,
 assigned_at, accepted_at,
 pickup_time, delivery_time,
 estimated_delivery_time)
VALUES

(1, 1, 'DELIVERED',
 '2026-06-10 13:20:00',
 '2026-06-10 13:22:00',
 '2026-06-10 13:40:00',
 '2026-06-10 14:05:00',
 '2026-06-10 14:00:00'),

(2, 2, 'DELIVERED',
 '2026-06-15 20:35:00',
 '2026-06-15 20:37:00',
 '2026-06-15 21:00:00',
 '2026-06-15 21:30:00',
 '2026-06-15 21:20:00'),

(4, 4, 'DELIVERED',
 '2026-07-10 19:50:00',
 '2026-07-10 19:52:00',
 '2026-07-10 20:15:00',
 '2026-07-10 20:40:00',
 '2026-07-10 20:35:00'),

(5, 1, 'DELIVERED',
 '2026-08-05 08:35:00',
 '2026-08-05 08:37:00',
 '2026-08-05 08:55:00',
 '2026-08-05 09:20:00',
 '2026-08-05 09:25:00'),

(6, 3, 'DELIVERED',
 '2026-08-22 21:05:00',
 '2026-08-22 21:08:00',
 '2026-08-22 21:35:00',
 '2026-08-22 22:20:00',
 '2026-08-22 22:00:00'),

(13, 2, 'PICKED_UP',
 '2026-11-13 19:05:00',
 '2026-11-13 19:07:00',
 '2026-11-13 19:35:00',
 NULL,
 '2026-11-13 20:00:00'),

(14, 5, 'ACCEPTED',
 '2026-11-14 08:05:00',
 '2026-11-14 08:07:00',
 NULL,
 NULL,
 '2026-11-14 08:50:00');

/*
-------------creating order history status table
*/
CREATE TABLE IF NOT EXISTS order_status_history (
   history_id INT AUTO_INCREMENT PRIMARY KEY,
   order_id INT NOT NULL,
   order_status VARCHAR(30) NOT NULL,
   status_description VARCHAR(255),
   changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT fk_status_order
   FOREIGN KEY (order_id)
   REFERENCES orders(order_id),
   CONSTRAINT chk_history_status
   CHECK (order_status IN (
       'PLACED', 'CONFIRMED', 'PREPARING',
       'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY',
       'DELIVERED', 'CANCELLED'
   ))
);

INSERT INTO order_status_history
(order_id, order_status, status_description, changed_at)
VALUES

(1, 'PLACED', 'Order placed by customer', '2026-06-10 13:15:00'),
(1, 'CONFIRMED', 'Restaurant confirmed order', '2026-06-10 13:18:00'),
(1, 'PREPARING', 'Restaurant started preparation', '2026-06-10 13:25:00'),
(1, 'READY_FOR_PICKUP', 'Food ready for pickup', '2026-06-10 13:38:00'),
(1, 'OUT_FOR_DELIVERY', 'Order picked up', '2026-06-10 13:40:00'),
(1, 'DELIVERED', 'Order delivered successfully', '2026-06-10 14:05:00'),

(3, 'PLACED', 'Order placed by customer', '2026-07-01 09:00:00'),
(3, 'CONFIRMED', 'Restaurant confirmed order', '2026-07-01 09:05:00'),
(3, 'CANCELLED', 'Customer cancelled order', '2026-07-01 09:15:00'),

(13, 'PLACED', 'Order placed by customer', '2026-11-13 19:00:00'),
(13, 'CONFIRMED', 'Restaurant confirmed order', '2026-11-13 19:05:00'),
(13, 'PREPARING', 'Restaurant preparing order', '2026-11-13 19:10:00'),
(13, 'READY_FOR_PICKUP', 'Food ready', '2026-11-13 19:30:00'),
(13, 'OUT_FOR_DELIVERY', 'Delivery partner picked up order', '2026-11-13 19:35:00'),

(14, 'PLACED', 'Order placed by customer', '2026-11-14 08:00:00'),
(14, 'CONFIRMED', 'Restaurant confirmed order', '2026-11-14 08:05:00'),
(14, 'PREPARING', 'Food is being prepared', '2026-11-14 08:10:00'),

(15, 'PLACED', 'Order placed successfully', '2026-11-14 08:30:00');

/*
-----------------creating table reviews
*/
CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    restaurant_id INT,
    menu_item_id INT,
    rating INT NOT NULL,
    review_comment VARCHAR(500),
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
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
    CONSTRAINT chk_review_rating
    CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT chk_review_target
    CHECK (
        (restaurant_id IS NOT NULL AND menu_item_id IS NULL)
        OR
        (restaurant_id IS NULL AND menu_item_id IS NOT NULL)
    )
);

INSERT INTO reviews
(customer_id, order_id, restaurant_id,
 menu_item_id, rating, review_comment, review_date)
VALUES

-- Restaurant reviews
(1, 1, 1, NULL, 5,
 'Amazing biryani and fast delivery.',
 '2026-06-10 18:00:00'),

(2, 2, 2, NULL, 4,
 'Pizza was good but delivery was slightly late.',
 '2026-06-16 10:00:00'),

(5, 6, 4, NULL, 3,
 'Food tasted good but one item was missing.',
 '2026-08-23 09:30:00'),

-- Menu item reviews
(1, 4, NULL, 6, 5,
 'Farmhouse pizza was excellent.',
 '2026-07-11 09:00:00'),

(4, 5, NULL, 9, 4,
 'Masala dosa was crispy and tasty.',
 '2026-08-05 12:00:00'),

(6, 8, NULL, 18, 5,
 'Chicken protein bowl was fresh and filling.',
 '2026-09-18 18:00:00');

/*
------------------- creating table Coupons
*/
 
CREATE TABLE IF NOT EXISTS coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_code VARCHAR(50) NOT NULL UNIQUE,
    discount_type VARCHAR(20) NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    minimum_order_value DECIMAL(10,2) DEFAULT 0,
    maximum_discount DECIMAL(10,2),
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    total_usage_limit INT,
    usage_limit_per_customer INT,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_coupon_type
    CHECK (discount_type IN ('PERCENTAGE', 'FIXED')),
    CONSTRAINT chk_coupon_discount
    CHECK (discount_value > 0),
    CONSTRAINT chk_coupon_dates
    CHECK (end_date > start_date),
    CONSTRAINT chk_coupon_limits
    CHECK (
        minimum_order_value >= 0 AND
        (maximum_discount IS NULL OR maximum_discount >= 0) AND
        (total_usage_limit IS NULL OR total_usage_limit > 0) AND
        (usage_limit_per_customer IS NULL OR usage_limit_per_customer > 0)
    )
);

INSERT INTO coupons
(coupon_code, discount_type, discount_value,
 minimum_order_value, maximum_discount,
 start_date, end_date,
 total_usage_limit, usage_limit_per_customer,
 is_active)
VALUES

('WELCOME100', 'FIXED', 100.00,
 299.00, NULL,
 '2026-01-01 00:00:00',
 '2026-12-31 23:59:59',
 10000, 1, TRUE),

('FOOD20', 'PERCENTAGE', 20.00,
 499.00, 150.00,
 '2026-01-01 00:00:00',
 '2026-12-31 23:59:59',
 5000, 5, TRUE),

('BIRYANI50', 'FIXED', 50.00,
 250.00, NULL,
 '2026-01-01 00:00:00',
 '2026-12-31 23:59:59',
 2000, 2, TRUE),

('WEEKEND15', 'PERCENTAGE', 15.00,
 399.00, 100.00,
 '2026-01-01 00:00:00',
 '2026-12-31 23:59:59',
 10000, 10, TRUE),

('EXPIRED50', 'PERCENTAGE', 50.00,
 500.00, 250.00,
 '2025-01-01 00:00:00',
 '2025-12-31 23:59:59',
 1000, 1, FALSE);
 
 /*
------------------creating table coupon_redemptions
*/
 
CREATE TABLE IF NOT EXISTS coupon_redemptions (
    redemption_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    discount_applied DECIMAL(10,2) NOT NULL,
    redeemed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_redemption_coupon
    FOREIGN KEY (coupon_id)
    REFERENCES coupons(coupon_id),
    CONSTRAINT fk_redemption_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),
    CONSTRAINT fk_redemption_order
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
    CONSTRAINT uq_coupon_order
    UNIQUE (coupon_id, order_id),
    CONSTRAINT chk_redemption_discount
    CHECK (discount_applied >= 0)
);

INSERT INTO coupon_redemptions
(coupon_id, customer_id, order_id,
 discount_applied, redeemed_at)
VALUES
(1, 1, 1, 100.00, '2026-06-10 13:15:00'),
(3, 1, 4, 50.00, '2026-07-10 19:45:00'),
(2, 5, 6, 75.00, '2026-08-22 21:00:00'),
(3, 2, 7, 50.00, '2026-09-05 14:20:00'),
(4, 8, 10, 30.00, '2026-10-10 08:45:00'),
(4, 1, 11, 50.00, '2026-11-01 20:00:00');

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM customer_addresses;
SELECT COUNT(*) FROM restaurants;
SELECT COUNT(*) FROM restaurant_operating_hours;
SELECT COUNT(*) FROM food_categories;
SELECT COUNT(*) FROM menu_items;
SELECT COUNT(*) FROM carts;
SELECT COUNT(*) FROM cart_items;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM refunds;
SELECT COUNT(*) FROM delivery_partners;
SELECT COUNT(*) FROM deliveries;
SELECT COUNT(*) FROM order_status_history;
SELECT COUNT(*) FROM reviews;
SELECT COUNT(*) FROM coupons;
SELECT COUNT(*) FROM coupon_redemptions;

/*
-------------SOLUTION OF THE GIVEN QUESTIONS ARE STARTING FROM BELOW
*/


/*
--------------QUESTION 1 ----ALL REGISTERED CUSTOMERS
*/

SELECT * FROM customers;

/*
--------------QUESTION 2 ----ALL ACTIVE RESTAURANTS
*/

SELECT *
FROM restaurants
WHERE is_active = TRUE;

/*
--------------QUESTION 3 ---- FIND VEGETERIAN FOOD ITEMS
*/
 
SELECT *
FROM menu_items
WHERE is_vegetarian = TRUE;

/*
--------------QUESTION 4 ---- DISPLAY FOOD ITEMS BELONGING TO A PERTICULAR RESTAURANT
*/
SELECT r.restaurant_name, m.food_name,m.price, m.is_vegetarian, m.is_available
FROM restaurants r
INNER JOIN menu_items m ON r.restaurant_id = m.restaurant_id
WHERE r.restaurant_name = 'Paradise Biryani';

/*
---   OR 
*/

SELECT r.restaurant_name, m.food_name,m.price, m.is_vegetarian, m.is_available
FROM restaurants r
INNER JOIN menu_items m ON r.restaurant_id = m.restaurant_id
WHERE r.restaurant_name ='Green Bowl';

/*
--------------QUESTION 5 ---- FOOD PRICE > 200
*/
SELECT m.menu_item_id AS food_id, m.food_name, r.restaurant_name, m.price
FROM menu_items m
INNER JOIN restaurants r ON m.restaurant_id = r.restaurant_id
WHERE m.price > 200
ORDER BY m.price DESC;

/*
--------------QUESTION 6 ----DISPLAY ALL ORDER PLACED BY A PERTICULAR CUSTOMER
*/
SELECT * FROM orders
WHERE customer_id = 1;

/*
--------------QUESTION 7 ----FIND ALL ORDERS PLACED ON A PERTICULAR DATE
*/

SELECT order_id, customer_id, restaurant_id, delivery_pincode, total_amount, order_status FROM orders
WHERE DATE(order_date) = '2026-11-13';

/*
--------------QUESTION 8 -----DISPLAY ALL AVAILBLE DELIVERY PARTNERS
*/
SELECT * FROM delivery_partners
WHERE is_available = TRUE;

/*
--------------QUESTION 9 -----DISPLAY CUSTOMER DETAIL ALONG WITH THEIR DELIVERY ADDRESS
*/

SELECT c.customer_id, c.first_name, c.last_name, c.email, c.mobile, ca.address_line1,
       ca.address_line2, ca.city, ca.state, ca.pincode, ca.address_type, ca.is_default
FROM customers c
INNER JOIN customer_addresses ca USING (customer_id);

/*
--------------QUESTION 10 -----DISPLAY RESTAURANTS NAME ALONG WITH THEIR FOOD MENU
*/

SELECT r.restaurant_id, r.restaurant_name, m.menu_item_id, m.food_name, m.price, m.is_vegetarian, m.is_available
FROM restaurants r
INNER JOIN menu_items m ON r.restaurant_id = m.restaurant_id
ORDER BY r.restaurant_name;

/*
--------------QUESTION 11 -----DISPLAY COMPLETE ORDER DETAILS, INCLUDING CUSTOMER AND RESTAURANT INFORMATION
*/

SELECT o.order_id, o.order_date, o.order_status,
       c.customer_id, c.first_name, c.last_name, c.email, c.mobile,
       r.restaurant_id, r.restaurant_name, r.contact_number,
       o.delivery_address_line1, o.delivery_address_line2, o.delivery_city, 
		 o.delivery_state, o.delivery_pincode, o.subtotal, o.delivery_charge, o.discount_amount, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id
ORDER BY o.order_date;

/*
-------------QUESTION 12 -----FIND THE TOTAL NUMBER OF ORDERED PLACED BY EACH CUSTOMER
*/

SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

/*
-------------QUESTION 13 -----FIND THE TOTAL NUMBER OF ITEMS AVAILABLE IN EACH RESTAURANT
*/

SELECT r.restaurant_id, r.restaurant_name, COUNT(m.menu_item_id) AS total_available_items
FROM restaurants r
INNER JOIN menu_items m ON r.restaurant_id = m.restaurant_id
WHERE m.is_available = TRUE
GROUP BY r.restaurant_id;

/*
-------------QUESTION 14 -----CALCULATE THE TOTAL SALES GENERATED BY EACH RESTAURANT
*/

SELECT r.restaurant_id, r.restaurant_name, SUM(o.total_amount) AS total_sales
FROM restaurants r
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'DELIVERED'
GROUP BY r.restaurant_id;

/*
-------------QUESTION 15 -----FIND THE MOST FREQUENTLY ORDERED ITEM
*/
SELECT menu_item_id, food_name_snapshot AS food_name, SUM(quantity) AS total_quantity_ordered
FROM order_items
GROUP BY menu_item_id, food_name_snapshot
ORDER BY total_quantity_ordered DESC
LIMIT 1;

/*
-------------QUESTION 16 -----CUSTOMER WITH NO ORDER 
*/
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

/*
-------------QUESTION 17 -----DISPLAY DELIVERY PARTNER WHO HAVE COMPLETED MORE THAN ONE DELIVERIES
*/
SELECT 
    dp.partner_id,
    dp.partner_name,
    COUNT(d.delivery_id) AS total_deliveries
FROM delivery_partners dp
INNER JOIN deliveries d
    ON dp.partner_id = d.partner_id
WHERE d.assignment_status = 'DELIVERED'
GROUP BY dp.partner_id, dp.partner_name
HAVING COUNT(d.delivery_id) > 1
ORDER BY total_deliveries DESC;

/*
-------------QUESTION 18 -----FIND THE AVERAGE RATING OF EACH RESTAURANT
*/
SELECT r.restaurant_id, r.restaurant_name, AVG(rv.rating) AS average_rating
FROM restaurants r
INNER JOIN reviews rv ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id;

/*
-------------QUESTION 19 -----CUSTOMER WHO HAS SPENT HIGHEST AMOUNT ON ORDERS
*/
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'DELIVERED'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

/*
-------------QUESTION 20 -----RESTAURANT WHO GENERATED HIGHEST REVENUE
*/
SELECT r.restaurant_id, r.restaurant_name, SUM(o.total_amount) AS total_revenue
FROM restaurants r
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'DELIVERED'
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 1;

/*
-------------QUESTION 21 -----FIND THE SECOND MOST EXPENSIVE FOOD ITEM
*/
SELECT menu_item_id, food_name, price
FROM menu_items
ORDER BY price DESC
LIMIT 1 OFFSET 1;

/*
-------------QUESTION 22 -----FIND THE RESTAURANT WHOSE AVERAGE RATING IS GREATER THAN OVERALL AVERAGE RATING
*/

SELECT AVG(rating) FROM reviews WHERE restaurant_id IS NOT NULL;

SELECT r.restaurant_id, r.restaurant_name, AVG(rv.rating) AS average_rating
FROM restaurants r
INNER JOIN reviews rv ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING AVG(rv.rating) > ( 
    SELECT AVG(rating) FROM reviews WHERE restaurant_id IS NOT NULL
);

/*
-------------QUESTION 23 -----CUSTOMER WITH MORE THEN AVERAGE ORDER
*/
SELECT AVG(order_count)
    FROM (
	      SELECT COUNT(*) AS order_count 
			FROM orders 
			GROUP BY customer_id
    ) AS customer_orders;
    
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
	      SELECT COUNT(*) AS order_count 
			FROM orders 
			GROUP BY customer_id
    ) AS customer_orders
);

/*
-------------QUESTION 24 -----FOOD ITEM WHICH HAS NEVER BEEN ORDERED
*/
SELECT m.menu_item_id, m.food_name, m.price
FROM menu_items m
LEFT JOIN order_items oi ON m.menu_item_id = oi.menu_item_id
WHERE oi.order_item_id IS NULL;

/*
-------------QUESTION 25 -----TOP THREE BEST SELLING ITEM
*/
SELECT oi.menu_item_id, oi.food_name_snapshot AS food_name, SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
GROUP BY oi.menu_item_id, oi.food_name_snapshot
ORDER BY total_quantity_sold DESC
LIMIT 3;

/*
-------------QUESTION 26 -----IDENTIFY CUSTOMER WHO HAVE USED PROMOTIONAL COUPONS
*/
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
       cp.coupon_code, cr.discount_applied, cr.redeemed_at
FROM customers c
INNER JOIN coupon_redemptions cr ON c.customer_id = cr.customer_id
INNER JOIN coupons cp ON cr.coupon_id = cp.coupon_id;


/*
-------------QUESTION 27 -----RESTAURANTS WITH ZERO ORDER
*/
SELECT r.restaurant_id, r.restaurant_name
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
WHERE o.order_id IS NULL;

/*
-------------QUESTION 28 -----RESTAURANTS MONTHLY REVENUE REPORT
*/
SELECT r.restaurant_id, r.restaurant_name,
    YEAR(o.order_date) AS order_year,
    MONTHNAME(o.order_date) AS order_month,
    SUM(o.total_amount) AS monthly_revenue
FROM restaurants r
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'DELIVERED'
GROUP BY r.restaurant_id, r.restaurant_name,
    YEAR(o.order_date),
    MONTH(o.order_date),
    MONTHNAME(o.order_date)
ORDER BY
    YEAR(o.order_date),
    MONTH(o.order_date),
    r.restaurant_name;
    
/*
-------------QUESTION 29 ----- DELIVERY PARTNER WITH HIGHEST NUMBER OF DELIVERED ORDER
*/
SELECT dp.partner_id, dp.partner_name,
    COUNT(d.delivery_id) AS completed_deliveries
FROM delivery_partners dp
INNER JOIN deliveries d ON dp.partner_id = d.partner_id
WHERE d.assignment_status = 'DELIVERED'
GROUP BY dp.partner_id, dp.partner_name
ORDER BY completed_deliveries DESC
LIMIT 1;

/*
-------------QUESTION 30 -----CUSTOMER WHO ORDERED BUT NEVER SUBMITTED REVIEW
*/
SELECT DISTINCT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN reviews r ON c.customer_id = r.customer_id
WHERE r.review_id IS NULL;

SHOW DATABASES;




