USE db_online_food_delivery_app;

DROP TABLE If EXISTS tbl_users;

CREATE TABLE tbl_users(
user_id INT PRIMARY KEY AUTO_INCREMENT ,
first_name VARCHAR(255) ,
last_name VARCHAR(255) ,
email VARCHAR(255) UNIQUE NOT NULL  ,
user_password VARCHAR(100) UNIQUE NOT NULL ,
phone VARCHAR(255) UNIQUE NOT NULL,
account_status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP ,
updated_at DATETIME NULL
);

DROP table tbl_users;

ALTER TABLE tbl_users modify column user_id INT PRIMARY KEY AUTO_INCREMENT; 

CREATE TABLE tbl_roles(
role_id INT AUTO_INCREMENT PRIMARY KEY,
role_code VARCHAR(50) NOT NULL UNIQUE,
role_name VARCHAR(255),
role_description VARCHAR(255),
is_active BOOLEAN DEFAULT TRUE ,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP ,
updated_at DATETIME NULL 
);

CREATE TABLE tbl_permissions(
permission_id INT  PRIMARY KEY AUTO_INCREMENT,
permission_code VARCHAR(100) NOT NULL UNIQUE ,
permission_name VARCHAR(150) NOT NULL ,
module_name VARCHAR(100) NOT NULL ,
decription VARCHAR(255),
is_active BOOLEAN DEFAULT TRUE ,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE tbl_restaurants (
 restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
 owner_user_id INT NOT NULL,
 restaurant_name VARCHAR(200) NOT NULL,
 description TEXT,
 email VARCHAR(255),
 contact_number VARCHAR(20),
 restaurant_status ENUM('ACTIVE','INACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_restaurant_owner FOREIGN KEY(owner_user_id) REFERENCES tbl_users(user_id),
 INDEX idx_restaurant_status(restaurant_status)
);


CREATE TABLE tbl_addresses (
 address_id INT AUTO_INCREMENT PRIMARY KEY,
 address_line1 VARCHAR(255) NOT NULL,
 address_line2 VARCHAR(255),
 landmark VARCHAR(255),
 city VARCHAR(100) NOT NULL,
 state VARCHAR(100) NOT NULL,
 country VARCHAR(100) NOT NULL,
 postal_code VARCHAR(20),
 latitude DECIMAL(10,7),
 longitude DECIMAL(11,7),
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tbl_restaurant_branches (
 branch_id INT AUTO_INCREMENT PRIMARY KEY,
 restaurant_id INT NOT NULL,
 address_id INT  NOT NULL,
 branch_name VARCHAR(150) NOT NULL,
 contact_number VARCHAR(20),
 branch_status ENUM('ACTIVE','INACTIVE','CLOSED') NOT NULL DEFAULT 'ACTIVE',
 CONSTRAINT fk_branch_restaurant FOREIGN KEY(restaurant_id) REFERENCES tbl_restaurants(restaurant_id),
 CONSTRAINT fk_branch_address FOREIGN KEY(address_id) REFERENCES tbl_addresses(address_id),
 INDEX idx_branch_restaurant(restaurant_id)
);

ALTER TABLE tbl_restaurant_branches ADD UNIQUE KEY uk_branch_restaurant_pair(branch_id,restaurant_id);

CREATE TABLE tbl_user_roles(
user_role_id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT ,
role_id INT ,
restaurant_id INT ,
branch_id INT ,
assigned_by INT ,
assigned_at DATETIME DEFAULT CURRENT_TIMESTAMP ,
is_active BOOLEAN DEFAULT TRUE ,
restaurant_scope INT GENERATED ALWAYS AS (IFNULL(restaurant_id,0)) STORED,
branch_scope INT GENERATED ALWAYS AS (IFNULL(branch_id,0)) STORED,
CONSTRAINT fk_user_key
FOREIGN KEY (user_id) REFERENCES tbl_users(user_id),
CONSTRAINT fk_role_key
FOREIGN KEY (role_id) REFERENCES tbl_roles(role_id),
CONSTRAINT fk_assigned_by
FOREIGN KEY (assigned_by) REFERENCES tbl_users(user_id),
CONSTRAINT fk_ur_restaurant FOREIGN KEY(restaurant_id) REFERENCES tbl_restaurants(restaurant_id),
CONSTRAINT fk_ur_branch FOREIGN KEY(branch_id,restaurant_id) REFERENCES tbl_restaurant_branches(branch_id,restaurant_id),
UNIQUE KEY uk_user_role_scope(user_id,role_id,restaurant_scope,branch_scope,branch_id),
INDEX idx_ur_user_active(user_id,is_active)
);

CREATE TABLE tbl_customers (
 customer_id INT  AUTO_INCREMENT PRIMARY KEY,
 user_id INT NOT NULL UNIQUE,
 date_of_birth DATE NULL,
 loyalty_points INT NOT NULL DEFAULT 0,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_customers_user FOREIGN KEY(user_id) REFERENCES tbl_users(user_id)
) ;

CREATE TABLE tbl_delivery_partners (
 delivery_partner_id INT PRIMARY KEY AUTO_INCREMENT,
 user_id INT UNIQUE NOT NULL,
 vehicle_type VARCHAR(40),
 vehicle_number VARCHAR(30) UNIQUE,
 license_number VARCHAR(50) UNIQUE,
 availability_status ENUM('AVAILABLE','BUSY','OFFLINE') NOT NULL DEFAULT 'OFFLINE',
 verification_status ENUM('PENDING','VERIFIED','REJECTED') NOT NULL DEFAULT 'PENDING',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_partner_user FOREIGN KEY(user_id) REFERENCES tbl_users(user_id)
);


CREATE TABLE tbl_customer_addresses (
 customer_address_id INT PRIMARY KEY AUTO_INCREMENT,
 customer_id INT NOT NULL,
 address_id INT NOT NULL,
 address_type ENUM('HOME','WORK','OTHER') NOT NULL DEFAULT 'HOME',
 is_default BOOLEAN NOT NULL DEFAULT FALSE,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_ca_customer FOREIGN KEY(customer_id) REFERENCES tbl_customers(customer_id),
 CONSTRAINT fk_ca_address FOREIGN KEY(address_id) REFERENCES tbl_addresses(address_id)
) ;


CREATE TABLE tbl_role_permissions (
 role_permission_id INT PRIMARY KEY AUTO_INCREMENT,
 role_id INT NOT NULL,
 permission_id INT NOT NULL,
 granted_by INT,
 granted_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
 CONSTRAINT fk_rp_role FOREIGN KEY(role_id) REFERENCES tbl_roles(role_id),
 CONSTRAINT fk_rp_permission FOREIGN KEY(permission_id) REFERENCES tbl_permissions(permission_id),
 CONSTRAINT fk_rp_granted_by FOREIGN KEY(granted_by) REFERENCES tbl_users(user_id),
 UNIQUE KEY uk_role_permission(role_id,permission_id)
);

CREATE TABLE tbl_restaurant_operating_hours (
 operating_hour_id INT PRIMARY KEY AUTO_INCREMENT,
 branch_id INT NOT NULL,
 day_of_week TINYINT UNSIGNED NOT NULL COMMENT '1=Monday ... 7=Sunday',
 opening_time TIME NULL,
 closing_time TIME NULL,
 is_closed BOOLEAN NOT NULL DEFAULT FALSE,
 CONSTRAINT fk_hours_branch FOREIGN KEY(branch_id) REFERENCES tbl_restaurant_branches(branch_id),
 CONSTRAINT chk_day_of_week CHECK(day_of_week BETWEEN 1 AND 7),
 UNIQUE KEY uk_branch_day(branch_id,day_of_week)
);

CREATE TABLE tbl_food_categories (
 category_id INT PRIMARY KEY AUTO_INCREMENT,
 category_name VARCHAR(100) NOT NULL UNIQUE,
 description TEXT,
 parent_category_id INT NULL,
 is_active BOOLEAN NOT NULL DEFAULT TRUE,
 CONSTRAINT fk_category_parent FOREIGN KEY(parent_category_id) REFERENCES tbl_food_categories(category_id)
);

CREATE TABLE tbl_menus (
 menu_id INT PRIMARY KEY AUTO_INCREMENT,
 branch_id INT NOT NULL,
 menu_name VARCHAR(100) NOT NULL COMMENT 'Breakfast, Lunch, Dinner, All-day',
 available_from TIME NULL,
 available_until TIME NULL,
 is_active BOOLEAN NOT NULL DEFAULT TRUE,
 CONSTRAINT fk_menu_branch FOREIGN KEY(branch_id) REFERENCES tbl_restaurant_branches(branch_id)
) ;

CREATE TABLE tbl_menu_items (
 menu_item_id INT  PRIMARY KEY AUTO_INCREMENT,
 menu_id INT NOT NULL,
 category_id INT NOT NULL,
 food_name VARCHAR(200) NOT NULL,
 description TEXT,
 food_type ENUM('VEG','NON_VEG','EGG','VEGAN') NOT NULL,
 current_price DECIMAL(12,2) NOT NULL,
 availability_status ENUM('AVAILABLE','UNAVAILABLE') NOT NULL DEFAULT 'AVAILABLE',
 preparation_time_minutes INT,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_mi_menu FOREIGN KEY(menu_id) REFERENCES tbl_menus(menu_id),
 CONSTRAINT fk_mi_category FOREIGN KEY(category_id) REFERENCES tbl_food_categories(category_id),
 CONSTRAINT chk_menu_item_price CHECK(current_price >= 0),
 INDEX idx_menu_item_search(food_name,food_type,availability_status)
) ;

CREATE TABLE tbl_food_item_prices (
 price_id INT PRIMARY KEY AUTO_INCREMENT,
 menu_item_id INT NOT NULL,
 price DECIMAL(12,2) NOT NULL,
 effective_from DATETIME NOT NULL,
 effective_until DATETIME NULL,
 changed_by INT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_price_item FOREIGN KEY(menu_item_id) REFERENCES tbl_menu_items(menu_item_id),
 CONSTRAINT fk_price_user FOREIGN KEY(changed_by) REFERENCES tbl_users(user_id),
 CONSTRAINT chk_price_nonnegative CHECK(price >= 0),
 INDEX idx_price_history(menu_item_id,effective_from)
) ;

CREATE TABLE tbl_carts (
 cart_id INT  PRIMARY KEY AUTO_INCREMENT,
 customer_id INT NOT NULL,
 cart_status ENUM('ACTIVE','CONVERTED','ABANDONED') NOT NULL DEFAULT 'ACTIVE',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_cart_customer FOREIGN KEY(customer_id) REFERENCES tbl_customers(customer_id),
 INDEX idx_cart_customer_status(customer_id,cart_status)
) ;

CREATE TABLE tbl_cart_items (
 cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
 cart_id INT NOT NULL,
 menu_item_id INT NOT NULL,
 quantity INT NOT NULL,
 displayed_unit_price DECIMAL(12,2) NOT NULL,
 added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_ci_cart FOREIGN KEY(cart_id) REFERENCES tbl_carts(cart_id),
 CONSTRAINT fk_ci_menu_item FOREIGN KEY(menu_item_id) REFERENCES tbl_menu_items(menu_item_id),
 CONSTRAINT chk_cart_qty CHECK(quantity > 0),
 INDEX idx_cart_items_cart(cart_id)
) ;

CREATE TABLE tbl_orders (
 order_id INT PRIMARY KEY AUTO_INCREMENT,
 order_number VARCHAR(50) NOT NULL UNIQUE,
 customer_id INT NOT NULL,
 order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 subtotal DECIMAL(12,2) NOT NULL,
 tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 delivery_charge DECIMAL(12,2) NOT NULL DEFAULT 0,
 discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 grand_total DECIMAL(12,2) NOT NULL,
 order_status ENUM('PLACED','CONFIRMED','PREPARING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NOT NULL DEFAULT 'PLACED',
 payment_status ENUM('PENDING','PARTIALLY_PAID','PAID','FAILED','REFUNDED','PARTIALLY_REFUNDED') NOT NULL DEFAULT 'PENDING',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_order_customer FOREIGN KEY(customer_id) REFERENCES tbl_customers(customer_id),
 CONSTRAINT chk_order_amounts CHECK(subtotal >= 0 AND grand_total >= 0 AND discount_amount >= 0),
 INDEX idx_orders_customer_date(customer_id,order_date),
 INDEX idx_orders_status_date(order_status,order_date)
) ;

CREATE TABLE tbl_order_delivery_addresses (
 order_address_id INT  PRIMARY KEY AUTO_INCREMENT,
 order_id INT NOT NULL UNIQUE,
 recipient_name VARCHAR(150) NOT NULL,
 recipient_mobile VARCHAR(20) NOT NULL,
 address_line1 VARCHAR(255) NOT NULL,
 address_line2 VARCHAR(255),
 landmark VARCHAR(255),
 city VARCHAR(100) NOT NULL,
 state VARCHAR(100) NOT NULL,
 country VARCHAR(100) NOT NULL,
 postal_code VARCHAR(20),
 latitude DECIMAL(10,7),
 longitude DECIMAL(11,7),
 CONSTRAINT fk_oda_order FOREIGN KEY(order_id) REFERENCES tbl_orders(order_id)
);

CREATE TABLE tbl_restaurant_orders (
 restaurant_order_id INT  PRIMARY KEY AUTO_INCREMENT,
 order_id INT NOT NULL,
 branch_id INT NOT NULL,
 restaurant_order_number VARCHAR(50) NOT NULL UNIQUE,
 food_subtotal DECIMAL(12,2) NOT NULL,
 tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 total_amount DECIMAL(12,2) NOT NULL,
 preparation_status ENUM('PLACED','ACCEPTED','REJECTED','PREPARING','READY_FOR_PICKUP','CANCELLED') NOT NULL DEFAULT 'PLACED',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_ro_order FOREIGN KEY(order_id) REFERENCES tbl_orders(order_id),
 CONSTRAINT fk_ro_branch FOREIGN KEY(branch_id) REFERENCES tbl_restaurant_branches(branch_id),
 INDEX idx_ro_order(order_id),
 INDEX idx_ro_branch(branch_id)
) ;

CREATE TABLE tbl_order_items (
 order_item_id INT  PRIMARY KEY AUTO_INCREMENT,
 restaurant_order_id INT NOT NULL,
 menu_item_id INT NULL,
 food_name_snapshot VARCHAR(200) NOT NULL,
 food_type_snapshot VARCHAR(30) NOT NULL,
 quantity INT NOT NULL,
 unit_price DECIMAL(12,2) NOT NULL,
 tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 total_amount DECIMAL(12,2) NOT NULL,
 CONSTRAINT fk_oi_restaurant_order FOREIGN KEY(restaurant_order_id) REFERENCES tbl_restaurant_orders(restaurant_order_id),
 CONSTRAINT fk_oi_menu_item FOREIGN KEY(menu_item_id) REFERENCES tbl_menu_items(menu_item_id),
 CONSTRAINT chk_order_item_qty CHECK(quantity > 0),
 INDEX idx_order_items_menu_item(menu_item_id)
) ;

CREATE TABLE tbl_order_item_variants (
 order_item_variant_id INT  PRIMARY KEY AUTO_INCREMENT,
 order_item_id INT NOT NULL,
 variant_name_snapshot VARCHAR(100) NOT NULL,
 additional_price_snapshot DECIMAL(12,2) NOT NULL DEFAULT 0,
 CONSTRAINT fk_oiv_item FOREIGN KEY(order_item_id) REFERENCES tbl_order_items(order_item_id)
) ;

CREATE TABLE tbl_order_item_addons (
 order_item_addon_id INT   PRIMARY KEY AUTO_INCREMENT,
 order_item_id INT NOT NULL,
 addon_name_snapshot VARCHAR(100) NOT NULL,
 addon_price_snapshot DECIMAL(12,2) NOT NULL DEFAULT 0,
 CONSTRAINT fk_oia_item FOREIGN KEY(order_item_id) REFERENCES tbl_order_items(order_item_id)
) ;

CREATE TABLE tbl_order_status_history (
 order_status_history_id INT  PRIMARY KEY AUTO_INCREMENT,
 order_id INT NOT NULL,
 previous_status VARCHAR(30),
 current_status VARCHAR(30) NOT NULL,
 updated_by INT NULL,
 remarks VARCHAR(255),
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_osh_order FOREIGN KEY(order_id) REFERENCES tbl_orders(order_id),
 CONSTRAINT fk_osh_user FOREIGN KEY(updated_by) REFERENCES tbl_users(user_id),
 INDEX idx_osh_order_time(order_id,created_at)
) ;

CREATE TABLE tbl_restaurant_order_status_history (
 history_id INT AUTO_INCREMENT PRIMARY KEY,
 restaurant_order_id INT NOT NULL,
 previous_status VARCHAR(30),
 current_status VARCHAR(30) NOT NULL,
 updated_by INT NULL,
 remarks VARCHAR(255),
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_rosh_order FOREIGN KEY(restaurant_order_id) REFERENCES tbl_restaurant_orders(restaurant_order_id),
 CONSTRAINT fk_rosh_user FOREIGN KEY(updated_by) REFERENCES tbl_users(user_id)
) ;

CREATE TABLE tbl_order_payments (
 order_payment_id INT  PRIMARY KEY AUTO_INCREMENT,
 order_id INT NOT NULL,
 payment_method ENUM('UPI','CREDIT_CARD','DEBIT_CARD','NET_BANKING','WALLET','COD') NOT NULL,
 allocated_amount DECIMAL(12,2) NOT NULL,
 payment_status ENUM('PENDING','PROCESSING','SUCCESS','FAILED','PARTIALLY_REFUNDED','REFUNDED') NOT NULL DEFAULT 'PENDING',
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT fk_payment_order FOREIGN KEY(order_id) REFERENCES tbl_orders(order_id),
 CONSTRAINT chk_payment_amount CHECK(allocated_amount > 0),
 INDEX idx_payment_order(order_id)
) ;

CREATE TABLE tbl_payment_attempts (
 payment_attempt_id INT PRIMARY KEY AUTO_INCREMENT,
 order_payment_id INT NOT NULL,
 attempt_number INT NOT NULL,
 gateway_name VARCHAR(100),
 gateway_transaction_id VARCHAR(150) UNIQUE,
 idempotency_key VARCHAR(100) NOT NULL UNIQUE,
 attempted_amount DECIMAL(12,2) NOT NULL,
 attempt_status ENUM('INITIATED','SUCCESS','FAILED','TIMEOUT') NOT NULL,
 failure_reason VARCHAR(255),
 attempted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 completed_at DATETIME NULL,
 CONSTRAINT fk_attempt_payment FOREIGN KEY(order_payment_id) REFERENCES tbl_order_payments(order_payment_id),
 UNIQUE KEY uk_payment_attempt_no(order_payment_id,attempt_number)
) ;

CREATE TABLE tbl_payment_refunds (
 refund_id INT AUTO_INCREMENT PRIMARY KEY,
 order_payment_id INT  NOT NULL,
 payment_attempt_id INT NULL,
 refund_reference VARCHAR(100) NOT NULL UNIQUE,
 refund_amount DECIMAL(12,2) NOT NULL,
 refund_reason VARCHAR(255),
 refund_status ENUM('REQUESTED','PROCESSING','SUCCESS','FAILED') NOT NULL DEFAULT 'REQUESTED',
 requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 completed_at DATETIME NULL,
 CONSTRAINT fk_refund_payment FOREIGN KEY(order_payment_id) REFERENCES tbl_order_payments(order_payment_id),
 CONSTRAINT fk_refund_attempt FOREIGN KEY(payment_attempt_id) REFERENCES tbl_payment_attempts(payment_attempt_id),
 CONSTRAINT chk_refund_amount CHECK(refund_amount > 0)
) ;

CREATE TABLE tbl_deliveries (
 delivery_id INT PRIMARY KEY AUTO_INCREMENT,
 restaurant_order_id INT NOT NULL UNIQUE,
 delivery_status ENUM('PENDING','ASSIGNED','PICKED_UP','OUT_FOR_DELIVERY','DELIVERED','FAILED') NOT NULL DEFAULT 'PENDING',
 pickup_time DATETIME NULL,
 estimated_delivery_time DATETIME NULL,
 delivered_at DATETIME NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_delivery_restaurant_order FOREIGN KEY(restaurant_order_id) REFERENCES tbl_restaurant_orders(restaurant_order_id)
) ;

CREATE TABLE tbl_delivery_assignments (
 assignment_id INT  PRIMARY KEY AUTO_INCREMENT,
 delivery_id INT NOT NULL,
 delivery_partner_id INT NOT NULL,
 assignment_status ENUM('OFFERED','ACCEPTED','REJECTED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'OFFERED',
 assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 accepted_at DATETIME NULL,
 completed_at DATETIME NULL,
 CONSTRAINT fk_da_delivery FOREIGN KEY(delivery_id) REFERENCES tbl_deliveries(delivery_id),
 CONSTRAINT fk_da_partner FOREIGN KEY(delivery_partner_id) REFERENCES tbl_delivery_partners(delivery_partner_id),
 INDEX idx_da_partner_status(delivery_partner_id,assignment_status)
);

CREATE TABLE tbl_delivery_status_history (
 delivery_status_history_id INT  PRIMARY KEY AUTO_INCREMENT,
 delivery_id INT NOT NULL,
 assignment_id INT NULL,
 previous_status VARCHAR(30),
 current_status VARCHAR(30) NOT NULL,
 updated_by INT NULL,
 remarks VARCHAR(255),
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_dsh_delivery FOREIGN KEY(delivery_id) REFERENCES tbl_deliveries(delivery_id),
 CONSTRAINT fk_dsh_assignment FOREIGN KEY(assignment_id) REFERENCES tbl_delivery_assignments(assignment_id),
 CONSTRAINT fk_dsh_user FOREIGN KEY(updated_by) REFERENCES tbl_users(user_id),
 INDEX idx_dsh_delivery_time(delivery_id,updated_at)
) ;

CREATE TABLE tbl_delivery_tracking (
 tracking_id INT  PRIMARY KEY AUTO_INCREMENT,
 delivery_id INT NOT NULL,
 delivery_partner_id INT NOT NULL,
 latitude DECIMAL(10,7) NOT NULL,
 longitude DECIMAL(11,7) NOT NULL,
 speed_kmh DECIMAL(6,2),
 recorded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_tracking_delivery FOREIGN KEY(delivery_id) REFERENCES tbl_deliveries(delivery_id),
 CONSTRAINT fk_tracking_partner FOREIGN KEY(delivery_partner_id) REFERENCES tbl_delivery_partners(delivery_partner_id),
 INDEX idx_tracking_delivery_time(delivery_id,recorded_at)
) ;

CREATE TABLE tbl_coupons (
 coupon_id INT AUTO_INCREMENT PRIMARY KEY,
 coupon_code VARCHAR(50) NOT NULL UNIQUE,
 description TEXT,
 discount_type ENUM('PERCENTAGE','FIXED') NOT NULL,
 discount_value DECIMAL(12,2) NOT NULL,
 minimum_order_value DECIMAL(12,2) NOT NULL DEFAULT 0,
 maximum_discount DECIMAL(12,2) NULL,
 total_usage_limit SMALLINT unsigned NULL,
 per_customer_usage_limit INT NOT NULL DEFAULT 1,
 valid_from DATETIME NOT NULL,
 valid_until DATETIME NOT NULL,
 is_active BOOLEAN NOT NULL DEFAULT TRUE,
 CONSTRAINT chk_coupon_value CHECK(discount_value > 0),
 CONSTRAINT chk_coupon_dates CHECK(valid_until > valid_from)
) ;

CREATE TABLE tbl_coupon_redemptions (
 redemption_id INT  PRIMARY KEY AUTO_INCREMENT,
 coupon_id INT NOT NULL,
 customer_id INT NOT NULL,
 order_id INT NOT NULL,
 discount_amount DECIMAL(12,2) NOT NULL,
 redemption_status ENUM('RESERVED','REDEEMED','REVERSED') NOT NULL DEFAULT 'RESERVED',
 redeemed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_cr_coupon FOREIGN KEY(coupon_id) REFERENCES tbl_coupons(coupon_id),
 CONSTRAINT fk_cr_order FOREIGN KEY(order_id) REFERENCES tbl_orders(order_id),
 UNIQUE KEY uk_coupon_order(coupon_id,order_id)
) ;

CREATE TABLE tbl_reviews (
 review_id INT PRIMARY KEY AUTO_INCREMENT,
 restaurant_order_id INT NOT NULL,
 rating INT NOT NULL,
 comments TEXT,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_review_restaurant_order FOREIGN KEY(restaurant_order_id) REFERENCES tbl_restaurant_orders(restaurant_order_id),
 CONSTRAINT chk_restaurant_rating CHECK(rating BETWEEN 1 AND 5),
 UNIQUE KEY uk_customer_restaurant_order_review(restaurant_order_id)
);

CREATE TABLE tbl_food_reviews (
 food_review_id INT PRIMARY KEY AUTO_INCREMENT,
 order_item_id INT NOT NULL,
 rating INT NOT NULL,
 comments TEXT,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_food_review_item FOREIGN KEY(order_item_id) REFERENCES tbl_order_items(order_item_id),
 CONSTRAINT chk_food_rating CHECK(rating BETWEEN 1 AND 5)
);

DESC tbl_roles;

DESC tbl_users;

DESC tbl_customers;

DESC tbl_order_items;

DESC tbl_restaurant_orders;

SHOW TABLES;

DESC tbl_delivery_partners;

DESC tbl_food_reviews;

DESC tbl_reviews;

DESC tbl_coupon_redemptions;

SELECT * FROM tbl_reviews;

ALTER TABLE tbl_reviews DROP FOREIGN KEY fk_review_customer; 
ALTER TABLE tbl_reviews DROP FOREIGN KEY fk_review_restaurant; 
ALTER TABLE tbl_reviews DROP FOREIGN KEY  fk_review_restaurant_order; 
ALTER TABLE tbl_reviews DROP CONSTRAINT uk_customer_restaurant_order_review; 

ALTER TABLE tbl_reviews ADD  CONSTRAINT fk_review_restaurant_order FOREIGN KEY(restaurant_order_id) REFERENCES tbl_restaurant_orders(restaurant_order_id);

ALTER TABLE tbl_reviews ADD  CONSTRAINT uk_customer_restaurant_order_review UNIQUE KEY (restaurant_order_id);

ALTER TABLE tbl_reviews DROP COLUMN  customer_id; 
ALTER TABLE tbl_reviews DROP COLUMN  restaurant_id; 


ALTER TABLE tbl_food_reviews DROP COLUMN  customer_id; 

ALTER TABLE tbl_coupon_redemptions DROP FOREIGN KEY fk_cr_customer; 
ALTER TABLE tbl_reviews DROP FOREIGN KEY fk_review_restaurant; 
ALTER TABLE tbl_reviews DROP FOREIGN KEY  fk_review_restaurant_order; 
ALTER TABLE tbl_reviews DROP CONSTRAINT uk_customer_restaurant_order_review; 
ALTER TABLE tbl_coupon_redemptions DROP INDEX idx_coupon_customer;