-- =====================================================================
-- Online Food Delivery Management System (OFDMS)
-- 01_schema.sql  : database, tables, keys, indexes, views
-- Target         : MySQL 8.0+
-- Level          : beginner / intermediate (plain columns, simple keys)
-- Corrected version: duplicate constraints removed and validations added
-- =====================================================================

-- DROP DATABASE IF EXISTS foodDeliveryDB;
CREATE DATABASE foodDeliveryDB;
USE foodDeliveryDB;

-- ---------------------------------------------------------------------
-- 1. CUSTOMER
-- Stores registered customer details and login-related information.
-- One customer can have multiple addresses, orders and reviews.
-- ---------------------------------------------------------------------
CREATE TABLE customer (
    customer_id   INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL,
    mobile        VARCHAR(15) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active     TINYINT NOT NULL DEFAULT 1,     -- 1 = active, 0 = inactive
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_customer_email UNIQUE (email),
    CONSTRAINT uq_customer_mobile UNIQUE (mobile),
    CONSTRAINT chk_customer_mobile CHECK (mobile REGEXP '^[0-9]{10,15}$'),
    CONSTRAINT chk_customer_active CHECK (is_active IN (0, 1))
);

-- ---------------------------------------------------------------------
-- 2. CUSTOMER_ADDRESS   (one customer can have many addresses)
-- Stores Home, Work or other delivery addresses saved by a customer.
-- ---------------------------------------------------------------------
CREATE TABLE customer_address (
    address_id  INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    label       VARCHAR(30) NOT NULL DEFAULT 'Home',  -- Home / Work / Other
    line1       VARCHAR(150) NOT NULL,
    line2       VARCHAR(150),
    city        VARCHAR(60) NOT NULL,
    state       VARCHAR(60) NOT NULL,
    pincode     VARCHAR(10) NOT NULL,
    is_default  TINYINT NOT NULL DEFAULT 0,        -- 1 = default address
    CONSTRAINT fk_address_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),
    CONSTRAINT chk_address_default CHECK (is_default IN (0, 1))
);

-- ---------------------------------------------------------------------
-- 3. RESTAURANT
-- Stores restaurant contact details, location and business timings.
-- ---------------------------------------------------------------------
CREATE TABLE restaurant (
    restaurant_id  INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(120) NOT NULL,
    address_line   VARCHAR(200) NOT NULL,
    city           VARCHAR(60) NOT NULL,
    state          VARCHAR(60) NOT NULL,
    pincode        VARCHAR(10) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    email          VARCHAR(150),
    opening_time   TIME NOT NULL DEFAULT '09:00:00',
    closing_time   TIME NOT NULL DEFAULT '23:00:00',
    is_active      TINYINT NOT NULL DEFAULT 1,     -- 1 = open for business
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_restaurant_email UNIQUE (email),
    CONSTRAINT chk_restaurant_active CHECK (is_active IN (0, 1))
);

-- ---------------------------------------------------------------------
-- 4. FOOD_CATEGORY   (South Indian, Chinese, Desserts ...)
-- Stores reusable categories used to group restaurant menu items.
-- ---------------------------------------------------------------------
CREATE TABLE food_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(60) NOT NULL,
    description VARCHAR(200),
    CONSTRAINT uq_category_name UNIQUE (name)
);

-- ---------------------------------------------------------------------
-- 5. MENU_ITEM   (a restaurant's food items)
-- Stores each dish, its category, current price and availability.
-- ---------------------------------------------------------------------
CREATE TABLE menu_item (
    item_id       INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    category_id   INT NOT NULL,
    name           VARCHAR(120) NOT NULL,
    description    VARCHAR(300),
    price          DECIMAL(10,2) NOT NULL,
    is_veg         TINYINT NOT NULL,               -- 1 = veg, 0 = non-veg
    is_available   TINYINT NOT NULL DEFAULT 1,     -- 1 = available
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_menu_restaurant FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id),
    CONSTRAINT fk_menu_category FOREIGN KEY (category_id)
        REFERENCES food_category(category_id),
    CONSTRAINT uq_menu_restaurant_item UNIQUE (restaurant_id, name), -- no duplicate dish name in one restaurant
    CONSTRAINT chk_item_price CHECK (price > 0),
    CONSTRAINT chk_item_veg CHECK (is_veg IN (0, 1)),
    CONSTRAINT chk_item_available CHECK (is_available IN (0, 1))
);

