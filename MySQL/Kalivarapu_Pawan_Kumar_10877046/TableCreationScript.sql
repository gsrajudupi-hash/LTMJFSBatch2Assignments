CREATE DATABASE food_delivery_app;

USE food_delivery_app

-- 1.Customer Table

CREATE TABLE CUSTOMER(
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50),
	email VARCHAR(100) NOT NULL UNIQUE,
	mobile_number VARCHAR(10) NOT NULL UNIQUE,
	PASSWORD VARCHAR(50) NOT NULL 
);

DESC customer



-- 2.Customer Address

CREATE TABLE Customer_Address(
	address_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT,
	address_lane1 VARCHAR(150) NOT NULL,
	address_lane2 VARCHAR(150),
	city VARCHAR(100) NOT NULL,
	state VARCHAR(100) NOT NULL,
	pincode VARCHAR(10) NOT NULL,
	is_default BOOLEAN NOT NULL DEFAULT FALSE,
	
	CONSTRAINT fk_customer_address_customer
	FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

DESC customer_address

-- 3. Restaurant Table

CREATE TABLE Restaurant(
	restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	contact VARCHAR(15) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	start_time TIME NOT NULL,
	end_time TIME NOT NULL,
	restaurant_active VARCHAR(10) NOT NULL DEFAULT 'Active',
	rating DECIMAL(2,1),
	
	CONSTRAINT chk_restaurant_rating
	CHECK(rating BETWEEN 0 AND 5),
	
	CONSTRAINT chk_restaurant_active_status
	CHECK(restaurant_active IN('Active','Inactive'))
)

DESC restaurant


-- 4. Food Category

	CREATE TABLE Food_Category(
		category_id INT AUTO_INCREMENT PRIMARY KEY,
		category_name VARCHAR(50) NOT NULL UNIQUE
	)
	
	DESC Food_Category
	
-- 5. Food Item
	
	CREATE TABLE Food_Item(
		food_item_id INT AUTO_INCREMENT PRIMARY KEY,
		restaurant_id INT NOT NULL,
		category_id INT NOT NULL,
		food_name VARCHAR(100) NOT NULL,
		food_description VARCHAR(255),
		food_price DECIMAL(10,2) NOT NULL,
		food_type VARCHAR(10) NOT NULL,
		availability VARCHAR(15) DEFAULT 'Available',
		
		CONSTRAINT fk_food_item_restaurant
		FOREIGN KEY(restaurant_id)
		REFERENCES restaurant(restaurant_id),
		
		CONSTRAINT fk_food_item_category
		FOREIGN KEY(category_id)
		REFERENCES Food_Category(category_id),
		
		CONSTRAINT ck_availability
		CHECK(availability IN ('Available','Not Available')),
		
		CONSTRAINT ck_type
		CHECK(food_type IN('Veg','Non Veg')),
		
		CONSTRAINT ck_price
		CHECK(food_price>=0)
	)
	
	DESC food_item
	
-- 6. Cart

	CREATE TABLE Cart(
		cart_id INT AUTO_INCREMENT PRIMARY KEY,
		customer_id INT NOT NULL,
		active BOOLEAN NOT NULL DEFAULT TRUE,
		
		CONSTRAINT fk_cart_customer
		FOREIGN KEY(customer_id)
		REFERENCES customer(customer_id)
		
	)
	
	DESC cart
	
-- 7. Cart_Item
	
	CREATE TABLE Cart_Item(
		cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
		cart_id INT NOT NULL,
		food_item_id INT NOT NULL,
		quantity INT NOT NULL,
		
		CONSTRAINT fk_cart_item_cart
		FOREIGN KEY(cart_id)
		REFERENCES Cart(cart_id),
		
		CONSTRAINT fk_cart_item_food_item
		FOREIGN KEY(food_item_id)
		REFERENCES Food_Item(food_item_id),
		
		CONSTRAINT ck_quantity
		CHECK(quantity>0),
		
		CONSTRAINT uq_cart_food_item
		UNIQUE(cart_id,food_item_id)
	)
	
	DESC cart_item
	
-- 8. Coupon
	
	CREATE TABLE Coupon(
		coupon_id INT AUTO_INCREMENT PRIMARY KEY,
		coupon_code VARCHAR(50) NOT NULL UNIQUE,
		discount_type VARCHAR(20) NOT NULL,
		discount_value DECIMAL(10,2) NOT NULL,
		minimum_order_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
		valid_from DATETIME NOT NULL,
		valid_till DATETIME NOT NULL,
		isactive BOOLEAN NOT NULL DEFAULT FALSE,
		
		CONSTRAINT ck_coupon_discount_type
        CHECK (discount_type IN ('PERCENTAGE', 'FLAT')),

    	CONSTRAINT ck_coupon_discount_value
        CHECK (discount_value > 0),

    	CONSTRAINT ck_coupon_minimum_amount
        CHECK (minimum_order_amount >= 0),

    	CONSTRAINT ck_coupon_dates
        CHECK (valid_till > valid_from)
	)
	
	DESC coupon
	
	
-- 9. Orders

	CREATE TABLE Orders(
		order_id INT AUTO_INCREMENT PRIMARY KEY,
		customer_id INT NOT NULL,
		coupon_id INT,
		restaurant_id INT NOT NULL,
		address_id INT NOT NULL,
		ordertime DATETIME NOT NULL,
		sub_total DECIMAL(10,2) NOT NULL,
		delivery_charges DECIMAL(10,2) NOT NULL,
		discount_amount DECIMAL(10,2) NOT NULL,
		final_amount DECIMAL(10,2) NOT NULL,
		
		CONSTRAINT fk_customer_order
		FOREIGN KEY(customer_id)
		REFERENCES customer(customer_id),
		
		CONSTRAINT fk_coupon_order
		FOREIGN KEY(coupon_id)
		REFERENCES Coupon(coupon_id),
		
		CONSTRAINT fk_restaurant_order
		FOREIGN KEY(restaurant_id)
		REFERENCES Restaurant(restaurant_id),
		
		CONSTRAINT fk_address_order
		FOREIGN KEY(address_id)
		REFERENCES Customer_Address(address_id),
		
		CONSTRAINT ck_order_subtotal
        CHECK (sub_total >= 0),

    CONSTRAINT ck_order_delivery_charges
        CHECK (delivery_charges >= 0),

    CONSTRAINT ck_order_discount
        CHECK (discount_amount >= 0),

    CONSTRAINT ck_order_final_amount
        CHECK (final_amount >= 0)
		
	)
	
	DESC orders
	
-- 10. Order_Item
	
	CREATE TABLE Order_Item(
		order_item_id INT AUTO_INCREMENT PRIMARY KEY,
		order_id INT NOT NULL,
		food_item_id INT NOT NULL,
		quantity INT NOT NULL,
		item_price DECIMAL(10,2) NOT NULL,
		
		CONSTRAINT fk_order_order_item
		FOREIGN KEY(order_id)
		REFERENCES Orders(order_id),
		
		CONSTRAINT fk_food_item_order
		FOREIGN KEY(food_item_id)
		REFERENCES Food_Item(food_item_id),
		
		CONSTRAINT ck_order_item_quantity
        CHECK (quantity > 0),
        
      CONSTRAINT ck_item_price
        CHECK (item_price >= 0),
        
      CONSTRAINT uq_order_food_item
        UNIQUE (order_id, food_item_id)
	)
	
	DESC order_item
	
	
-- 11. Payment

	CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    reference_id VARCHAR(100) NOT NULL UNIQUE,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    payment_type VARCHAR(30) NOT NULL,

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT ck_payment_amount
        CHECK (payment_amount >= 0),

    CONSTRAINT ck_payment_status
        CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED')),

    CONSTRAINT ck_payment_type
        CHECK (payment_type IN ('UPI', 'CARD', 'CASH', 'NET_BANKING'))
);


