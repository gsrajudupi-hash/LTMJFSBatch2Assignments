USE food_delivery_db;

-- 1. CUSTOMER
INSERT INTO customer
(name, email, mobile_number, password_hash)
VALUES
('Rahul Sharma', 'rahul@gmail.com', '9876500001', 'hash_rahul'),
('Priya Reddy', 'priya@gmail.com', '9876500002', 'hash_priya'),
('Amit Kumar', 'amit@gmail.com', '9876500003', 'hash_amit'),
('Sneha Patil', 'sneha@gmail.com', '9876500004', 'hash_sneha'),
('Arjun Rao', 'arjun@gmail.com', '9876500005', 'hash_arjun');


-- 2. CUSTOMER_ADDRESS
INSERT INTO customer_address
(customer_id, address_line, city, state, postal_code, is_default)
VALUES
(1, 'Madhapur', 'Hyderabad', 'Telangana', '500081', TRUE),
(1, 'Kondapur', 'Hyderabad', 'Telangana', '500084', FALSE),
(2, 'Gachibowli', 'Hyderabad', 'Telangana', '500032', TRUE),
(3, 'Hitech City', 'Hyderabad', 'Telangana', '500081', TRUE),
(4, 'Kukatpally', 'Hyderabad', 'Telangana', '500072', TRUE),
(4, 'Miyapur', 'Hyderabad', 'Telangana', '500049', FALSE),
(5, 'Manikonda', 'Hyderabad', 'Telangana', '500089', TRUE);


-- 3. RESTAURANT
INSERT INTO restaurant
(name, address, city, state, postal_code,
 contact_number, email, opening_time, closing_time, is_active)
VALUES
('Spice Garden', 'Madhapur Main Road', 'Hyderabad',
 'Telangana', '500081', '9000000001',
 'spicegarden@gmail.com', '10:00:00', '23:00:00', TRUE),

('Pizza House', 'Gachibowli Road', 'Hyderabad',
 'Telangana', '500032', '9000000002',
 'pizzahouse@gmail.com', '11:00:00', '23:30:00', TRUE),

('South Indian Kitchen', 'Kondapur Main Road', 'Hyderabad',
 'Telangana', '500084', '9000000003',
 'southkitchen@gmail.com', '07:00:00', '22:00:00', TRUE);

-- 4. FOOD_CATEGORY
INSERT INTO food_category (category_name)
VALUES
('Biryani'),
('Pizza'),
('South Indian'),
('Desserts'),
('Beverages');


-- 5. MENU_ITEM
INSERT INTO menu_item
(restaurant_id, category_id, name, description,
 price, is_vegetarian, is_available)
VALUES
(1, 1, 'Chicken Biryani', 'Chicken dum biryani',
 280.00, FALSE, TRUE),

(1, 1, 'Veg Biryani', 'Vegetable dum biryani',
 220.00, TRUE, TRUE),

(1, 4, 'Double Ka Meetha', 'Traditional dessert',
 120.00, TRUE, TRUE),

(2, 2, 'Margherita Pizza', 'Cheese and tomato pizza',
 250.00, TRUE, TRUE),

(2, 2, 'Chicken Pizza', 'Chicken and cheese pizza',
 350.00, FALSE, TRUE),

(2, 5, 'Coke', 'Soft drink',
 60.00, TRUE, TRUE),

(3, 3, 'Masala Dosa', 'Dosa with potato masala',
 120.00, TRUE, TRUE),

(3, 3, 'Idli', 'Steamed rice cakes',
 80.00, TRUE, TRUE),

(3, 5, 'Filter Coffee', 'South Indian filter coffee',
 50.00, TRUE, TRUE);


-- 6. CART
INSERT INTO cart (customer_id)
VALUES
(1),
(2),
(3),
(4),
(5);


-- 7. CART_ITEM
INSERT INTO cart_item
(cart_id, menu_item_id, quantity)
VALUES
(1, 1, 2),
(1, 3, 1),
(2, 4, 1),
(2, 6, 2),
(5, 7, 2);


