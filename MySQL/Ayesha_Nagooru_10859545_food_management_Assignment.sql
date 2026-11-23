/* Ayesha Nagooru

 10859545*/
 
 /*Database creation */
 /*Module 1: Customer Management DATABASE creation*/

CREATE DATABASE food_delivery_db;

USE food_delivery_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mobile_number VARCHAR(15) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customer_addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    address_line1 VARCHAR(200) NOT NULL,
    address_line2 VARCHAR(200),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    address_type VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    delivery_address_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    order_status VARCHAR(30) DEFAULT 'PLACED',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (delivery_address_id)
        REFERENCES customer_addresses(address_id)
);

INSERT INTO customers
(customer_name, email, mobile_number, password)
VALUES
('john', 'john@email.com', '9876543210', 'Password123');


INSERT INTO customer_addresses
(customer_id, address_line1, city, state, postal_code, address_type, is_default)
VALUES
(1, 'Madhapur', 'Hyderabad', 'Telangana', '500081', 'Home', TRUE);

INSERT INTO customer_addresses
(customer_id, address_line1, city, state, postal_code, address_type, is_default)
VALUES
(1, 'HITEC City', 'Hyderabad', 'Telangana', '500081', 'Office', FALSE);

SELECT *
FROM customer_addresses
WHERE customer_id = 1;

SELECT * FROM customer_addresses;

SELECT * FROM customers;

/*Module 2: Restaurant Management* databse creation*/

CREATE DATABASE food_delivery_restaurant_db;

USE food_delivery_restaurant_db;

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(10),
    contact_number VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE,
    status VARCHAR(20) DEFAULT 'Active',
    rating DECIMAL(2,1) DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE restaurant_operating_hours (
    operating_hour_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    day_of_week VARCHAR(10) NOT NULL,
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    is_closed BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);


INSERT INTO restaurants
(restaurant_name, address, city, state, postal_code,
 contact_number, email, status, rating)
VALUES
('Paradise Biryani', 'Hitech City', 'Hyderabad',
 'Telangana', '500081', '9876543210',
 'paradise@example.com', 'Active', 4.5);
 
 
 
 INSERT INTO restaurants
(restaurant_name, address, city, state, postal_code,
 contact_number, email, status, rating)
VALUES
('Spice Garden', 'Madhapur', 'Hyderabad',
 'Telangana', '500081', '9876543211',
 'spice@example.com', 'Active', 4.2);
 
 
 
 INSERT INTO restaurant_operating_hours
(restaurant_id, day_of_week, opening_time, closing_time)
VALUES
(1, 'Monday', '09:00:00', '22:00:00'),
(1, 'Tuesday', '09:00:00', '22:00:00'),
(1, 'Wednesday', '09:00:00', '22:00:00'),
(1, 'Thursday', '09:00:00', '22:00:00'),
(1, 'Friday', '09:00:00', '23:00:00'),
(1, 'Saturday', '10:00:00', '23:00:00'),
(1, 'Sunday', '10:00:00', '22:00:00');


SELECT *
FROM restaurants
WHERE status = 'Active';

/*Module 3: Food Category Management*/
CREATE DATABASE food_category_db;

USE food_category_db;

CREATE TABLE food_categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE food_items (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    is_vegetarian BOOLEAN DEFAULT TRUE,
    status VARCHAR(20) DEFAULT 'Available',

    FOREIGN KEY (category_id)
        REFERENCES food_categories(category_id)
);

INSERT INTO food_categories (category_name, description)
VALUES
('South Indian', 'Traditional South Indian dishes'),
('North Indian', 'Traditional North Indian dishes'),
('Chinese', 'Chinese food items'),
('Fast Food', 'Quick service and fast food items'),
('Desserts', 'Sweets and dessert items'),
('Beverages', 'Hot and cold beverages');