-- ---------------------------------------------------------------------
-- 5b. MENU_ITEM_PRICE_HISTORY   (keeps old prices when a price changes)
-- Stores previous and new prices for menu price auditing.
-- ---------------------------------------------------------------------
CREATE TABLE menu_item_price_history (
    price_history_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id          INT NOT NULL,
    old_price        DECIMAL(10,2) NOT NULL,
    new_price        DECIMAL(10,2) NOT NULL,
    changed_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_price_history_item FOREIGN KEY (item_id)
        REFERENCES menu_item(item_id),
    CONSTRAINT chk_old_price CHECK (old_price > 0),
    CONSTRAINT chk_new_price CHECK (new_price > 0)
);

-- ---------------------------------------------------------------------
-- 6. CART   (one active cart per customer)
-- Stores the customer's current cart and selected restaurant.
-- ---------------------------------------------------------------------
CREATE TABLE cart (
    cart_id       INT AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT NOT NULL,
    restaurant_id INT,
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                  ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_cart_customer UNIQUE (customer_id),
    CONSTRAINT fk_cart_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),
    CONSTRAINT fk_cart_restaurant FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id)
);

-- ---------------------------------------------------------------------
-- 7. CART_ITEM
-- Stores individual food items and quantities added to a cart.
-- ---------------------------------------------------------------------
CREATE TABLE cart_item (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id      INT NOT NULL,
    item_id      INT NOT NULL,
    quantity     INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_cart_item_cart FOREIGN KEY (cart_id)
        REFERENCES cart(cart_id),
    CONSTRAINT fk_cart_item_menu FOREIGN KEY (item_id)
        REFERENCES menu_item(item_id),
    CONSTRAINT uq_cart_item UNIQUE (cart_id, item_id),
    CONSTRAINT chk_cart_qty CHECK (quantity > 0)
);

-- ---------------------------------------------------------------------
-- 8. COUPON   (promotional discount codes)
-- Stores fixed or percentage-based promotional offers and usage limits.
-- ---------------------------------------------------------------------
CREATE TABLE coupon (
    coupon_id               INT AUTO_INCREMENT PRIMARY KEY,
    code                    VARCHAR(30) NOT NULL,
    description             VARCHAR(200),
    discount_type           ENUM('PERCENT','FIXED') NOT NULL,
    discount_value          DECIMAL(10,2) NOT NULL,
    max_discount_amount     DECIMAL(10,2), -- cap for PERCENT coupons
    min_order_value         DECIMAL(10,2) NOT NULL DEFAULT 0,
    valid_from              DATE NOT NULL,
    valid_to                DATE NOT NULL,
    is_active               TINYINT NOT NULL DEFAULT 1,
    usage_limit_per_customer INT NOT NULL DEFAULT 1,
    total_usage_limit       INT,             -- NULL = unlimited
    CONSTRAINT uq_coupon_code UNIQUE (code),
    CONSTRAINT chk_coupon_value CHECK (discount_value > 0),
    CONSTRAINT chk_coupon_dates CHECK (valid_to >= valid_from),
    CONSTRAINT chk_coupon_min_order CHECK (min_order_value >= 0),
    CONSTRAINT chk_coupon_max_discount CHECK (
        max_discount_amount IS NULL OR max_discount_amount >= 0
    ),
    CONSTRAINT chk_coupon_customer_limit CHECK (usage_limit_per_customer > 0),
    CONSTRAINT chk_coupon_total_limit CHECK (
        total_usage_limit IS NULL OR total_usage_limit > 0
    ),
    CONSTRAINT chk_coupon_active CHECK (is_active IN (0, 1)),
    CONSTRAINT chk_percent_discount CHECK (
        discount_type <> 'PERCENT' OR discount_value <= 100
    )
);

