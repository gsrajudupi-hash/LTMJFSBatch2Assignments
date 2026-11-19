USE food_delivery_db;
 
-- ==========================================
-- 1. CUSTOMERS
-- ==========================================
 
INSERT INTO customers
(customer_id, customer_name, email, mobile, password_hash, is_active)
VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com', '9876500001', 'demo_hash_1', TRUE),
(2, 'Priya Reddy', 'priya@gmail.com', '9876500002', 'demo_hash_2', TRUE),
(3, 'Kiran Kumar', 'kiran@gmail.com', '9876500003', 'demo_hash_3', TRUE),
(4, 'Sneha Rao', 'sneha@gmail.com', '9876500004', 'demo_hash_4', TRUE),
(5, 'Arjun Patel', 'arjun@gmail.com', '9876500005', 'demo_hash_5', TRUE),
(6, 'Ananya Singh', 'ananya@gmail.com', '9876500006', 'demo_hash_6', TRUE),
(7, 'Vikram Das', 'vikram@gmail.com', '9876500007', 'demo_hash_7', TRUE),
(8, 'Meera Nair', 'meera@gmail.com', '9876500008', 'demo_hash_8', TRUE);
 
 
-- ==========================================
-- 2. CUSTOMER ADDRESSES
-- ==========================================
 
INSERT INTO customer_addresses
(address_id, customer_id, address_type, address_line, city, state, pincode, is_default)
VALUES
(1, 1, 'HOME', 'Madhapur', 'Hyderabad', 'Telangana', '500081', TRUE),
(2, 1, 'OFFICE', 'Hitech City', 'Hyderabad', 'Telangana', '500032', FALSE),
(3, 2, 'HOME', 'Kukatpally', 'Hyderabad', 'Telangana', '500072', TRUE),
(4, 3, 'HOME', 'Gachibowli', 'Hyderabad', 'Telangana', '500032', TRUE),
(5, 4, 'HOME', 'Ameerpet', 'Hyderabad', 'Telangana', '500016', TRUE),
(6, 5, 'HOME', 'Miyapur', 'Hyderabad', 'Telangana', '500049', TRUE),
(7, 6, 'HOME', 'Kondapur', 'Hyderabad', 'Telangana', '500084', TRUE);
 
 
-- ==========================================
-- 3. RESTAURANTS
-- ==========================================
 
INSERT INTO restaurants
(restaurant_id, restaurant_name, address, city, contact_number, email,
opening_time, closing_time, is_active)
VALUES
(1, 'Hyderabad Biryani House', 'Madhapur', 'Hyderabad',
'9000000001', 'biryani@gmail.com', '10:00:00', '23:00:00', TRUE),
 
(2, 'Spice Garden', 'Kukatpally', 'Hyderabad',
'9000000002', 'spice@gmail.com', '09:00:00', '22:00:00', TRUE),
 
(3, 'Food Express', 'Gachibowli', 'Hyderabad',
'9000000003', 'express@gmail.com', '10:00:00', '23:00:00', TRUE),
 
(4, 'Sweet Treats', 'Ameerpet', 'Hyderabad',
'9000000004', 'sweets@gmail.com', '09:00:00', '21:00:00', TRUE);
 
 
-- ==========================================
-- 4. FOOD CATEGORIES
-- ==========================================
 
INSERT INTO food_categories
(category_id, category_name, description)
VALUES
(1, 'North Indian', 'North Indian dishes'),
(2, 'South Indian', 'South Indian dishes'),
(3, 'Paneer Specials', 'Paneer based dishes'),
(4, 'Chinese', 'Chinese food items'),
(5, 'Fast Food', 'Burgers and snacks'),
(6, 'Desserts', 'Sweets and beverages');
 
 
-- ==========================================
-- 5. MENU ITEMS
-- ==========================================
 
INSERT INTO menu_items
(menu_item_id, restaurant_id, category_id, food_name,
description, price, food_type, is_available)
VALUES
(1, 1, 1, 'Paneer Biryani', 'Special paneer biryani',
150.00, 'VEG', TRUE),
 
(2, 1, 2, 'Masala Dosa', 'Crispy masala dosa',
200.00, 'VEG', TRUE),
 
(3, 1, 1, 'Chicken Biryani', 'Hyderabadi chicken biryani',
250.00, 'NON_VEG', TRUE),
 
(4, 2, 3, 'Paneer Butter Masala', 'Creamy paneer curry',
220.00, 'VEG', TRUE),
 
(5, 2, 4, 'Veg Noodles', 'Chinese vegetable noodles',
140.00, 'VEG', TRUE),
 
(6, 2, 4, 'Chicken Noodles', 'Spicy chicken noodles',
250.00, 'NON_VEG', TRUE),
 