INSERT INTO food_items
(food_name, category_id, price, is_vegetarian)
VALUES
('Masala Dosa', 1, 120.00, TRUE),
('Idli', 1, 60.00, TRUE),
('Paneer Butter Masala', 2, 240.00, TRUE),
('Butter Chicken', 2, 300.00, FALSE),
('Veg Fried Rice', 3, 180.00, TRUE),
('Chicken Noodles', 3, 220.00, FALSE),
('Veg Burger', 4, 150.00, TRUE),
('Chicken Burger', 4, 190.00, FALSE),
('Chocolate Cake', 5, 130.00, TRUE),
('Ice Cream', 5, 100.00, TRUE),
('Coffee', 6, 80.00, TRUE),
('Fresh Lime Soda', 6, 70.00, TRUE);
SELECT * FROM food_items;
SELECT * FROM food_categories;

/*Module 4: Food Menu Management* database creation*/
CREATE DATABASE food_menu_db;

USE food_menu_db;

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_name VARCHAR(100) NOT NULL,
    location VARCHAR(150) NOT NULL,
    status VARCHAR(20) DEFAULT 'Active'
);


CREATE TABLE food_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE food_item (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    food_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    food_type VARCHAR(20) NOT NULL,
    availability_status VARCHAR(20) DEFAULT 'Available',

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    FOREIGN KEY (category_id)
      
	  REFERENCES food_categories(category_id)
);

INSERT INTO food_category (category_name)
VALUES
('South Indian'),
('North Indian'),
('Chinese'),
('Fast Food'),
('Desserts'),
('Beverages');

INSERT INTO restaurants
(restaurant_name, location, status)
VALUES
('Spice Garden', 'Madhapur', 'Active'),
('Food Paradise', 'Hitech City', 'Active'),
('Royal Kitchen', 'Gachibowli', 'Active');


INSERT INTO food_item
(restaurant_id, category_id, food_name, description,
 price, food_type, availability_status)
VALUES
(1, 1, 'Masala Dosa', 'Crispy dosa with potato masala',
 120.00, 'Vegetarian', 'Available'),

(1, 2, 'Paneer Butter Masala', 'Paneer cooked in creamy tomato gravy',
 250.00, 'Vegetarian', 'Available'),

(1, 2, 'Chicken Biryani', 'Basmati rice cooked with chicken and spices',
 300.00, 'Non-Vegetarian', 'Available'),

(2, 3, 'Veg Fried Rice', 'Fried rice prepared with mixed vegetables',
 180.00, 'Vegetarian', 'Available'),

(2, 3, 'Chicken Noodles', 'Noodles prepared with chicken and vegetables',
 220.00, 'Non-Vegetarian', 'Available'),

(2, 4, 'Veg Burger', 'Burger with vegetable patty',
 150.00, 'Vegetarian', 'Unavailable'),

(3, 5, 'Chocolate Cake', 'Chocolate-flavoured dessert cake',
 140.00, 'Vegetarian', 'Available'),

(3, 6, 'Cold Coffee', 'Chilled coffee beverage',
 100.00, 'Vegetarian', 'Available');

SELECT * FROM food_item;

/*Module 5: Shopping Cart Management databse creation*/
CREATE DATABASE food_cart_db;

USE food_cart_db;


CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mobile_number VARCHAR(15) NOT NULL
);

CREATE TABLE fooditems (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    food_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    availability_status VARCHAR(20) DEFAULT 'Available'
);
CREATE TABLE cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE cart_items (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,

    FOREIGN KEY (cart_id)
        REFERENCES cart(cart_id),

    FOREIGN KEY (food_id)
        REFERENCES fooditems(food_id),

    UNIQUE (cart_id, food_id)
);



INSERT INTO customers
(customer_name, email, mobile_number)
VALUES
('Ayesha', 'ayesha@example.com', '9876543210'),
('Rahul', 'rahul@example.com', '9876543211'),
('Priya', 'priya@example.com', '9876543212');

INSERT INTO fooditems
(food_name, price, availability_status)
VALUES
('Masala Dosa', 120.00, 'Available'),
('Paneer Biryani', 220.00, 'Available'),
('Chicken Biryani', 280.00, 'Available'),
('Veg Burger', 150.00, 'Available'),
('Chicken Burger', 190.00, 'Unavailable'),
('Chocolate Cake', 130.00, 'Available'),
('Cold Coffee', 100.00, 'Available');

INSERT INTO cart (customer_id)
VALUES (1), (2), (3);

/*Module 6: Order Management database creation*/

