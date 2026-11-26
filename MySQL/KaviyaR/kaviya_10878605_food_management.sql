CREATE DATABASE food_delivery_management_db;

USE food_delivery_management_db;

CREATE TABLE customer (
                          customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
                          firstName VARCHAR(25) NOT NULL,
                          lastName VARCHAR(25) NOT NULL,
                          email VARCHAR(25) UNIQUE NOT NULL ,
                          phoneNum VARCHAR(20) UNIQUE NOT NULL ,
                          status ENUM('ACTIVE','INACTIVE','ANONYMIZED') NOT NULL DEFAULT 'ACTIVE',
                          created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          updated_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE customerAddress (
                                 addressId BIGINT PRIMARY KEY AUTO_INCREMENT,
                                 customerId BIGINT NOT NULL,
                                 label VARCHAR(40) NOT NULL,
                                 addressLine1 VARCHAR(180) NOT NULL,
                                 addressLine2 VARCHAR(180),
                                 city VARCHAR(80) NOT NULL,
                                 state VARCHAR(80) NOT NULL,
                                 pincode VARCHAR(12) NOT NULL,
                                 is_default BOOLEAN NOT NULL DEFAULT FALSE,
                                 CONSTRAINT fk_address_customer FOREIGN KEY (customerId)
                                     REFERENCES customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE restaurant (
                            restaurantId BIGINT PRIMARY KEY AUTO_INCREMENT,
                            ownerName VARCHAR(120) NOT NULL,
                            email VARCHAR(160) NOT NULL UNIQUE,
                            phoneNum VARCHAR(20) NOT NULL,
                            addressLine1 VARCHAR(180) NOT NULL,
                            addressLine2 VARCHAR(180),
                            city VARCHAR(80) NOT NULL,
                            state VARCHAR(80) NOT NULL,
                            pincode VARCHAR(12) NOT NULL,
                            openingTime TIME NOT NULL,
                            closingTime TIME NOT NULL,
                            isActive BOOLEAN NOT NULL DEFAULT TRUE,
                            createdDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            rating TINYINT NOT NULL
);

CREATE TABLE foodCategory (
                              categoryId BIGINT PRIMARY KEY AUTO_INCREMENT,
                              restaurantId BIGINT NOT NULL,
                              categoryName VARCHAR(80) NOT NULL UNIQUE,
                              description VARCHAR(255),
                              is_active BOOLEAN NOT NULL DEFAULT TRUE,
                              CONSTRAINT fk_restaurant FOREIGN KEY (restaurantId)
                                  REFERENCES restaurant(restaurantId) ON DELETE CASCADE
);

CREATE TABLE menuItem (
                          menuItemId BIGINT PRIMARY KEY AUTO_INCREMENT,
                          restaurantId BIGINT NOT NULL,
                          categoryId BIGINT NOT NULL,
                          itemName VARCHAR(140) NOT NULL,
                          description VARCHAR(500),
                          price DECIMAL(10,2) NOT NULL,
                          foodType ENUM('VEG','NON_VEG','EGG') NOT NULL,
                          is_available BOOLEAN NOT NULL DEFAULT TRUE,
                          createdDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          updatedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          CONSTRAINT chk_menu_price CHECK (price >= 0),
                          CONSTRAINT uq_restaurant_item UNIQUE (restaurantId,itemName),
                          FOREIGN KEY (restaurantId) REFERENCES restaurant(restaurantId) ON DELETE RESTRICT,
                          FOREIGN KEY (categoryId) REFERENCES foodCategory(categoryId) ON DELETE RESTRICT
);


CREATE TABLE cart (
                      cartId BIGINT PRIMARY KEY AUTO_INCREMENT,
                      customerId BIGINT NOT NULL UNIQUE,
                      restaurantId BIGINT NULL,
                      createdDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      updatedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                      FOREIGN KEY (customerId) REFERENCES customer(customer_id) ON DELETE CASCADE,
                      FOREIGN KEY (restaurantId) REFERENCES restaurant(restaurantId) ON DELETE RESTRICT
);

CREATE TABLE cartItem (
                          cartItemId BIGINT PRIMARY KEY AUTO_INCREMENT,
                          cartId BIGINT  NOT NULL,
                          menuItemId BIGINT  NOT NULL,
                          quantity INT NOT NULL CHECK(quantity > 0),
                          CONSTRAINT uq_cart_menu UNIQUE(cartId,menuItemId),
                          FOREIGN KEY (cartId) REFERENCES cart(cartId) ON DELETE CASCADE,
                          FOREIGN KEY (menuItemId) REFERENCES menuItem(menuItemId) ON DELETE RESTRICT
);

CREATE TABLE coupon (
                        couponId BIGINT PRIMARY KEY AUTO_INCREMENT,
                        couponCode VARCHAR(40) NOT NULL UNIQUE,
                        discountType ENUM('PERCENT','FIXED') NOT NULL,
                        discountValue DECIMAL(10,2) NOT NULL
                            CHECK (discountValue > 0),
                        min_order_value DECIMAL(10,2) NOT NULL DEFAULT 0,
                        max_discount DECIMAL(10,2),
                        validfrom DATETIME NOT NULL,
                        validto DATETIME NOT NULL,
                        per_customer_limit INT NOT NULL DEFAULT 1
                            CHECK (per_customer_limit > 0),
                        total_usage_limit INT,
                        isActive BOOLEAN NOT NULL DEFAULT TRUE,

                        CONSTRAINT chk_coupon_validity
                            CHECK (validto > validfrom)
);

CREATE TABLE customerOrder (
                               orderId BIGINT PRIMARY KEY AUTO_INCREMENT,
                               customerId BIGINT NOT NULL,
                               restaurantId BIGINT NOT NULL,
                               addressId BIGINT NOT NULL,
                               couponId BIGINT NULL,
                               orderTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               orderStatus ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NOT NULL,
                               restaurantDecision ENUM('PENDING','ACCEPTED','REJECTED') NOT NULL DEFAULT 'PENDING',
                               subtotal DECIMAL(12,2) NOT NULL,
                               deliveryCharge DECIMAL(10,2) NOT NULL DEFAULT 0,
                               discountAmt DECIMAL(10,2) NOT NULL DEFAULT 0,
                               totalAmt DECIMAL(12,2) NOT NULL,
                               specialInstructions VARCHAR(500),
                               CHECK(subtotal >= 0 AND deliveryCharge >= 0 AND discountAmt >= 0 AND totalAmt >= 0),
                               FOREIGN KEY (customerId) REFERENCES customer(customer_id) ON DELETE RESTRICT,
                               FOREIGN KEY (restaurantId) REFERENCES restaurant(restaurantId) ON DELETE RESTRICT,
                               FOREIGN KEY (addressId) REFERENCES customerAddress(addressId) ON DELETE RESTRICT,
                               FOREIGN KEY (couponId) REFERENCES coupon(couponId) ON DELETE RESTRICT
);

CREATE TABLE orderItem (
                           orderItemId BIGINT PRIMARY KEY AUTO_INCREMENT,
                           orderId BIGINT NOT NULL,
                           menuItemId BIGINT NULL,
                           itemName VARCHAR(140) NOT NULL,
                           quantity INT NOT NULL,
                           unitPrice DECIMAL(10,2) NOT NULL,
                           totalPrice DECIMAL(12,2) GENERATED ALWAYS AS (quantity * unitPrice) STORED,
                           CHECK(quantity > 0 AND unitPrice >= 0),
                           FOREIGN KEY (orderId) REFERENCES customerOrder(orderId) ON DELETE RESTRICT,
                           FOREIGN KEY (menuItemId) REFERENCES menuItem(menuItemId) ON DELETE SET NULL
);

CREATE TABLE payment (
                         paymentId BIGINT PRIMARY KEY AUTO_INCREMENT,
                         orderId BIGINT NOT NULL,
                         attemptNo INT NOT NULL,
                         paymentMethod ENUM('UPI','CREDIT_CARD','DEBIT_CARD','COD') NOT NULL,
                         transactionrefNum VARCHAR(100) UNIQUE,
                         amount DECIMAL(12,2) NOT NULL,
                         paymentStatus ENUM('INITIATED','SUCCESS','FAILED','REFUNDED','PARTIALLY_REFUNDED') NOT NULL,
                         paymentDate DATETIME NULL,
                         failureReason VARCHAR(255),
                         createdDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         CHECK(attemptNo > 0 AND amount >= 0),
                         UNIQUE(orderId,attemptNo),
                         FOREIGN KEY(orderId) REFERENCES customerOrder(orderId)
                             ON DELETE RESTRICT
);

CREATE TABLE deliveryPartner (
                                 partnerId BIGINT PRIMARY KEY AUTO_INCREMENT,
                                 partnerFirstName VARCHAR(120) NOT NULL,
                                 partnerLastName VARCHAR(120) NOT NULL,
                                 mobile VARCHAR(20) NOT NULL UNIQUE,
                                 vehicleNumber VARCHAR(30) NOT NULL UNIQUE,
                                 vehicleType VARCHAR(40) NOT NULL,
                                 availabilityStatus ENUM('AVAILABLE','BUSY','OFFLINE') NOT NULL DEFAULT 'OFFLINE',
                                 isActive BOOLEAN NOT NULL DEFAULT TRUE,
                                 rating TINYINT NOT NULL
);

CREATE TABLE delivery (
                          deliveryId BIGINT PRIMARY KEY AUTO_INCREMENT,
                          orderId BIGINT NOT NULL UNIQUE,
                          partnerId BIGINT NOT NULL,
                          assignmentStatus ENUM('ASSIGNED','ACCEPTED','REJECTED') NOT NULL,
                          deliveryStatus ENUM('WAITING','PICKED_UP','IN_TRANSIT','DELIVERED','CANCELLED') NOT NULL,
                          assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          accepted_at DATETIME NULL,
                          pickup_at DATETIME NULL,
                          delivered_at DATETIME NULL,
                          estimated_delivery_at DATETIME NULL,
                          FOREIGN KEY(orderId) REFERENCES customerOrder(orderId)
                              ON DELETE RESTRICT,
                          FOREIGN KEY(partnerId) REFERENCES deliveryPartner(partnerId)
                              ON DELETE RESTRICT
);

CREATE TABLE order_status_history (
                                      historyId BIGINT PRIMARY KEY AUTO_INCREMENT,
                                      orderId BIGINT NOT NULL,
                                      orderStatus ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NOT NULL,
                                      changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      note VARCHAR(255),
                                      changed_by_type ENUM('CUSTOMER','RESTAURANT','PARTNER','ADMIN','SYSTEM') NOT NULL,
                                      changed_by_id BIGINT NULL,
                                      FOREIGN KEY(orderId) REFERENCES customerOrder(orderId) ON DELETE RESTRICT
);

CREATE TABLE review (
                        reviewId BIGINT PRIMARY KEY AUTO_INCREMENT,
                        orderId BIGINT NOT NULL,
                        customerId BIGINT NOT NULL,
                        restaurantId BIGINT NOT NULL,
                        menuItemId BIGINT NULL,
                        rating TINYINT NOT NULL,
                        reviewComments VARCHAR(1000),
                        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        CHECK(rating BETWEEN 1 AND 5), UNIQUE(orderId,menuItemId),
                        FOREIGN KEY(orderId) REFERENCES customerOrder(orderId) ON DELETE RESTRICT,
                        FOREIGN KEY(customerId) REFERENCES customer(customer_id) ON DELETE RESTRICT,
                        FOREIGN KEY(restaurantId) REFERENCES restaurant(restaurantId) ON DELETE RESTRICT,
                        FOREIGN KEY(menuItemId) REFERENCES menuItem(menuItemId) ON DELETE SET NULL
);

CREATE TABLE couponRedemption (
                                  redemptionId BIGINT PRIMARY KEY AUTO_INCREMENT,
                                  couponId BIGINT NOT NULL,
                                  customerId BIGINT NOT NULL,
                                  orderId BIGINT NOT NULL UNIQUE,
                                  discountAmount DECIMAL(10,2) NOT NULL,
                                  redeemed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  CHECK(discountAmount >= 0), FOREIGN KEY(couponId) REFERENCES coupon(couponId) ON DELETE RESTRICT,
                                  FOREIGN KEY(customerId) REFERENCES customer(customer_id) ON DELETE RESTRICT,
                                  FOREIGN KEY(orderId) REFERENCES customerOrder(orderId) ON DELETE RESTRICT
);
CREATE TABLE refund (
                        refundId BIGINT PRIMARY KEY AUTO_INCREMENT,
                        paymentId BIGINT NOT NULL,
                        orderId BIGINT NOT NULL,
                        refund_ref VARCHAR(100) NOT NULL UNIQUE,
                        amount DECIMAL(12,2) NOT NULL,
                        reason VARCHAR(255) NOT NULL,
                        refund_status ENUM('REQUESTED','PROCESSING','SUCCESS','FAILED') NOT NULL,
                        requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        processed_at DATETIME NULL,
                        CHECK(amount > 0), FOREIGN KEY(paymentId) REFERENCES payment(paymentId) ON DELETE RESTRICT,
                        FOREIGN KEY(orderId) REFERENCES customerOrder(orderId) ON DELETE RESTRICT
);
CREATE TABLE restaurant_order_cancellation (
                                               cancellationId BIGINT PRIMARY KEY AUTO_INCREMENT,
                                               orderId BIGINT NOT NULL UNIQUE,
                                               cancelled_by ENUM('CUSTOMER','RESTAURANT','ADMIN','SYSTEM') NOT NULL,
                                               reason_code VARCHAR(40) NOT NULL,
                                               reason_text VARCHAR(500),
                                               cancelled_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                               FOREIGN KEY(orderId) REFERENCES customerOrder(orderId) ON DELETE RESTRICT
);