(7, 3, 5, 'Veg Burger', 'Fresh vegetable burger',
180.00, 'VEG', TRUE),
 
(8, 3, 5, 'French Fries', 'Crispy french fries',
80.00, 'VEG', TRUE),
 
(9, 3, 6, 'Gulab Jamun', 'Traditional Indian sweet',
70.00, 'VEG', TRUE),
 
(10, 4, 6, 'Cold Coffee', 'Chilled cold coffee',
120.00, 'VEG', TRUE);
 
 
-- ==========================================
-- 6. CARTS
-- ==========================================
 
INSERT INTO carts (cart_id, customer_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);
 
 
-- ==========================================
-- 7. CART ITEMS
-- ==========================================
 
INSERT INTO cart_items
(cart_item_id, cart_id, menu_item_id, quantity)
VALUES
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 3, 1),
(4, 2, 4, 1),
(5, 3, 5, 2),
(6, 4, 7, 1),
(7, 5, 8, 3),
(8, 6, 9, 2);
 
 
-- ==========================================
-- 8. DELIVERY PARTNERS
-- ==========================================
 
INSERT INTO delivery_partners
(partner_id, partner_name, mobile, vehicle_number,
vehicle_type, availability_status)
VALUES
(1, 'Ramesh Kumar', '9111100001', 'TS09AB1234',
'Bike', 'AVAILABLE'),
 
(2, 'Suresh Reddy', '9111100002', 'TS09CD5678',
'Bike', 'AVAILABLE');
 
 
-- ==========================================
-- 9. ORDERS
-- ==========================================
 
INSERT INTO orders
(order_id, customer_id, restaurant_id, address_id,
delivery_address, order_date, subtotal,
delivery_charge, discount_amount, total_amount, order_status)
VALUES
(1, 1, 1, 1, 'Madhapur, Hyderabad', '2026-11-01 12:00:00',
500.00, 40.00, 0.00, 540.00, 'DELIVERED'),
 
(2, 1, 1, 1, 'Madhapur, Hyderabad', '2026-11-02 13:00:00',
300.00, 40.00, 50.00, 290.00, 'DELIVERED'),
 
(3, 2, 1, 3, 'Kukatpally, Hyderabad', '2026-11-03 14:00:00',
450.00, 40.00, 0.00, 490.00, 'DELIVERED'),
 
(4, 2, 2, 3, 'Kukatpally, Hyderabad', '2026-11-04 12:30:00',
360.00, 40.00, 0.00, 400.00, 'DELIVERED'),
 
(5, 3, 2, 4, 'Gachibowli, Hyderabad', '2026-11-05 19:00:00',
500.00, 40.00, 0.00, 540.00, 'DELIVERED'),
 
(6, 4, 2, 5, 'Ameerpet, Hyderabad', '2026-11-06 13:30:00',
220.00, 40.00, 20.00, 240.00, 'DELIVERED'),
 
(7, 5, 3, 6, 'Miyapur, Hyderabad', '2026-11-07 18:00:00',
330.00, 40.00, 0.00, 370.00, 'DELIVERED'),
 
(8, 1, 3, 1, 'Madhapur, Hyderabad', '2026-11-08 20:00:00',
160.00, 40.00, 0.00, 200.00, 'CANCELLED');
 
 
-- ==========================================
-- 10. ORDER ITEMS
-- ==========================================
 
INSERT INTO order_items
(order_item_id, order_id, menu_item_id, food_name,
quantity, unit_price, item_total)
VALUES
(1, 1, 1, 'Paneer Biryani', 2, 150.00, 300.00),
(2, 1, 2, 'Masala Dosa', 1, 200.00, 200.00),
 
(3, 2, 1, 'Paneer Biryani', 2, 150.00, 300.00),
 
(4, 3, 3, 'Chicken Biryani', 1, 250.00, 250.00),
(5, 3, 2, 'Masala Dosa', 1, 200.00, 200.00),
 
(6, 4, 4, 'Paneer Butter Masala', 1, 220.00, 220.00),
(7, 4, 5, 'Veg Noodles', 1, 140.00, 140.00),
 
(8, 5, 6, 'Chicken Noodles', 2, 250.00, 500.00),
 
(9, 6, 4, 'Paneer Butter Masala', 1, 220.00, 220.00),
 
(10, 7, 7, 'Veg Burger', 1, 180.00, 180.00),
(11, 7, 8, 'French Fries', 1, 80.00, 80.00),
(12, 7, 9, 'Gulab Jamun', 1, 70.00, 70.00),
 
(13, 8, 8, 'French Fries', 2, 80.00, 160.00);
 
 
-- ==========================================
-- 11. PAYMENTS
-- Multiple attempts for Order 1
-- ==========================================
 