-- 8. ORDERS
INSERT INTO orders
(customer_id, restaurant_id, address_id, ordered_at, status,
 subtotal, delivery_charge, discount, final_amount,
 estimated_delivery_at)
VALUES
(1, 1, 1, '2026-11-15 12:30:00', 'DELIVERED',
 680.00, 40.00, 100.00, 620.00, '2026-11-15 13:15:00'),

(2, 2, 3, '2026-11-16 19:00:00', 'DELIVERED',
 370.00, 30.00, 50.00, 350.00, '2026-11-16 19:45:00'),

(3, 3, 4, '2026-11-17 09:00:00', 'DELIVERED',
 250.00, 30.00, 0.00, 280.00, '2026-11-17 09:40:00'),

(1, 2, 2, '2026-11-18 20:00:00', 'CANCELLED',
 350.00, 30.00, 0.00, 380.00, '2026-11-18 20:45:00'),

(4, 1, 5, '2026-11-19 13:00:00', 'OUT_FOR_DELIVERY',
 560.00, 40.00, 50.00, 550.00, '2026-11-19 13:50:00'),

(5, 3, 7, '2026-11-20 08:30:00', 'PREPARING',
 240.00, 30.00, 0.00, 270.00, '2026-11-20 09:10:00');

-- 9. ORDER_ITEM
INSERT INTO order_item
(order_id, menu_item_id, quantity, unit_price_at_order)
VALUES
(1, 1, 2, 280.00),
(1, 3, 1, 120.00),

(2, 4, 1, 250.00),
(2, 6, 2, 60.00),

(3, 7, 1, 120.00),
(3, 8, 1, 80.00),
(3, 9, 1, 50.00),

(4, 5, 1, 350.00),

(5, 1, 2, 280.00),

(6, 7, 2, 120.00);


-- 10. PAYMENT
INSERT INTO payment
(order_id, method, status, amount,
 payment_date, transaction_reference)
VALUES
(1, 'UPI', 'SUCCESS', 620.00,
 '2026-11-15 12:31:00', 'TXN1001'),

(2, 'CREDIT_CARD', 'SUCCESS', 350.00,
 '2026-11-16 19:01:00', 'TXN1002'),

(3, 'CASH', 'SUCCESS', 280.00,
 '2026-11-17 09:35:00', 'TXN1003'),

(4, 'UPI', 'REFUNDED', 380.00,
 '2026-11-18 20:01:00', 'TXN1004'),

(5, 'UPI', 'SUCCESS', 550.00,
 '2026-11-19 13:01:00', 'TXN1005'),

(6, 'CASH', 'PENDING', 270.00,
 '2026-11-20 08:30:00', NULL);


-- 11. DELIVERY_PARTNER
INSERT INTO delivery_partner
(name, mobile_number, vehicle_details, availability_status)
VALUES
('Ravi Kumar', '9000010001',
 'Bike - TS09AB1234', 'AVAILABLE'),

('Suresh Rao', '9000010002',
 'Bike - TS10CD5678', 'ASSIGNED'),

('Kiran Patel', '9000010003',
 'Scooter - TS11EF9012', 'AVAILABLE');


-- 12. DELIVERY_ASSIGNMENT
INSERT INTO delivery_assignment
(order_id, partner_id, assignment_status, delivery_status,
 assigned_at, pickup_at, delivered_at)
VALUES
(1, 1, 'COMPLETED', 'DELIVERED',
 '2026-11-15 12:45:00',
 '2026-11-15 12:55:00',
 '2026-11-15 13:10:00'),

(2, 3, 'COMPLETED', 'DELIVERED',
 '2026-11-16 19:10:00',
 '2026-11-16 19:20:00',
 '2026-11-16 19:40:00'),

(3, 1, 'COMPLETED', 'DELIVERED',
 '2026-11-17 09:10:00',
 '2026-11-17 09:20:00',
 '2026-11-17 09:35:00'),