-- ---------------------------------------------------------------------
-- 9. ORDERS   ("order" is a reserved word, so the table is "orders")
--     total_amount = subtotal + delivery_charge - discount_amount
--     (the app calculates it and stores it here)
-- Stores the order header, delivery address, coupon and current status.
-- address_id is NOT NULL because this version models delivery orders only.
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id                  INT AUTO_INCREMENT PRIMARY KEY,
    customer_id               INT NOT NULL,
    restaurant_id             INT NOT NULL,
    address_id                INT NOT NULL,
    coupon_id                 INT,
    order_datetime            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status                    ENUM('PLACED','CONFIRMED','PREPARING',
                                   'READY_FOR_PICKUP','OUT_FOR_DELIVERY',
                                   'DELIVERED','CANCELLED')
                              NOT NULL DEFAULT 'PLACED',
    subtotal                  DECIMAL(10,2) NOT NULL DEFAULT 0,
    delivery_charge           DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount_amount           DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount              DECIMAL(10,2) NOT NULL DEFAULT 0,
    estimated_delivery_time   DATETIME,
    cancellation_reason       VARCHAR(255),
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),
    CONSTRAINT fk_order_restaurant FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id),
    CONSTRAINT fk_order_address FOREIGN KEY (address_id)
        REFERENCES customer_address(address_id),
    CONSTRAINT fk_order_coupon FOREIGN KEY (coupon_id)
        REFERENCES coupon(coupon_id),
    CONSTRAINT chk_order_subtotal CHECK (subtotal >= 0),
    CONSTRAINT chk_order_delivery_charge CHECK (delivery_charge >= 0),
    CONSTRAINT chk_order_discount CHECK (discount_amount >= 0),
    CONSTRAINT chk_order_total CHECK (total_amount >= 0),
    CONSTRAINT chk_order_total_calculation CHECK (
        total_amount = subtotal + delivery_charge - discount_amount
    )
);

-- ---------------------------------------------------------------------
-- 10. ORDER_ITEM   (the food lines inside an order)
--      item_name and unit_price are copied in at order time so the
--      order keeps its original details even if the menu changes later.
-- ---------------------------------------------------------------------
CREATE TABLE order_item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    item_id       INT NOT NULL,
    item_name     VARCHAR(120) NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    quantity      INT NOT NULL,
    CONSTRAINT fk_order_item_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_order_item_menu FOREIGN KEY (item_id)
        REFERENCES menu_item(item_id),
    CONSTRAINT uq_order_item UNIQUE (order_id, item_id), -- one row per item in an order
    CONSTRAINT chk_order_item_price CHECK (unit_price > 0),
    CONSTRAINT chk_order_item_qty CHECK (quantity > 0)
);

-- ---------------------------------------------------------------------
-- 11. PAYMENT   (an order can have more than one attempt)
-- Stores every online or cash-on-delivery payment attempt for an order.
-- ---------------------------------------------------------------------
CREATE TABLE payment (
    payment_id   INT AUTO_INCREMENT PRIMARY KEY,
    order_id     INT NOT NULL,
    method       ENUM('UPI','CREDIT_CARD','DEBIT_CARD','COD') NOT NULL,
    amount       DECIMAL(10,2) NOT NULL,
    txn_reference VARCHAR(60),                 -- NULL for cash on delivery
    status       ENUM('PENDING','SUCCESS','FAILED','REFUNDED')
                 NOT NULL DEFAULT 'PENDING',
    attempt_no   INT NOT NULL DEFAULT 1,
    paid_at      DATETIME,
    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_payment_txn UNIQUE (txn_reference),
    CONSTRAINT uq_payment_attempt UNIQUE (order_id, attempt_no),
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT chk_payment_amount CHECK (amount > 0),
    CONSTRAINT chk_payment_attempt CHECK (attempt_no > 0)
);