INSERT INTO payments
(payment_id, order_id, payment_method, transaction_reference,
payment_amount, payment_status, payment_date)
VALUES
(1, 1, 'UPI', 'TXN1001', 540.00, 'FAILED', '2026-11-01 12:05:00'),
 
(2, 1, 'UPI', 'TXN1002', 540.00, 'SUCCESS', '2026-11-01 12:10:00'),
 
(3, 2, 'CREDIT_CARD', 'TXN1003', 290.00, 'SUCCESS', '2026-11-02 13:05:00'),
 
(4, 3, 'UPI', 'TXN1004', 490.00, 'SUCCESS', '2026-11-03 14:05:00'),
 
(5, 4, 'DEBIT_CARD', 'TXN1005', 400.00, 'SUCCESS', '2026-11-04 12:35:00'),
 
(6, 5, 'UPI', 'TXN1006', 540.00, 'SUCCESS', '2026-11-05 19:05:00'),
 
(7, 6, 'CASH_ON_DELIVERY', 'COD1007', 240.00, 'SUCCESS', '2026-11-06 13:30:00'),
 
(8, 7, 'UPI', 'TXN1008', 370.00, 'SUCCESS', '2026-11-07 18:05:00'),
 
(9, 8, 'UPI', 'TXN1009', 200.00, 'SUCCESS', '2026-11-08 20:05:00');
 
 
-- ==========================================
-- 12. DELIVERIES
-- ==========================================
 
INSERT INTO deliveries
(delivery_id, order_id, partner_id, delivery_status,
assigned_at, accepted_at, pickup_time, delivery_time,
estimated_delivery_time)
VALUES
(1, 1, 1, 'DELIVERED', '2026-11-01 12:10:00',
'2026-11-01 12:12:00', '2026-11-01 12:30:00',
'2026-11-01 12:50:00', '2026-11-01 13:00:00'),
 
(2, 2, 1, 'DELIVERED', '2026-11-02 13:05:00',
'2026-11-02 13:07:00', '2026-11-02 13:25:00',
'2026-11-02 13:45:00', '2026-11-02 14:00:00'),
 
(3, 3, 1, 'DELIVERED', '2026-11-03 14:05:00',
'2026-11-03 14:07:00', '2026-11-03 14:25:00',
'2026-11-03 14:45:00', '2026-11-03 15:00:00'),
 
(4, 4, 1, 'DELIVERED', '2026-11-04 12:35:00',
'2026-11-04 12:37:00', '2026-11-04 12:55:00',
'2026-11-04 13:15:00', '2026-11-04 13:30:00'),
 
(5, 5, 1, 'DELIVERED', '2026-11-05 19:05:00',
'2026-11-05 19:07:00', '2026-11-05 19:25:00',
'2026-11-05 19:45:00', '2026-11-05 20:00:00'),
 
(6, 6, 1, 'DELIVERED', '2026-11-06 13:35:00',
'2026-11-06 13:37:00', '2026-11-06 13:55:00',
'2026-11-06 14:15:00', '2026-11-06 14:30:00'),
 
(7, 7, 2, 'DELIVERED', '2026-11-07 18:05:00',
'2026-11-07 18:07:00', '2026-11-07 18:25:00',
'2026-11-07 18:45:00', '2026-11-07 19:00:00');
 
 
-- ==========================================
-- 13. ORDER STATUS HISTORY
-- ==========================================
 
INSERT INTO order_status_history
(history_id, order_id, status, status_description, changed_at)
VALUES
(1, 1, 'PLACED', 'Order placed', '2026-11-01 12:00:00'),
(2, 1, 'CONFIRMED', 'Restaurant confirmed', '2026-11-01 12:10:00'),
(3, 1, 'PREPARING', 'Food preparation started', '2026-11-01 12:15:00'),
(4, 1, 'DELIVERED', 'Order delivered', '2026-11-01 12:50:00'),
 
(5, 2, 'PLACED', 'Order placed', '2026-11-02 13:00:00'),
(6, 2, 'CONFIRMED', 'Restaurant confirmed', '2026-11-02 13:05:00'),
(7, 2, 'DELIVERED', 'Order delivered', '2026-11-02 13:45:00'),
 
(8, 3, 'PLACED', 'Order placed', '2026-11-03 14:00:00'),
(9, 3, 'DELIVERED', 'Order delivered', '2026-11-03 14:45:00'),
 
(10, 4, 'PLACED', 'Order placed', '2026-11-04 12:30:00'),
(11, 4, 'DELIVERED', 'Order delivered', '2026-11-04 13:15:00'),
 
(12, 5, 'PLACED', 'Order placed', '2026-11-05 19:00:00'),
(13, 5, 'DELIVERED', 'Order delivered', '2026-11-05 19:45:00'),
 