CREATE DATABASE food_order_db;

USE food_order_db;


CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mobile_number VARCHAR(15) NOT NULL
);

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_name VARCHAR(100) NOT NULL,
    location VARCHAR(150) NOT NULL
);

CREATE TABLE food_items (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    food_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    availability_status VARCHAR(20) DEFAULT 'Available',

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date_time DATETIME DEFAULT CURRENT_TIMESTAMP,

    subtotal DECIMAL(10,2) DEFAULT 0.00,
    delivery_charge DECIMAL(10,2) DEFAULT 0.00,
    discount DECIMAL(10,2) DEFAULT 0.00,
    final_amount DECIMAL(10,2) DEFAULT 0.00,

    order_status ENUM(
        'PLACED',
        'CONFIRMED',
        'PREPARING',
        'OUT_FOR_DELIVERY',
        'DELIVERED',
        'REJECTED',
        'CANCELLED'
    ) DEFAULT 'PLACED',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity INT NOT NULL,
    item_price DECIMAL(10,2) NOT NULL,
    item_total DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (food_id)
        REFERENCES food_items(food_id)
);

INSERT INTO customers
(customer_name, email, mobile_number)
VALUES
('john', 'john@example.com', '9876543210'),
('smith', 'smith@example.com', '9876543211'),
('rahul', 'rahul@example.com', '9876543212');


INSERT INTO restaurants
(restaurant_name, location)
VALUES
('botanical Garden', 'Bangalore'),
('Paradise', 'jpnagar'),
('Royal Kitchen', 'mgroad');

INSERT INTO food_items
(restaurant_id, food_name, price, availability_status)
VALUES
(1, 'Masala Dosa', 120.00, 'Available'),
(1, 'Paneer Biryani', 220.00, 'Available'),
(1, 'Chicken Biryani', 280.00, 'Available'),
(2, 'Veg Fried Rice', 180.00, 'Available'),
(2, 'Chicken Noodles', 220.00, 'Available'),
(3, 'Chocolate Cake', 140.00, 'Available');

/*Module 7: Payment Management */


CREATE DATABASE food_payment_db;

USE food_payment_db;


CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mobile_number VARCHAR(15) NOT NULL
);



CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    final_amount DECIMAL(10,2) NOT NULL,
    order_status ENUM(
        'PLACED',
        'CONFIRMED',
        'CANCELLED',
        'DELIVERED'
    ) DEFAULT 'PLACED',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    transaction_reference VARCHAR(100) UNIQUE,
    
    payment_method ENUM(
        'UPI',
        'CREDIT_CARD',
        'DEBIT_CARD',
        'CASH_ON_DELIVERY'
    ) NOT NULL,
    
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    payment_status ENUM(
        'PENDING',
        'SUCCESS',
        'FAILED',
        'REFUNDED'
    ) DEFAULT 'PENDING',

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


CREATE TABLE refunds (
    refund_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_id INT NOT NULL,
    refund_reference VARCHAR(100) UNIQUE NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL,
    refund_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    refund_status ENUM(
        'PENDING',
        'SUCCESS',
        'FAILED'
    ) DEFAULT 'PENDING',

    reason VARCHAR(255),

    FOREIGN KEY (payment_id)
        REFERENCES payments(payment_id)
);


INSERT INTO customers
(customer_name, email, mobile_number)
VALUES
('karthik', 'karthik@example.com', '9876543210'),
('seeta', 'seeta@example.com', '9396573972'),
('geetha', 'geetha@example.com', '9876543212');

INSERT INTO orders
(customer_id, final_amount, order_status)
VALUES
(1, 510.00, 'CONFIRMED'),
(2, 350.00, 'CONFIRMED'),
(3, 620.00, 'PLACED');

INSERT INTO payments
(order_id, transaction_reference, payment_method,
 payment_amount, payment_status)
VALUES
(1, 'UPI-TXN-1001', 'UPI', 510.00, 'SUCCESS');

INSERT INTO payments
(order_id, transaction_reference, payment_method,
 payment_amount, payment_status)
VALUES
(2, 'CC-TXN-1002', 'CREDIT_CARD', 350.00, 'SUCCESS');


