/*
Food Delivery Application 

1.Requirements - entities, attributes, primary key, unique keys and buss
2.DB design - ER diagram, relationship etablish
3.Normalise DB 
4.Implementation - table,constraints,relationship,
5.problem solving

Actors: Customer, Restaurant Owner, Delivery Partner, and Administrator

Entities
1.Cusomter 			- customer_id(PK) , name, email, mob, password
2.Customer address- address id(PK)	, customerId(FK), address, type, is_default
3.restaurant 		- rest id(pk)		, rest name, adress, phone, mail,operating hrs, status, rating,
4.food category 	- category id(PK)	, categoryname,
5.menu item 		- itemId (PK)		, restId (FK), categoryId(FK), foodName, desc, price, type, availabilty status
6.cart 				- cart_id(pk)		, customerId(FK)
7.cart item			- cartItem Id		,cartId(FK), itemId(FK), quantity
8.order				- orderId(PK)		, custId(FK), restId(FK), order_dateTime, order status, delivery charge, discount, final amount
9.order item 		- orderItemId(PK)	, orderId(FK), itemId(FK), quantity, itemPrice_at order time
10.payment 			- paymentId(PK)	, orderId(FK), transactionNumber, paymentMethod, amount, date, status
11.deli partner	- partnerId(PK)	, orderId(FK)
12.delivery 		- delivery_id(PK)	,order_id (FK),partner_id (FK),assignment_status,,pickup_timestamp,delivery_timestamp,
							estimated_delivery_time,delivery_status
13.order stats history -status_history_id (PK),order_id (FK),order_status,status_update_date_time
14.review			 - review_id (PK)	,customer_id (FK),orderid,restaurant_id (FK),item_id (FK),rating,
												feedback,review_date
15.coupon			 - coupon_id (PK)	,coupon_code,discount_percentage,fixed_discount_amount,validity_start_date,
												validity_end_date,minimum_order_value,maximum_discount_limit,
16.coupon redemption- redemption_id (PK),coupon_id (FK),customer_id (FK),order_id (FK),redemption_date
17.refund- refund_id (PK),payment_id (FK),refund_amount,refund_date,refund_status
*/


CREATE DATABASE IF NOT EXISTS food_delivery_db;

USE food_delivery_db;

-- 1. CUSTOMER
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mobile_number VARCHAR(20) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);


-- 2. CUSTOMER_ADDRESS
CREATE TABLE customer_address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE CASCADE
);


-- 3. RESTAURANT
CREATE TABLE restaurant (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    email VARCHAR(255) UNIQUE,
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);


-- 4. FOOD_CATEGORY
CREATE TABLE food_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);


-- 5. MENU_ITEM
CREATE TABLE menu_item (
    menu_item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    is_vegetarian BOOLEAN NOT NULL DEFAULT FALSE,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,

    UNIQUE (restaurant_id, name),

    CHECK (price >= 0),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id),

    FOREIGN KEY (category_id)
        REFERENCES food_category(category_id)
);


-- 6. CART
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,

    FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
        ON DELETE CASCADE
);


-- 7. CART_ITEM
CREATE TABLE cart_item (
    cart_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,

    PRIMARY KEY (cart_id, menu_item_id),

    CHECK (quantity > 0),

    FOREIGN KEY (cart_id)
        REFERENCES cart(cart_id)
        ON DELETE CASCADE,

    FOREIGN KEY (menu_item_id)
        REFERENCES menu_item(menu_item_id)
);


-- 8. ORDERS
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    address_id INT NOT NULL,
    ordered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'PLACED',
    subtotal DECIMAL(10,2) NOT NULL,
    delivery_charge DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount DECIMAL(10,2) NOT NULL DEFAULT 0,
    final_amount DECIMAL(10,2) NOT NULL,
    estimated_delivery_at DATETIME,

    CHECK (subtotal >= 0),
    CHECK (delivery_charge >= 0),
    CHECK (discount >= 0),
    CHECK (final_amount >= 0),

    FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id),

    FOREIGN KEY (address_id)
        REFERENCES customer_address(address_id)
);


-- 9. ORDER_ITEM
CREATE TABLE order_item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price_at_order DECIMAL(10,2) NOT NULL,

    UNIQUE (order_id, menu_item_id),

    CHECK (quantity > 0),
    CHECK (unit_price_at_order >= 0),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    FOREIGN KEY (menu_item_id)
        REFERENCES menu_item(menu_item_id)
);

-- PAYMENT
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    method VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transaction_reference VARCHAR(100) UNIQUE,

    CHECK (amount >= 0),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- 11. DELIVERY_PARTNER
CREATE TABLE delivery_partner (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(20) NOT NULL UNIQUE,
    vehicle_details VARCHAR(255),
    availability_status VARCHAR(30) NOT NULL DEFAULT 'AVAILABLE'
);


-- 12. DELIVERY_ASSIGNMENT
CREATE TABLE delivery_assignment (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    partner_id INT NOT NULL,
    assignment_status VARCHAR(30) NOT NULL DEFAULT 'ASSIGNED',
    delivery_status VARCHAR(30) NOT NULL DEFAULT 'WAITING_FOR_PICKUP',
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pickup_at DATETIME,
    delivered_at DATETIME,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (partner_id)
        REFERENCES delivery_partner(partner_id)
);


-- 13. ORDER_STATUS_HISTORY
CREATE TABLE order_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status VARCHAR(30) NOT NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE
);


-- 14 review
CREATE TABLE review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT,
    rating INT NOT NULL,
    feedback VARCHAR(1000),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CHECK (rating BETWEEN 1 AND 5),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    FOREIGN KEY (menu_item_id)
        REFERENCES menu_item(menu_item_id)
);


-- 15. COUPON
CREATE TABLE coupon (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_type VARCHAR(20) NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    valid_from DATETIME NOT NULL,
    valid_until DATETIME NOT NULL,
    min_order_value DECIMAL(10,2) NOT NULL DEFAULT 0,
    max_discount DECIMAL(10,2),
    total_usage_limit INT,
    per_customer_limit INT DEFAULT 1,

    CHECK (discount_value > 0),
    CHECK (valid_until > valid_from),
    CHECK (min_order_value >= 0),
    CHECK (max_discount IS NULL OR max_discount >= 0),
    CHECK (total_usage_limit IS NULL OR total_usage_limit > 0),
    CHECK (per_customer_limit IS NULL OR per_customer_limit > 0)
);


-- 16. COUPON_REDEMPTION
CREATE TABLE coupon_redemption (
    redemption_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    order_id INT NOT NULL UNIQUE,
    discount_amount DECIMAL(10,2) NOT NULL,
    redeemed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CHECK (discount_amount >= 0),

    FOREIGN KEY (coupon_id)
        REFERENCES coupon(coupon_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- 17 REFUND
CREATE TABLE refund (
    refund_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL,
    refund_status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    refund_date DATETIME,
    refund_reference VARCHAR(100) UNIQUE,

    CHECK (refund_amount > 0),

    FOREIGN KEY (payment_id)
        REFERENCES payment(payment_id)
);
  