-- ---------------------------------------------------------------------
-- 12. REFUND   (money returned for cancelled orders)
-- Stores refund amount, reason, status and completion time.
-- ---------------------------------------------------------------------
CREATE TABLE refund (
    refund_id   INT AUTO_INCREMENT PRIMARY KEY,
    order_id    INT NOT NULL,
    payment_id  INT,
    amount      DECIMAL(10,2) NOT NULL,
    reason      VARCHAR(255) NOT NULL,
    status      ENUM('INITIATED','COMPLETED','FAILED')
                NOT NULL DEFAULT 'INITIATED',
    refunded_at DATETIME,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_refund_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_refund_payment FOREIGN KEY (payment_id)
        REFERENCES payment(payment_id),
    CONSTRAINT chk_refund_amount CHECK (amount > 0)
);

-- ---------------------------------------------------------------------
-- 13. DELIVERY_PARTNER
-- Stores delivery-person contact, vehicle and availability details.
-- ---------------------------------------------------------------------
CREATE TABLE delivery_partner (
    partner_id     INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(100) NOT NULL,
    mobile         VARCHAR(15) NOT NULL,
    vehicle_type   ENUM('BIKE','SCOOTER','BICYCLE','CAR')
                   NOT NULL DEFAULT 'BIKE',
    vehicle_number VARCHAR(20),
    is_available   TINYINT NOT NULL DEFAULT 1,     -- 1 = available
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_partner_mobile UNIQUE (mobile),
    CONSTRAINT chk_partner_mobile CHECK (mobile REGEXP '^[0-9]{10,15}$'),
    CONSTRAINT chk_partner_available CHECK (is_available IN (0, 1))
);

-- ---------------------------------------------------------------------
-- 14. DELIVERY   (one delivery per order)
-- Stores partner assignment and delivery lifecycle timestamps.
-- ---------------------------------------------------------------------
CREATE TABLE delivery (
    delivery_id       INT AUTO_INCREMENT PRIMARY KEY,
    order_id          INT NOT NULL,
    partner_id        INT,
    assignment_status ENUM('ASSIGNED','ACCEPTED','REJECTED',
                           'PICKED_UP','DELIVERED')
                      NOT NULL DEFAULT 'ASSIGNED',
    assigned_at       DATETIME,
    picked_up_at      DATETIME,
    delivered_at      DATETIME,
    CONSTRAINT uq_delivery_order UNIQUE (order_id),
    CONSTRAINT fk_delivery_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_delivery_partner FOREIGN KEY (partner_id)
        REFERENCES delivery_partner(partner_id)
);

-- ---------------------------------------------------------------------
-- 15. ORDER_STATUS_HISTORY   (tracks every status change of an order)
-- Provides an audit trail from placement through delivery or cancellation.
-- ---------------------------------------------------------------------
CREATE TABLE order_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id   INT NOT NULL,
    status     ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP',
                    'OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NOT NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes      VARCHAR(255),
    CONSTRAINT fk_status_history_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- ---------------------------------------------------------------------
-- 16. RESTAURANT_REVIEW   (customer rates a restaurant)
-- Allows one restaurant review for each completed order.
-- ---------------------------------------------------------------------
CREATE TABLE restaurant_review (
    review_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_id      INT NOT NULL,
    rating        TINYINT NOT NULL,
    comment       VARCHAR(500),
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_restaurant_review_order UNIQUE (order_id), -- one restaurant review per order
    CONSTRAINT fk_restaurant_review_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),
    CONSTRAINT fk_restaurant_review_restaurant FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id),
    CONSTRAINT fk_restaurant_review_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT chk_restaurant_review_rating CHECK (rating BETWEEN 1 AND 5)
);