(5, 2, 'ACCEPTED', 'OUT_FOR_DELIVERY',
 '2026-11-19 13:15:00',
 '2026-11-19 13:30:00',
 NULL);


-- 13. ORDER_STATUS_HISTORY
INSERT INTO order_status_history
(order_id, status, changed_at)
VALUES
(1, 'PLACED', '2026-11-15 12:30:00'),
(1, 'CONFIRMED', '2026-11-15 12:35:00'),
(1, 'PREPARING', '2026-11-15 12:40:00'),
(1, 'READY_FOR_PICKUP', '2026-11-15 12:50:00'),
(1, 'OUT_FOR_DELIVERY', '2026-11-15 12:55:00'),
(1, 'DELIVERED', '2026-11-15 13:10:00'),

(2, 'PLACED', '2026-11-16 19:00:00'),
(2, 'CONFIRMED', '2026-11-16 19:05:00'),
(2, 'PREPARING', '2026-11-16 19:10:00'),
(2, 'OUT_FOR_DELIVERY', '2026-11-16 19:20:00'),
(2, 'DELIVERED', '2026-11-16 19:40:00'),

(3, 'PLACED', '2026-11-17 09:00:00'),
(3, 'CONFIRMED', '2026-11-17 09:05:00'),
(3, 'OUT_FOR_DELIVERY', '2026-11-17 09:20:00'),
(3, 'DELIVERED', '2026-11-17 09:35:00'),

(4, 'PLACED', '2026-11-18 20:00:00'),
(4, 'CANCELLED', '2026-11-18 20:05:00'),

(5, 'PLACED', '2026-11-19 13:00:00'),
(5, 'CONFIRMED', '2026-11-19 13:05:00'),
(5, 'PREPARING', '2026-11-19 13:10:00'),
(5, 'OUT_FOR_DELIVERY', '2026-11-19 13:30:00'),

(6, 'PLACED', '2026-11-20 08:30:00'),
(6, 'CONFIRMED', '2026-11-20 08:35:00'),
(6, 'PREPARING', '2026-11-20 08:40:00');



-- 14. REVIEW
INSERT INTO review
(order_id, menu_item_id, rating, feedback)
VALUES
-- Restaurant reviews
(1, NULL, 5, 'Excellent food and quick delivery'),
(2, NULL, 4, 'Pizza was very good'),
(3, NULL, 5, 'Fresh and tasty food'),

-- Food reviews
(1, 1, 5, 'Biryani was excellent'),
(1, 3, 4, 'Dessert was good'),
(2, 4, 4, 'Pizza tasted great'),
(3, 7, 5, 'Masala dosa was excellent'),
(3, 8, 4, 'Idli was fresh');


-- 15. COUPON
INSERT INTO coupon
(code, discount_type, discount_value,
 valid_from, valid_until, min_order_value,
 max_discount, total_usage_limit, per_customer_limit)
VALUES
('WELCOME100', 'FIXED', 100.00,
 '2026-01-01 00:00:00', '2026-12-31 23:59:59',
 500.00, 100.00, 1000, 1),

('SAVE50', 'FIXED', 50.00,
 '2026-01-01 00:00:00', '2026-12-31 23:59:59',
 300.00, 50.00, 500, 2),

('FOOD20', 'PERCENTAGE', 20.00,
 '2026-01-01 00:00:00', '2026-12-31 23:59:59',
 200.00, 100.00, 1000, 3);


-- 16. COUPON_REDEMPTION
INSERT INTO coupon_redemption
(coupon_id, order_id, discount_amount)
VALUES
(1, 1, 100.00),
(2, 2, 50.00),
(2, 5, 50.00);


-- 17. REFUND
INSERT INTO refund
(payment_id, refund_amount, refund_status,
 refund_date, refund_reference)
VALUES
(4, 380.00, 'PROCESSED',
 '2026-11-18 20:10:00', 'REF1004');
 