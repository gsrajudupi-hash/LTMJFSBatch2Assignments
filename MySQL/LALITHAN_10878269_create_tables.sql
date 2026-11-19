
-- CREATE TABLES
DROP DATABASE IF EXISTS food_delivery_db;


CREATE DATABASE food_delivery_db 


USE food_delivery_db;


CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    mobile_number VARCHAR(10) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);


CREATE TABLE customer_address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
);

CREATE TABLE restaurant (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    contact_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- food category

CREATE TABLE food_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);






CREATE TABLE menu_item (
    menu_item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    food_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    is_vegetarian BOOLEAN NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id),

    FOREIGN KEY (category_id)
        REFERENCES food_category(category_id),

    UNIQUE (restaurant_id, food_name)
);



CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL UNIQUE,

    FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
);



CREATE TABLE cart_item (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,

    FOREIGN KEY (cart_id)
        REFERENCES cart(cart_id),

    FOREIGN KEY (menu_item_id)
        REFERENCES menu_item(menu_item_id),

    UNIQUE (cart_id, menu_item_id)
);



CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    address_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    delivery_charge DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0,
    final_amount DECIMAL(10,2) NOT NULL,
    order_status VARCHAR(30) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id),

    FOREIGN KEY (address_id)
        REFERENCES customer_address(address_id)
);


CREATE TABLE order_item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    item_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (menu_item_id)
        REFERENCES menu_item(menu_item_id),

    UNIQUE (order_id, menu_item_id)
);



CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    transaction_reference VARCHAR(100) UNIQUE,
    payment_method VARCHAR(30) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_status VARCHAR(20) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


CREATE TABLE refund (
    refund_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL,
    refund_date DATETIME NOT NULL,
    refund_status VARCHAR(20) NOT NULL,

    FOREIGN KEY (payment_id)
        REFERENCES payment(payment_id)
);


CREATE TABLE delivery_partner (
    delivery_partner_id INT AUTO_INCREMENT PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL,
    mobile_number VARCHAR(10) NOT NULL UNIQUE,
    vehicle_number VARCHAR(20) NOT NULL UNIQUE,
    vehicle_type VARCHAR(50),
    is_available BOOLEAN NOT NULL DEFAULT TRUE
);


CREATE TABLE delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    delivery_partner_id INT NOT NULL,
    assignment_status VARCHAR(20) NOT NULL,
    pickup_time DATETIME,
    delivery_time DATETIME,
    delivery_status VARCHAR(30) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (delivery_partner_id)
        REFERENCES delivery_partner(delivery_partner_id)
);



CREATE TABLE order_status_history (
    status_history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    status_updated_at DATETIME NOT NULL,
    estimated_delivery_time DATETIME,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


CREATE TABLE review (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    menu_item_id INT,
    rating INT NOT NULL,
    feedback VARCHAR(500),
    review_date DATETIME NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id),

    FOREIGN KEY (menu_item_id)
        REFERENCES menu_item(menu_item_id),

    CHECK (rating BETWEEN 1 AND 5)
);


CREATE TABLE coupon (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_code VARCHAR(50) NOT NULL UNIQUE,
    discount_type VARCHAR(20) NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    minimum_order_value DECIMAL(10,2),
    maximum_discount DECIMAL(10,2)
);



CREATE TABLE coupon_redemption (
    redemption_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL,
    redeemed_at DATETIME NOT NULL,

    FOREIGN KEY (coupon_id)
        REFERENCES coupon(coupon_id),

    FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    UNIQUE (coupon_id, order_id)
);

