INSERT INTO payments
(order_id, transaction_reference, payment_method,
 payment_amount, payment_status)
VALUES
(3, 'DC-TXN-1003', 'DEBIT_CARD', 620.00, 'FAILED');

INSERT INTO payments
(order_id, transaction_reference, payment_method,
 payment_amount, payment_status)
VALUES
(3, 'UPI-TXN-1004', 'UPI', 620.00, 'SUCCESS');

/*Module 8: Delivery Partner Management*/
CREATE DATABASE food_delivery_partner_db;

USE food_delivery_partner_db;

CREATE TABLE delivery_partners (
    partner_id INT PRIMARY KEY AUTO_INCREMENT,
    partner_name VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL UNIQUE,
    vehicle_type VARCHAR(50) NOT NULL,
    vehicle_number VARCHAR(30) NOT NULL UNIQUE,

    availability_status ENUM(
        'AVAILABLE',
        'BUSY',
        'INACTIVE'
    ) DEFAULT 'AVAILABLE',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    restaurant_name VARCHAR(100) NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    order_amount DECIMAL(10,2) NOT NULL,

    order_status ENUM(
        'CONFIRMED',
        'PREPARING',
        'READY_FOR_PICKUP',
        'OUT_FOR_DELIVERY',
        'DELIVERED',
        'CANCELLED'
    ) DEFAULT 'CONFIRMED',

    order_date DATETIME DEFAULT CURRENT_TIMESTAMP
);




CREATE TABLE delivery_assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    partner_id INT NOT NULL,

    assignment_status ENUM(
        'ASSIGNED',
        'ACCEPTED',
        'REJECTED',
        'PICKED_UP',
        'DELIVERED'
    ) DEFAULT 'ASSIGNED',

    assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    accepted_at DATETIME NULL,
    pickup_time DATETIME NULL,
    delivery_time DATETIME NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (partner_id)
        REFERENCES delivery_partners(partner_id)
);

INSERT INTO delivery_partners
(partner_name, mobile_number, vehicle_type,
 vehicle_number, availability_status)
VALUES
('Ravi Kumar', '9876543210', 'Bike',
 'TS09AB1234', 'AVAILABLE'),

('Suresh Reddy', '9876543211', 'Scooter',
 'TS10CD5678', 'AVAILABLE'),

('Kiran Kumar', '9876543212', 'Bike',
 'TS08EF9012', 'AVAILABLE');
 
 SELECT * FROM delivery_partners;
 
INSERT INTO orders
(customer_name, restaurant_name, delivery_address,
 order_amount, order_status)
VALUES
('Ayesha', 'Spice Garden', 'Madhapur, Hyderabad',
 510.00, 'READY_FOR_PICKUP'),

('Rahul', 'Food Paradise', 'Hitech City, Hyderabad',
 350.00, 'READY_FOR_PICKUP'),

('Priya', 'Royal Kitchen', 'Gachibowli, Hyderabad',
 620.00, 'PREPARING');
 
 
 SELECT * FROM orders;
 
 /*Module 9: Order Tracking*/
 CREATE DATABASE food_order_tracking_db;

USE food_order_tracking_db;
 
 CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mobile_number VARCHAR(15) NOT NULL
);



CREATE TABLE delivery_partners (
    partner_id INT PRIMARY KEY AUTO_INCREMENT,
    partner_name VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL UNIQUE,
    vehicle_number VARCHAR(30) NOT NULL
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    partner_id INT,
    restaurant_name VARCHAR(100) NOT NULL,
    delivery_address VARCHAR(255) NOT NULL,
    order_date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    estimated_delivery_time DATETIME,

    order_status ENUM(
        'PLACED',
        'CONFIRMED',
        'PREPARING',
        'READY_FOR_PICKUP',
        'OUT_FOR_DELIVERY',
        'DELIVERED',
        'CANCELLED'
    ) DEFAULT 'PLACED',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (partner_id)
        REFERENCES delivery_partners(partner_id)
);




 CREATE TABLE order_status_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,

    order_status ENUM(
        'PLACED',
        'CONFIRMED',
        'PREPARING',
        'READY_FOR_PICKUP',
        'OUT_FOR_DELIVERY',
        'DELIVERED',
        'CANCELLED'
    ) NOT NULL,

    status_updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

