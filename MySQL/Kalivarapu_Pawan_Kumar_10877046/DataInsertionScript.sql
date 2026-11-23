
-- 1.Customer table insertion

INSERT INTO customer
(first_name, last_name, email, mobile_number, password)
VALUES
('Pawan', 'Kumar', 'kpk@gmail.com', '9876500001', 'hash_password_1'),
('Priya', 'Reddy', 'priya@gmail.com', '9876500002', 'hash_password_2'),
('Hima', 'Patel', 'hima@gmail.com', '9876500003', 'hash_password_3'),
('Kiran', 'Kumar', 'kiran@gmail.com', '9876500004', 'hash_password_4'),
('Bheema', 'Rao', 'Bheema@gmail.com', '9876500005', 'hash_password_5');



-- 2. Customer address insertion

	INSERT INTO customer_address
(customer_id, address_lane1, address_lane2, city, state, pincode, is_default)
VALUES
(1, 'Madhapur Main Road', NULL, 'Hyderabad', 'Telangana', '500081', TRUE),
(1, 'Hitech City Road', 'Near Cyber Towers', 'Hyderabad', 'Telangana', '500084', FALSE),

(2, 'Banjara Hills Road No 12', NULL, 'Hyderabad', 'Telangana', '500034', TRUE),

(3, 'Kondapur Main Road', NULL, 'Hyderabad', 'Telangana', '500084', TRUE),

(4, 'Gachibowli Main Road', 'Near DLF', 'Hyderabad', 'Telangana', '500032', TRUE),

(5, 'Kukatpally Main Road', NULL, 'Hyderabad', 'Telangana', '500072', TRUE);


-- 3. Restaurant insertion

INSERT INTO restaurant
(name, contact, email, start_time, end_time, restaurant_active, rating)
VALUES
('Mehfil Gachibowli', '9000000001', 'mehfil@gmail.com', '09:30:00', '22:00:00', 'ACTIVE', 4.5),
('Paradise', '9000000002', 'paradise@gmail.com', '10:00:00', '22:30:00', 'ACTIVE', 4.2),
('Shah Gouse', '9000000003', 'shah@gmail.com', '08:00:00', '22:00:00', 'ACTIVE', 3.9);


-- 4. Food Category

INSERT INTO food_category (category_name)
VALUES
('Biryani'),
('Pizza'),
('Dessert');


-- 5. Food Item

INSERT INTO food_item
(restaurant_id, category_id, food_name, food_description,
 food_price, food_type, availability)
VALUES
(1, 1, 'Chicken Biryani', 'Chicken dum biryani', 175.00, 'Non Veg', 'Available'),
(2, 2, 'Margherita Pizza', 'Cheese pizza', 220.00, 'Veg', 'Available'),
(3, 3, 'Chocolate Brownie', 'Chocolate brownie', 120.00, 'Veg', 'Available');


SELECT * FROM restaurant;
SELECT * FROM food_category;
SELECT * FROM food_item;


-- 6. Cart

INSERT INTO cart (customer_id, active)
VALUES
(1, TRUE),
(2, TRUE),
(3, FALSE);

-- 7. Cart_Item 

INSERT INTO cart_item (cart_id, food_item_id, quantity)
VALUES
(1, 1, 3),
(1, 2, 2),
(2, 3, 2);

-- 8. Coupon

INSERT INTO coupon
(coupon_code, discount_type, discount_value,
 minimum_order_amount, valid_from, valid_till, isactive)
VALUES
('SAVE50', 'FLAT', 50.00, 300.00,
 '2026-11-17 00:00:00', '2026-11-25 23:59:59', TRUE),

('SAVE10', 'PERCENTAGE', 10.00, 500.00,
 '2026-11-25 00:00:00', '2026-11-30 23:59:59', TRUE);
 
 
 -- 9. Orders
 
 	INSERT INTO orders
(customer_id, coupon_id, restaurant_id, address_id, ordertime,
 sub_total, delivery_charges, discount_amount, final_amount)
VALUES
(1, 3, 1, 1, '2026-11-17 12:30:00',
 500.00, 40.00, 50.00, 490.00),

(2, NULL, 2, 3, '2026-11-17 14:15:00',
 220.00, 30.00, 0.00, 250.00),

(3, 4, 3, 4, '2026-11-17 19:00:00',
 600.00, 40.00, 60.00, 580.00);
 
 
 SELECT customer_id FROM customer;
SELECT address_id, customer_id FROM customer_address;
SELECT restaurant_id FROM restaurant;
SELECT food_item_id FROM food_item;
SELECT coupon_id FROM coupon;


