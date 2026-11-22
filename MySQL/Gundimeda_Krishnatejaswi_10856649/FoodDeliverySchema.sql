CREATE DATABASE ofdms;
USE ofdms;
-- 1. Customer
CREATE TABLE Customer (
   customer_id     INT AUTO_INCREMENT PRIMARY KEY,
   name            VARCHAR(100) NOT NULL,
   email           VARCHAR(150) NOT NULL UNIQUE,
   mobile          VARCHAR(15)  NOT NULL UNIQUE,
   password_hash   VARCHAR(255) NOT NULL,
   created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
   is_active       TINYINT(1) DEFAULT 1
);
-- 2. Customer Address
CREATE TABLE Customer_Address (
   address_id      INT AUTO_INCREMENT PRIMARY KEY,
   customer_id     INT NOT NULL,
   address_line    VARCHAR(255) NOT NULL,
   city            VARCHAR(80)  NOT NULL,
   state           VARCHAR(80)  NOT NULL,
   pincode         VARCHAR(10)  NOT NULL,
   landmark        VARCHAR(100),
   is_default      TINYINT(1) DEFAULT 0,
   FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
-- 3. Restaurant
CREATE TABLE Restaurant (
   restaurant_id   INT AUTO_INCREMENT PRIMARY KEY,
   name            VARCHAR(150) NOT NULL,
   address         VARCHAR(255) NOT NULL,
   contact_number  VARCHAR(15),
   email           VARCHAR(150),
   is_active       TINYINT(1) DEFAULT 1,
   avg_rating      DECIMAL(3,2) DEFAULT 0.00,
   opening_time    TIME,
   closing_time    TIME
);
-- 4. Food Category
CREATE TABLE Food_Category (
   category_id     INT AUTO_INCREMENT PRIMARY KEY,
   category_name   VARCHAR(80) NOT NULL UNIQUE
);
-- 5. Menu Item
CREATE TABLE Menu_Item (
   item_id         INT AUTO_INCREMENT PRIMARY KEY,
   restaurant_id   INT NOT NULL,
   category_id     INT NOT NULL,
   item_name       VARCHAR(150) NOT NULL,
   description     TEXT,
   price           DECIMAL(10,2) NOT NULL CHECK (price >= 0),
   is_veg          TINYINT(1) DEFAULT 1,
   is_available    TINYINT(1) DEFAULT 1,
   FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
   FOREIGN KEY (category_id)   REFERENCES Food_Category(category_id)
);
-- 6. Cart
CREATE TABLE Cart (
   cart_id         INT AUTO_INCREMENT PRIMARY KEY,
   customer_id     INT NOT NULL UNIQUE,
   created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
-- 7. Cart Item
CREATE TABLE Cart_Item (
   cart_item_id    INT AUTO_INCREMENT PRIMARY KEY,
   cart_id         INT NOT NULL,
   item_id         INT NOT NULL,
   quantity        INT NOT NULL CHECK (quantity > 0),
   FOREIGN KEY (cart_id) REFERENCES Cart(cart_id) ON DELETE CASCADE,
   FOREIGN KEY (item_id) REFERENCES Menu_Item(item_id),
   UNIQUE KEY uk_cart_item (cart_id, item_id)
);

-- 15. Coupon
CREATE TABLE Coupon (
   coupon_id       INT AUTO_INCREMENT PRIMARY KEY,
   coupon_code     VARCHAR(30) NOT NULL UNIQUE,
   discount_type   ENUM('PERCENT','FIXED') NOT NULL,
   discount_value  DECIMAL(10,2) NOT NULL,
   min_order_value DECIMAL(10,2) DEFAULT 0,
   max_discount    DECIMAL(10,2),
   valid_from      DATE,
   valid_to        DATE,
   usage_limit     INT DEFAULT 1,
   is_active       TINYINT(1) DEFAULT 1
);
-- 8. Orders
CREATE TABLE Orders (
   order_id        INT AUTO_INCREMENT PRIMARY KEY,
   customer_id     INT NOT NULL,
   restaurant_id   INT NOT NULL,
   address_id      INT NOT NULL,
   order_datetime  DATETIME DEFAULT CURRENT_TIMESTAMP,
   status          ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP',
                        'OUT_FOR_DELIVERY','DELIVERED','CANCELLED') DEFAULT 'PLACED',
   subtotal        DECIMAL(10,2) NOT NULL,
   delivery_charge DECIMAL(10,2) DEFAULT 0,
   discount_amount DECIMAL(10,2) DEFAULT 0,
   final_amount    DECIMAL(10,2) NOT NULL,
   coupon_id       INT NULL,
   FOREIGN KEY (customer_id)   REFERENCES Customer(customer_id),
   FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
   FOREIGN KEY (address_id)    REFERENCES Customer_Address(address_id),
   FOREIGN KEY (coupon_id)     REFERENCES Coupon(coupon_id)
);
-- 9. Order Item
CREATE TABLE Order_Item (
   order_item_id   INT AUTO_INCREMENT PRIMARY KEY,
   order_id        INT NOT NULL,
   item_id         INT NOT NULL,
   quantity        INT NOT NULL,
   unit_price      DECIMAL(10,2) NOT NULL,   -- historical price
   FOREIGN KEY (order_id) REFERENCES Orders(order_id),
   FOREIGN KEY (item_id)  REFERENCES Menu_Item(item_id)
);
-- 10. Payment
CREATE TABLE Payment (
   payment_id      INT AUTO_INCREMENT PRIMARY KEY,
   order_id        INT NOT NULL,
   payment_method  ENUM('UPI','CREDIT_CARD','DEBIT_CARD','COD') NOT NULL,
   transaction_ref VARCHAR(100),
   amount          DECIMAL(10,2) NOT NULL,
   payment_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
   status          ENUM('PENDING','SUCCESS','FAILED','REFUNDED') DEFAULT 'PENDING',
   FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
-- 11. Delivery Partner
CREATE TABLE Delivery_Partner (
   partner_id      INT AUTO_INCREMENT PRIMARY KEY,
   name            VARCHAR(100) NOT NULL,
   mobile          VARCHAR(15)  NOT NULL UNIQUE,
   vehicle_type    VARCHAR(50),
   vehicle_number  VARCHAR(30),
   is_available    TINYINT(1) DEFAULT 1
);
-- 12. Delivery
CREATE TABLE Delivery (
   delivery_id     INT AUTO_INCREMENT PRIMARY KEY,
   order_id        INT NOT NULL UNIQUE,
   partner_id      INT NOT NULL,
   assigned_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
   picked_up_at    DATETIME NULL,
   delivered_at    DATETIME NULL,
   status          ENUM('ASSIGNED','ACCEPTED','PICKED_UP','DELIVERED','CANCELLED') DEFAULT 'ASSIGNED',
   FOREIGN KEY (order_id)   REFERENCES Orders(order_id),
   FOREIGN KEY (partner_id) REFERENCES Delivery_Partner(partner_id)
);
-- 13. Order Status History
CREATE TABLE Order_Status_History (
   history_id      INT AUTO_INCREMENT PRIMARY KEY,
   order_id        INT NOT NULL,
   status          VARCHAR(30) NOT NULL,
   changed_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
   remarks         VARCHAR(255),
   FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
-- 14. Review
CREATE TABLE Review (
   review_id       INT AUTO_INCREMENT PRIMARY KEY,
   customer_id     INT NOT NULL,
   restaurant_id   INT NOT NULL,
   order_id        INT NOT NULL,
   item_id         INT NULL,
   rating          TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
   comment         TEXT,
   review_date     DATETIME DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (customer_id)   REFERENCES Customer(customer_id),
   FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
   FOREIGN KEY (order_id)      REFERENCES Orders(order_id),
   FOREIGN KEY (item_id)       REFERENCES Menu_Item(item_id)
);

-- 16. Coupon Redemption
CREATE TABLE Coupon_Redemption (
   redemption_id   INT AUTO_INCREMENT PRIMARY KEY,
   coupon_id       INT NOT NULL,
   customer_id     INT NOT NULL,
   order_id        INT NOT NULL,
   redeemed_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (coupon_id)   REFERENCES Coupon(coupon_id),
   FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
   FOREIGN KEY (order_id)    REFERENCES Orders(order_id)
);
-- 17. Refund
CREATE TABLE Refund (
   refund_id       INT AUTO_INCREMENT PRIMARY KEY,
   payment_id      INT NOT NULL,
   refund_amount   DECIMAL(10,2) NOT NULL,
   reason          VARCHAR(255),
   refund_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
   status          ENUM('INITIATED','PROCESSED','FAILED') DEFAULT 'INITIATED',
   FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)
);