INSERT INTO customers
(customer_name, email, mobile_number)
VALUES
('xyz', 'xyz@example.com', '9876543210'),
('ram', 'ram@example.com', '9876543211'),
('mrududla', 'mrududla@example.com', '9876543212');


INSERT INTO delivery_partners
(partner_name, mobile_number, vehicle_number)
VALUES
('Ravi Kumar', '9876500001', 'TS09AB1234'),
('Suresh Reddy', '9876500002', 'TS10CD5678'),
('Kiran Kumar', '9876500003', 'TS08EF9012');





INSERT INTO orders
(customer_id, partner_id, restaurant_name,
 delivery_address, estimated_delivery_time, order_status)
VALUES
(1, 1, 'Spice Garden',
 'Madhapur, Hyderabad',
 DATE_ADD(NOW(), INTERVAL 45 MINUTE),
 'PLACED'),

(2, 2, 'Food Paradise',
 'Hitech City, Hyderabad',
 DATE_ADD(NOW(), INTERVAL 40 MINUTE),
 'PLACED'),

(3, NULL, 'Royal Kitchen',
 'Gachibowli, Hyderabad',
 DATE_ADD(NOW(), INTERVAL 50 MINUTE),
 'PLACED');

INSERT INTO order_status_history
(order_id, order_status)
VALUES
(1, 'PLACED'),
(2, 'PLACED'),
(3, 'PLACED');

/*Module 10: Reviews and Ratings*/


CREATE DATABASE food_reviews_db;

USE food_reviews_db;


CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    mobile_number VARCHAR(15) NOT NULL UNIQUE
);
 
 
 CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_name VARCHAR(100) NOT NULL,
    location VARCHAR(150) NOT NULL
);
 
 CREATE TABLE food_items (
    food_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    food_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    order_status ENUM(
        'PLACED',
        'CONFIRMED',
        'PREPARING',
        'OUT_FOR_DELIVERY',
        'DELIVERED',
        'CANCELLED'
    ) DEFAULT 'PLACED',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    food_id INT NOT NULL,
    quantity INT NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (food_id)
        REFERENCES food_items(food_id),

    UNIQUE (order_id, food_id)
);




CREATE TABLE restaurant_reviews (
    restaurant_review_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating INT NOT NULL,
    feedback VARCHAR(500),
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    CHECK (rating BETWEEN 1 AND 5),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);
 
 
 
 CREATE TABLE food_reviews (
    food_review_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    food_id INT NOT NULL,
    rating INT NOT NULL,
    feedback VARCHAR(500),
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    CHECK (rating BETWEEN 1 AND 5),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (food_id)
        REFERENCES food_items(food_id),

    UNIQUE (order_id, food_id)
);
 
 
 
 INSERT INTO customers
(customer_name, email, mobile_number)
VALUES
('lakshmi', 'lakshmi@example.com', '9876543910'),
('james', 'james@example.com', '9876543211'),
('amar', 'amar@example.com', '9876543212');



INSERT INTO restaurants
(restaurant_name, location)
VALUES
('Spice Garden', 'Madhapur'),
('Food Paradise', 'Hitech City'),
('Royal Kitchen', 'Gachibowli');




INSERT INTO food_items
(restaurant_id, food_name, price)
VALUES
(1, 'Dosa', 120.00),
(1, 'Biryani', 280.00),
(1, 'Paneer Biryani', 220.00),
(2, 'Veg Fried Rice', 180.00),
(2, 'Chicken Noodles', 220.00),
(3, 'Paneer Butter Masala', 250.00);

/*Module 11: Coupon and Offers Management*/



CREATE DATABASE food_coupon_db;

USE food_coupon_db;


CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    final_amount DECIMAL(10,2) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE coupons (
    coupon_id INT PRIMARY KEY AUTO_INCREMENT,
    coupon_code VARCHAR(50) NOT NULL UNIQUE,
    coupon_description VARCHAR(255),

    discount_type ENUM(
        'PERCENTAGE',
        'FIXED'
    ) NOT NULL,

    discount_value DECIMAL(10,2) NOT NULL,

    valid_from DATE NOT NULL,
    valid_until DATE NOT NULL,

    minimum_order_value DECIMAL(10,2) DEFAULT 0.00,
    maximum_discount DECIMAL(10,2),

    total_usage_limit INT,
    usage_limit_per_customer INT DEFAULT 1,

    status ENUM(
        'ACTIVE',
        'INACTIVE'
    ) DEFAULT 'ACTIVE',

    CHECK (discount_value > 0),
    CHECK (valid_until >= valid_from)
);


 CREATE TABLE coupon_redemptions (
    redemption_id INT PRIMARY KEY AUTO_INCREMENT,
    coupon_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    discount_received DECIMAL(10,2) NOT NULL,
    redeemed_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (coupon_id)
        REFERENCES coupons(coupon_id),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);






INSERT INTO coupons
(
    coupon_code,
    coupon_description,
    discount_type,
    discount_value,
    valid_from,
    valid_until,
    minimum_order_value,
    maximum_discount,
    total_usage_limit,
    usage_limit_per_customer,
    status
)
VALUES
(
    'FOOD20',
    '20 percent discount on food orders',
    'PERCENTAGE',
    20,
    '2026-11-01',
    '2026-12-31',
    300,
    150,
    100,
    1,
    'ACTIVE'
),
(
    'SAVE100',
    'Flat Rs.100 discount',
    'FIXED',
    100,
    '2026-11-01',
    '2026-12-31',
    500,
    100,
    50,
    1,
    'ACTIVE'
),
(
    'WELCOME50',
    'Flat Rs.50 welcome discount',
    'FIXED',
    50,
    '2026-11-01',
    '2027-01-31',
    200,
    50,
    200,
    1,
    'ACTIVE'
);




/*Queries */


--Basic Level
-- 1. Display all registered customers

USE food_delivery_db;

SELECT *
FROM customers;
 

-- 2. Display all active restaurants

USE food_delivery_restaurant_db;

SELECT *
FROM restaurants
WHERE status = 'Active';

-- 3. Find all vegetarian food items

USE food_category_db;

SELECT *
FROM food_items
WHERE is_vegetarian = TRUE;


-- 4. Display food items belonging to a particular restaurant
 
USE food_menu_db;

SELECT
    r.restaurant_name,
    f.food_name,
    f.description,
    f.price,
    f.food_type,
    f.availability_status
FROM restaurants r
JOIN food_item f
    ON r.restaurant_id = f.restaurant_id
WHERE r.restaurant_name = 'Spice Garden';

-- 5. Find food items whose price is greater than ₹200
USE food_menu_db;

SELECT
    food_id,
    food_name,
    price
FROM food_item
WHERE price > 200;


-- 6. Display all orders placed by a particular customer

 
USE food_order_db;

SELECT
    o.order_id,
    c.customer_name,
    o.order_date_time,
    o.subtotal,
    o.delivery_charge,
    o.discount,
    o.final_amount,
    o.order_status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_name = 'john';
 

-- 7. Find all orders placed on a particular date

USE food_order_db;

SELECT *
FROM orders
WHERE DATE(order_date_time) = '2026-11-17';


-- 8. Display all available delivery partners
 
USE food_delivery_partner_db;

SELECT *
FROM delivery_partners
WHERE availability_status = 'AVAILABLE';

--9. Customer details with delivery addresses

SELECT
c.customer_id,
c.customer_name,
c.email,
c.phone,
ca.address_line,
ca.city,
ca.state,
ca.postal_code
FROM customers c
INNER JOIN customer_addresses ca
ON c.customer_id = ca.customer_id;


---10. Restaurant names with their food menu

SELECT
r.restaurant_id,
r.restaurant_name,
mi.menu_item_id,
mi.item_name,
mi.price,
mi.is_vegetarian,
mi.availability_status
FROM restaurants r
INNER JOIN menu_items mi
ON r.restaurant_id = mi.restaurant_id
ORDER BY r.restaurant_name, mi.item_name;

--11. Complete order details with customer and restaurant information