-- 12. Delivery Partner
	
	CREATE TABLE delivery_partner (
    delivery_partner_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    mobile_number VARCHAR(15) NOT NULL UNIQUE,
    availability BOOLEAN NOT NULL DEFAULT TRUE
);


-- 13. Vehicle Details
	
	CREATE TABLE vehicle_details (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    delivery_partner_id INT NOT NULL,
    vehicle_type VARCHAR(30) NOT NULL,
    vehicle_number VARCHAR(20) NOT NULL UNIQUE,
    vehicle_model VARCHAR(50),
    vehicle_status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_vehicle_delivery_partner
        FOREIGN KEY (delivery_partner_id)
        REFERENCES delivery_partner(delivery_partner_id),

    CONSTRAINT ck_vehicle_status
        CHECK (vehicle_status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE'))
);


-- 14. Delivery

	CREATE TABLE delivery (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    delivery_partner_id INT NOT NULL,
    assignment_status VARCHAR(20) NOT NULL,
    pickup_time DATETIME,
    estimated_delivery_time DATETIME,
    delivery_time DATETIME,
    delivery_status VARCHAR(30) NOT NULL,

    CONSTRAINT fk_delivery_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_delivery_partner
        FOREIGN KEY (delivery_partner_id)
        REFERENCES delivery_partner(delivery_partner_id),

    CONSTRAINT ck_assignment_status
        CHECK (
            assignment_status IN ('ASSIGNED', 'ACCEPTED', 'REJECTED')
        ),

    CONSTRAINT ck_delivery_status
        CHECK (
            delivery_status IN (
                'PENDING',
                'PICKED_UP',
                'OUT_FOR_DELIVERY',
                'DELIVERED',
                'CANCELLED'
            )
        )
);


-- 15. Order_Status_History

	CREATE TABLE order_status_history (
    order_status_history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status VARCHAR(30) NOT NULL,
    status_updated_at DATETIME NOT NULL,

    CONSTRAINT fk_status_history_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT ck_order_status
        CHECK (
            status IN (
                'PLACED',
                'CONFIRMED',
                'PREPARING',
                'READY_FOR_PICKUP',
                'OUT_FOR_DELIVERY',
                'DELIVERED',
                'CANCELLED'
            )
        )
);



-- 16. FeedBack

	CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    restaurant_id INT,
    food_item_id INT,
    rating INT NOT NULL,
    comments VARCHAR(500),
    feedback_date DATETIME NOT NULL,

    CONSTRAINT fk_feedback_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    CONSTRAINT fk_feedback_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_feedback_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id),

    CONSTRAINT fk_feedback_food_item
        FOREIGN KEY (food_item_id)
        REFERENCES food_item(food_item_id),

    CONSTRAINT ck_feedback_rating
        CHECK (rating BETWEEN 1 AND 5),

    CONSTRAINT ck_feedback_target
        CHECK (
            restaurant_id IS NOT NULL
            OR food_item_id IS NOT NULL
        )
);