(14, 6, 'PLACED', 'Order placed', '2026-11-06 13:30:00'),
(15, 6, 'DELIVERED', 'Order delivered', '2026-11-06 14:15:00'),
 
(16, 7, 'PLACED', 'Order placed', '2026-11-07 18:00:00'),
(17, 7, 'DELIVERED', 'Order delivered', '2026-11-07 18:45:00'),
 
(18, 8, 'PLACED', 'Order placed', '2026-11-08 20:00:00'),
(19, 8, 'CANCELLED', 'Customer cancelled order', '2026-11-08 20:10:00');
 
 
-- ==========================================
-- 14. REVIEWS
-- ==========================================
 
INSERT INTO reviews
(review_id, customer_id, order_id, restaurant_id,
menu_item_id, rating, comments, review_date)
VALUES
(1, 1, 1, 1, NULL, 5, 'Excellent biryani and service',
'2026-11-01 13:00:00'),
 
(2, 1, 1, NULL, 1, 5, 'Very tasty paneer biryani',
'2026-11-01 13:05:00'),
 
(3, 2, 3, 1, NULL, 4, 'Good food quality',
'2026-11-03 15:00:00'),
 
(4, 2, 4, 2, NULL, 5, 'Great restaurant',
'2026-11-04 14:00:00'),
 
(5, 5, 7, 3, NULL, 4, 'Nice food and quick delivery',
'2026-11-07 19:30:00');

-- ==========================================
-- 15. COUPONS
-- ==========================================

INSERT INTO coupons
(coupon_id, coupon_code, discount_type, discount_value,
minimum_order_value, maximum_discount, valid_from,
valid_until, usage_limit, is_active)
VALUES
(1, 'WELCOME50', 'FIXED', 50.00,
200.00, 50.00, '2026-01-01 00:00:00',
'2026-12-31 23:59:59', 1, TRUE),
 
(2, 'SAVE10', 'PERCENTAGE', 10.00,
300.00, 100.00, '2026-01-01 00:00:00',
'2026-12-31 23:59:59', 5, TRUE);
 
 
-- ==========================================
-- 16. COUPON REDEMPTIONS
-- ==========================================
 
INSERT INTO coupon_redemptions
(redemption_id, coupon_id, customer_id, order_id,
discount_applied, redeemed_at)
VALUES
(1, 1, 1, 2, 50.00, '2026-11-02 13:00:00'),
(2, 2, 2, 4, 36.00, '2026-11-04 12:30:00');
 
 
-- ==========================================
-- 17. REFUNDS
-- ==========================================
 
INSERT INTO refunds
(refund_id, payment_id, refund_amount, refund_reason,
refund_status, refund_date)
VALUES
(1, 9, 200.00, 'Order cancelled by customer',
'COMPLETED', '2026-11-09 10:00:00');


USE food_delivery_db;
 
SELECT 'customers' AS table_name, COUNT(*) AS total
FROM customers
 
UNION ALL
 
SELECT 'customer_addresses', COUNT(*)
FROM customer_addresses
 
UNION ALL
 
SELECT 'restaurants', COUNT(*)
FROM restaurants
 
UNION ALL
 
SELECT 'food_categories', COUNT(*)
FROM food_categories
 
UNION ALL
 
SELECT 'menu_items', COUNT(*)
FROM menu_items
 
UNION ALL
 
SELECT 'carts', COUNT(*)
FROM carts
 
UNION ALL
 
SELECT 'cart_items', COUNT(*)
FROM cart_items
 
UNION ALL
 
SELECT 'delivery_partners', COUNT(*)
FROM delivery_partners
 
UNION ALL
 
SELECT 'orders', COUNT(*)
FROM orders
 
UNION ALL
 
SELECT 'order_items', COUNT(*)
FROM order_items
 
UNION ALL
 
SELECT 'payments', COUNT(*)
FROM payments
 
UNION ALL
 
SELECT 'deliveries', COUNT(*)
FROM deliveries
 
UNION ALL
 
SELECT 'order_status_history', COUNT(*)
FROM order_status_history
 
UNION ALL
 
SELECT 'reviews', COUNT(*)
FROM reviews
 
UNION ALL
 
SELECT 'coupons', COUNT(*)
FROM coupons
 
UNION ALL
 
SELECT 'coupon_redemptions', COUNT(*)
FROM coupon_redemptions
 
UNION ALL
 
SELECT 'refunds', COUNT(*)
FROM refunds;

SELECT * FROM customers;

SELECT * FROM restaurants;

SELECT
    o.order_id,
    c.customer_name,
    o.total_amount,
    o.order_status
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;
    
    
USE food_delivery_db;

-- to display the actual foreign-key releatonship in your data base;
 
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'food_delivery_db'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, CONSTRAINT_NAME;