SELECT
o.order_id,
o.order_date,
o.order_status,
o.total_amount,
c.customer_id,
c.customer_name,
c.phone AS customer_phone,
r.restaurant_id,
r.restaurant_name,
r.phone AS restaurant_phone
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
INNER JOIN restaurants r
ON o.restaurant_id = r.restaurant_id
ORDER BY o.order_date DESC;


---12. Total orders placed by each customer


SELECT
c.customer_id,
c.customer_name,
COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
c.customer_id,
c.customer_name
ORDER BY total_orders DESC;



----13. Total food items available in each restaurant

SELECT
r.restaurant_id,
r.restaurant_name,
COUNT(mi.menu_item_id) AS total_food_items
FROM restaurants r
LEFT JOIN menu_items mi
ON r.restaurant_id = mi.restaurant_id
GROUP BY
r.restaurant_id,
r.restaurant_name
ORDER BY total_food_items DESC;


---14. Total sales generated by each restaurant

SELECT
r.restaurant_id,
r.restaurant_name,
COALESCE(SUM(o.total_amount), 0) AS total_sales
FROM restaurants r
LEFT JOIN orders o
ON r.restaurant_id = o.restaurant_id
AND o.order_status = 'Delivered'
GROUP BY
r.restaurant_id,
r.restaurant_name
ORDER BY total_sales DESC;


--15. Most frequently ordered food item

SELECT
mi.menu_item_id,
mi.item_name,
SUM(oi.quantity) AS total_quantity_ordered
FROM menu_items mi
INNER JOIN order_items oi
ON mi.menu_item_id = oi.menu_item_id
GROUP BY
mi.menu_item_id,
mi.item_name
ORDER BY total_quantity_ordered DESC
LIMIT 1;


--16. Customers who have never placed an order

SELECT
c.customer_id,
c.customer_name,
c.email,
c.phone
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--17. Delivery partners who completed more than five deliveries


SELECT
dp.delivery_partner_id,
dp.partner_name,
dp.phone,
COUNT(d.delivery_id) AS completed_deliveries
FROM delivery_partners dp
INNER JOIN deliveries d
ON dp.delivery_partner_id = d.delivery_partner_id
WHERE d.delivery_status = 'Delivered'
GROUP BY
dp.delivery_partner_id,
dp.partner_name,
dp.phone
HAVING COUNT(d.delivery_id) > 5
ORDER BY completed_deliveries DESC;

--18. Average rating of each restaurant

SELECT
r.restaurant_id,
r.restaurant_name,
ROUND(AVG(rv.rating), 2) AS average_rating
FROM restaurants r
LEFT JOIN reviews rv
ON r.restaurant_id = rv.restaurant_id
GROUP BY
r.restaurant_id,
r.restaurant_name
ORDER BY average_rating DESC;


---19. Customer who spent the highest amount

SELECT
c.customer_id,
c.customer_name,
SUM(o.total_amount) AS total_amount_spent
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY
c.customer_id,
c.customer_name
ORDER BY total_amount_spent DESC
LIMIT 1;

20. Restaurant that generated the highest revenue

SELECT
r.restaurant_id,
r.restaurant_name,
SUM(o.total_amount) AS total_revenue
FROM restaurants r
INNER JOIN orders o
ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY
r.restaurant_id,
r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 1;
---21. Second most expensive food item




WITH ranked_food_items AS (
SELECT
menu_item_id,
item_name,
price,
DENSE_RANK() OVER (ORDER BY price DESC) AS price_rank
FROM menu_items
)
SELECT
menu_item_id,
item_name,
price
FROM ranked_food_items
WHERE price_rank = 2;


--22. Restaurants with ratings above the overall average

SELECT
r.restaurant_id,
r.restaurant_name,
ROUND(AVG(rv.rating), 2) AS restaurant_average_rating
FROM restaurants r
INNER JOIN reviews rv
ON r.restaurant_id = rv.restaurant_id
GROUP BY
r.restaurant_id,
r.restaurant_name
HAVING AVG(rv.rating) > (
SELECT AVG(rating)
FROM reviews
)
ORDER BY restaurant_average_rating DESC;



---23. Customers with more orders than the average per customer