-- 17. Coupon Redemption

	CREATE TABLE coupon_redemption (
    redemption_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_id INT NOT NULL UNIQUE,
    redeemed_at DATETIME NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_redemption_coupon
        FOREIGN KEY (coupon_id)
        REFERENCES coupon(coupon_id),

    CONSTRAINT fk_redemption_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id),

    CONSTRAINT fk_redemption_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT ck_redemption_discount
        CHECK (discount_amount >= 0)
);


-- 18. Refund

	CREATE TABLE refund (
    refund_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    refund_amount DECIMAL(10,2) NOT NULL,
    refund_date DATETIME NOT NULL,
    refund_status VARCHAR(20) NOT NULL,
    refund_reference_id VARCHAR(100) UNIQUE,
    refund_reason VARCHAR(255),

    CONSTRAINT fk_refund_payment
        FOREIGN KEY (payment_id)
        REFERENCES payment(payment_id),

    CONSTRAINT ck_refund_amount
        CHECK (refund_amount > 0),

    CONSTRAINT ck_refund_status
        CHECK (
            refund_status IN ('PENDING', 'PROCESSED', 'FAILED')
        )
);

-- 19. Restaurant Address

	CREATE TABLE restaurant_address (
    restaurant_address_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    address_line1 VARCHAR(150) NOT NULL,
    address_line2 VARCHAR(150),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10) NOT NULL,

    CONSTRAINT fk_restaurant_address
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurant(restaurant_id)
);

SHOW tables