SELECT order_id, customer_id, restaurant_id, final_amount
FROM orders;


-- 10 .order item

INSERT INTO order_item
(order_id, food_item_id, quantity, item_price)
VALUES
(1, 1, 2, 250.00),
(2, 2, 1, 220.00),
(3, 3, 5, 120.00);


-- 11. Payment

INSERT INTO payment
(order_id, reference_id, payment_amount, payment_date, status, payment_type)
VALUES
(1, 'TXN1001', 490.00, '2026-11-17 12:31:00', 'SUCCESS', 'UPI'),

(2, 'TXN1002', 250.00, '2026-11-17 14:16:00', 'SUCCESS', 'CARD'),

(3, 'TXN1003', 580.00, '2026-11-17 19:01:00', 'SUCCESS', 'UPI');


-- 12. Delivery Partner

INSERT INTO delivery_partner
(first_name, last_name, mobile_number, availability)
VALUES
('Pawan', 'Kalyan', '9000010001', TRUE),
('Kiran', 'Abhavaram', '9000010002', TRUE);


-- 13. Vehicle Details

INSERT INTO vehicle_details
(delivery_partner_id, vehicle_type, vehicle_number, vehicle_model, vehicle_status)
VALUES
(1, 'BIKE', 'TS09AB1234', 'Royal Enfield', 'ACTIVE'),
(2, 'SCOOTER', 'TS10CD5678', 'Activa 6G', 'ACTIVE');


-- 14. Delivery

INSERT INTO delivery
(order_id, delivery_partner_id, assignment_status,
 pickup_time, estimated_delivery_time, delivery_time, delivery_status)
VALUES
(1, 1, 'ACCEPTED',
 '2026-11-17 12:50:00',
 '2026-11-17 13:30:00',
 '2026-11-17 13:20:00',
 'DELIVERED'),

(2, 2, 'ACCEPTED',
 '2026-11-17 14:35:00',
 '2026-11-17 15:15:00',
 '2026-11-17 15:10:00',
 'DELIVERED'),

(3, 1, 'ACCEPTED',
 '2026-11-17 19:20:00',
 '2026-11-17 20:00:00',
 NULL,
 'OUT_FOR_DELIVERY');
 
 
 -- 15. Order Status History
 
 	INSERT INTO order_status_history
(order_id, status, status_updated_at)
VALUES
(1, 'PLACED', '2026-11-17 12:30:00'),
(1, 'CONFIRMED', '2026-11-17 12:35:00'),
(1, 'PREPARING', '2026-11-17 12:40:00'),
(1, 'OUT_FOR_DELIVERY', '2026-11-17 12:55:00'),
(1, 'DELIVERED', '2026-11-17 13:20:00'),

(2, 'PLACED', '2026-11-17 14:15:00'),
(2, 'CONFIRMED', '2026-11-17 14:20:00'),
(2, 'DELIVERED', '2026-11-17 15:10:00'),

(3, 'PLACED', '2026-11-17 19:00:00'),
(3, 'CONFIRMED', '2026-11-17 19:05:00'),
(3, 'OUT_FOR_DELIVERY', '2026-11-17 19:25:00');


-- 16. FeedBack

INSERT INTO feedback
(customer_id, order_id, restaurant_id, food_item_id,
 rating, comments, feedback_date)
VALUES
(1, 1, 1, 1, 5, 'Very good food and delivery',
 '2026-11-17 14:00:00'),

(2, 2, 2, 2, 4, 'Good pizza',
 '2026-11-17 16:00:00');


-- 17. Coupon Redemption

INSERT INTO coupon_redemption
(coupon_id, customer_id, order_id, redeemed_at, discount_amount)
VALUES
(3, 1, 1, '2026-11-17 12:30:00', 50.00),
(4, 3, 3, '2026-11-17 19:00:00', 60.00);

-- 18. Refund

INSERT INTO refund
(payment_id, refund_amount, refund_date,
 refund_status, refund_reference_id, refund_reason)
VALUES
(2, 50.00, '2026-11-17 16:30:00',
 'PROCESSED', 'REF1001', 'Bad Taste');
 
 
 -- 19. Restaurant Address
 
 INSERT INTO restaurant_address
(restaurant_id, address_line1, address_line2, city, state, pincode)
VALUES
(1, 'Madhapur Main Road', NULL, 'Hyderabad', 'Telangana', '500081'),
(2, 'Hitech City Road', 'Near Cyber Towers', 'Hyderabad', 'Telangana', '500084'),
(3, 'Gachibowli Main Road', NULL, 'Hyderabad', 'Telangana', '500032');



