WITH customer_order_counts AS (
SELECT
c.customer_id,
c.customer_name,
COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY
c.customer_id,
c.customer_name
)
SELECT
customer_id,
customer_name,
total_orders
FROM customer_order_counts
WHERE total_orders > (
SELECT AVG(total_orders)
FROM customer_order_counts
)
ORDER BY total_orders DESC;


-------24. Food items that have never been ordered

SELECT
mi.menu_item_id,
mi.item_name,
mi.price,
r.restaurant_name
FROM menu_items mi
INNER JOIN restaurants r
ON mi.restaurant_id = r.restaurant_id
LEFT JOIN order_items oi
ON mi.menu_item_id = oi.menu_item_id
WHERE oi.order_item_id IS NULL
ORDER BY r.restaurant_name, mi.item_name;


 
--------25. Top three best-selling food items
SELECT
mi.menu_item_id,
mi.item_name,
SUM(oi.quantity) AS total_quantity_sold
FROM menu_items mi
INNER JOIN order_items oi
ON mi.menu_item_id = oi.menu_item_id
INNER JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY
mi.menu_item_id,
mi.item_name
ORDER BY total_quantity_sold DESC
LIMIT 3;
 



------------26. Customers who used promotional coupons



SELECT DISTINCT
c.customer_id,
c.customer_name,
c.email,
cp.coupon_code,
cr.order_id,
cr.redeemed_at
FROM customers c
INNER JOIN coupon_redemptions cr
ON c.customer_id = cr.customer_id
INNER JOIN coupons cp
ON cr.coupon_id = cp.coupon_id
ORDER BY c.customer_name;


--------27. Restaurants that have not received any orders
SQL
SELECT
r.restaurant_id,
r.restaurant_name,
r.address,
r.phone
FROM restaurants r
LEFT JOIN orders o
ON r.restaurant_id = o.restaurant_id
WHERE o.order_id IS NULL;


----------28. Monthly restaurant revenue report

SELECT
r.restaurant_id,
r.restaurant_name,
YEAR(o.order_date) AS revenue_year,
MONTH(o.order_date) AS revenue_month,
MONTHNAME(o.order_date) AS month_name,
COUNT(o.order_id) AS completed_orders,
ROUND(SUM(o.total_amount), 2) AS monthly_revenue
FROM restaurants r
INNER JOIN orders o
ON r.restaurant_id = o.restaurant_id
WHERE o.order_status = 'Delivered'
GROUP BY
r.restaurant_id,
r.restaurant_name,
YEAR(o.order_date),
MONTH(o.order_date),
MONTHNAME(o.order_date)
ORDER BY
revenue_year,
revenue_month,
r.restaurant_name;


--------29. Delivery partners with the highest completed deliveries

WITH partner_delivery_counts AS (
SELECT
dp.delivery_partner_id,
dp.partner_name,
COUNT(d.delivery_id) AS completed_deliveries
FROM delivery_partners dp
INNER JOIN deliveries d
ON dp.delivery_partner_id = d.delivery_partner_id
WHERE d.delivery_status = 'Delivered'
GROUP BY
dp.delivery_partner_id,
dp.partner_name
)
SELECT
delivery_partner_id,
partner_name,
completed_deliveries
FROM partner_delivery_counts
WHERE completed_deliveries = (
SELECT MAX(completed_deliveries)
FROM partner_delivery_counts
);


--30. Customers who ordered but never submitted a review

SELECT
c.customer_id,
c.customer_name,
c.email,
c.phone
FROM customers c
WHERE EXISTS (
SELECT 1
FROM orders o
WHERE o.customer_id = c.customer_id
)
AND NOT EXISTS (
SELECT 1
FROM reviews rv
WHERE rv.customer_id = c.customer_id
);

DESCRIBE customers;
DESCRIBE restaurants;
DESCRIBE menu_items;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE reviews;
DESCRIBE deliveries;
DESCRIBE delivery_partners;
DESCRIBE coupons;
DESCRIBE coupon_redemptions;


DESCRIBE customers;
DESCRIBE customer_addresses;
DESCRIBE restaurants;
DESCRIBE menu_items;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE delivery_partners;
DESCRIBE deliveries;
DESCRIBE reviews;