-- ---------------------------------------------------------------------
-- 17. MENU_ITEM_REVIEW   (customer reviews a food item)
-- Allows one review per menu item within the same order.
-- ---------------------------------------------------------------------
CREATE TABLE menu_item_review (
    review_id   INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    item_id     INT NOT NULL,
    order_id    INT NOT NULL,
    rating      TINYINT NOT NULL,
    comment     VARCHAR(500),
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_menu_item_review UNIQUE (order_id, item_id),
    CONSTRAINT fk_item_review_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),
    CONSTRAINT fk_item_review_item FOREIGN KEY (item_id)
        REFERENCES menu_item(item_id),
    CONSTRAINT fk_item_review_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT chk_item_review_rating CHECK (rating BETWEEN 1 AND 5)
);

-- ---------------------------------------------------------------------
-- 18. COUPON_REDEMPTION   (records each time a coupon is used)
-- Stores the coupon, customer, order and actual discount applied.
-- ---------------------------------------------------------------------
CREATE TABLE coupon_redemption (
    redemption_id    INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id        INT NOT NULL,
    customer_id      INT NOT NULL,
    order_id         INT NOT NULL,
    discount_applied DECIMAL(10,2) NOT NULL,
    redeemed_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_coupon_redemption_order UNIQUE (order_id),
    CONSTRAINT fk_redemption_coupon FOREIGN KEY (coupon_id)
        REFERENCES coupon(coupon_id),
    CONSTRAINT fk_redemption_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),
    CONSTRAINT fk_redemption_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT chk_discount_applied CHECK (discount_applied >= 0)
);

-- =====================================================================
-- INDEXES  (speed up common searches and joins)
-- MySQL automatically indexes UNIQUE constraints and foreign-key columns
-- when needed. The indexes below support common reporting/filtering queries.
-- =====================================================================
CREATE INDEX idx_orders_customer_datetime
    ON orders (customer_id, order_datetime);
CREATE INDEX idx_orders_restaurant_statusclassicmodels
    ON orders (restaurant_id, status);
CREATE INDEX idx_orders_datetime
    ON orders (order_datetime);
CREATE INDEX idx_payment_order_status
    ON payment (order_id, status);
CREATE INDEX idx_delivery_partner
    ON delivery (partner_id);
CREATE INDEX idx_status_history_order_time
    ON order_status_history (order_id, changed_at);
CREATE INDEX idx_coupon_redemption_customer
    ON coupon_redemption (customer_id, coupon_id);

-- =====================================================================
-- VIEWS  (saved queries you can SELECT from like a table)
-- =====================================================================
-- Average rating of each restaurant
CREATE OR REPLACE VIEW vw_restaurant_avg_rating AS
SELECT r.restaurant_id,
       r.name,
       ROUND(AVG(rr.rating), 2) AS avg_rating,
       COUNT(rr.review_id) AS review_count
FROM restaurant r
LEFT JOIN restaurant_review rr
       ON rr.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.name;

-- Full menu (restaurant + category + item)
CREATE OR REPLACE VIEW vw_menu AS
SELECT r.restaurant_id,
       r.name AS restaurant_name,
       c.name AS category,
       mi.item_id,
       mi.name AS item_name,
       mi.price,
       mi.is_veg,
       mi.is_available
FROM menu_item mi
JOIN restaurant r
  ON r.restaurant_id = mi.restaurant_id
JOIN food_category c
  ON c.category_id = mi.category_id;

-- Revenue per restaurant (delivered orders only)
CREATE OR REPLACE VIEW vw_restaurant_sales AS
SELECT r.restaurant_id,
       r.name,
       COUNT(o.order_id) AS delivered_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM restaurant r
LEFT JOIN orders o
       ON o.restaurant_id = r.restaurant_id
      AND o.status = 'DELIVERED'
GROUP BY r.restaurant_id, r.name;

-- Monthly revenue of each restaurant (delivered orders only)
CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT r.restaurant_id,
       r.name AS restaurant,
       YEAR(o.order_datetime) AS order_year,
       MONTH(o.order_datetime) AS order_month,
       SUM(o.total_amount) AS revenue
FROM orders o
JOIN restaurant r
  ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'DELIVERED'
GROUP BY r.restaurant_id,
         r.name,
         YEAR(o.order_datetime),
         MONTH(o.order_datetime);
