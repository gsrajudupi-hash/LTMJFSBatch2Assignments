USE food_delivery_db;

-- ==========================================
-- 1. CUSTOMER
-- ==========================================

INSERT INTO customer
(customer_name, email, mobile_number, password_hash)
VALUES
('Lalli', 'lalli.n@gmail.com', '9848012345', 'lalli_hash'),
('Shiva', 'shiva.k@gmail.com', '9701234586', 'shiva_hash'),
('Ram', 'ram.v@gmail.com', '9618452370', 'ram_hash'),
('Malli', 'malli.r@gmail.com', '9985123047', 'malli_hash'),
('Tiru', 'tiru.s@gmail.com', '9398761205', 'tiru_hash');


-- ==========================================
-- 2. CUSTOMER ADDRESS
-- ==========================================

INSERT INTO customer_address
(customer_id, address_line1, address_line2,
 city, state, postal_code, is_default)
VALUES
(1, 'Madhapur Main Road', 'Near Metro Station',
 'Hyderabad', 'Telangana', '500081', TRUE),

(2, 'KPHB 6th Phase', NULL,
 'Hyderabad', 'Telangana', '500072', TRUE),

(3, 'Ameerpet Main Road', 'Near SR Nagar',
 'Hyderabad', 'Telangana', '500016', TRUE),

(4, 'Gachibowli Main Road', 'Near DLF',
 'Hyderabad', 'Telangana', '500032', TRUE),

(5, 'Miyapur Main Road', NULL,
 'Hyderabad', 'Telangana', '500049', TRUE),

(1, 'Kondapur Main Road', 'Near Botanical Garden',
 'Hyderabad', 'Telangana', '500084', FALSE);


-- ==========================================
-- 3. RESTAURANT
-- ==========================================

INSERT INTO restaurant
(restaurant_name, address_line1, address_line2,
 city, state, postal_code,
 contact_number, email,
 opening_time, closing_time, is_active)
VALUES
('Coastal Spice',
 'Madhapur Road', 'Near Image Gardens',
 'Hyderabad', 'Telangana', '500081',
 '9000012345', 'coastalspice@gmail.com',
 '11:00:00', '23:00:00', TRUE),

('Pulav Junction',
 'Kondapur Main Road', NULL,
 'Hyderabad', 'Telangana', '500084',
 '9000023456', 'pulavjunction@gmail.com',
 '10:30:00', '22:30:00', TRUE),

('Sweet Slice Cafe',
 'Gachibowli Road', 'Near DLF',
 'Hyderabad', 'Telangana', '500032',
 '9000034567', 'sweetslice@gmail.com',
 '09:00:00', '22:00:00', TRUE),

('Pizza Yard',
 'KPHB Main Road', NULL,
 'Hyderabad', 'Telangana', '500072',
 '9000045678', 'pizzayard@gmail.com',
 '11:00:00', '23:30:00', TRUE);


-- ==========================================
-- 4. FOOD CATEGORY
-- ==========================================

INSERT INTO food_category (category_name)
VALUES
('South Indian'),
('North Indian'),
('Chinese'),
('Fast Food'),
('Desserts'),
('Beverages');


-- ==========================================
-- 5. MENU ITEM
-- ==========================================

INSERT INTO menu_item
(restaurant_id, category_id, food_name,
 description, price,
 is_vegetarian, is_available)
VALUES
(1, 1, 'Fish Curry',
 'Spicy fish curry',
 290.00, FALSE, TRUE),

(2, 2, 'Chicken Pulav',
 'Rice cooked with chicken and spices',
 260.00, FALSE, TRUE),

(3, 5, 'Waffles',
 'Waffles served with chocolate sauce',
 180.00, TRUE, TRUE),

(3, 5, 'Ice Cream',
 'Vanilla ice cream',
 110.00, TRUE, TRUE),

(3, 5, 'Chocolate Cake',
 'Chocolate cake slice',
 170.00, TRUE, TRUE),

(1, 2, 'Chicken Biryani',
 'Chicken cooked with basmati rice',
 320.00, FALSE, TRUE),

(1, 1, 'Prawns Fry',
 'Spicy fried prawns',
 360.00, FALSE, TRUE),

(1, 1, 'Chicken Fry',
 'Spicy fried chicken pieces',
 240.00, FALSE, TRUE),

(2, 2, 'Veg Pulav',
 'Rice cooked with vegetables',
 190.00, TRUE, TRUE),

(4, 4, 'Pizza',
 'Cheese pizza with vegetable toppings',
 250.00, TRUE, TRUE);


-- ==========================================
-- 6. CART
-- ==========================================

INSERT INTO cart (customer_id)
VALUES
(1),
(2),
(3),
(4),
(5);


-- ==========================================
-- 7. CART ITEM
-- ==========================================

INSERT INTO cart_item
(cart_id, menu_item_id, quantity)
VALUES
(1, 1, 1),
(1, 7, 1),
(2, 2, 2),
(3, 10, 1),
(4, 3, 2),
(4, 5, 1),
(5, 9, 1);


-- ==========================================
-- 8. ORDERS
-- ==========================================

INSERT INTO orders
(customer_id, restaurant_id, address_id,
 order_date, subtotal,
 delivery_charge, discount,
 final_amount, order_status)
VALUES

-- Lalli
(1, 1, 1,
 '2026-11-10 19:15:00',
 560.00, 35.00, 50.00,
 545.00, 'DELIVERED'),

-- Shiva
(2, 2, 2,
 '2026-11-11 20:10:00',
 520.00, 30.00, 0.00,
 550.00, 'DELIVERED'),

-- Ram
(3, 4, 3,
 '2026-11-12 18:20:00',
 250.00, 30.00, 20.00,
 260.00, 'DELIVERED'),

-- Malli
(4, 3, 4,
 '2026-11-13 17:45:00',
 350.00, 25.00, 0.00,
 375.00, 'CONFIRMED'),

-- Tiru - cancelled order
(5, 2, 5,
 '2026-11-14 19:00:00',
 190.00, 30.00, 0.00,
 220.00, 'CANCELLED');


-- ==========================================
-- 9. ORDER ITEM
-- ==========================================

INSERT INTO order_item
(order_id, menu_item_id, quantity, item_price)
VALUES

-- Lalli order
(1, 6, 1, 320.00),
(1, 8, 1, 240.00),

-- Shiva order
(2, 2, 2, 260.00),

-- Ram order
(3, 10, 1, 250.00),

-- Malli order
(4, 3, 1, 180.00),
(4, 5, 1, 170.00),

-- Tiru order
(5, 9, 1, 190.00);


-- ==========================================
-- 10. PAYMENT
-- ==========================================

INSERT INTO payment
(order_id, transaction_reference,
 payment_method, payment_amount,
 payment_date, payment_status)
VALUES

(1, 'LAL101UPI',
 'UPI',
 545.00,
 '2026-11-10 19:17:00',
 'SUCCESS'),

(2, 'SHI102CARD',
 'DEBIT_CARD',
 550.00,
 '2026-11-11 20:12:00',
 'SUCCESS'),

-- failed attempt
(3, 'RAM103FAIL',
 'UPI',
 260.00,
 '2026-11-12 18:22:00',
 'FAILED'),

-- successful retry
(3, 'RAM103UPI',
 'UPI',
 260.00,
 '2026-11-12 18:25:00',
 'SUCCESS'),

-- COD order
(4, NULL,
 'CASH_ON_DELIVERY',
 375.00,
 '2026-11-13 17:45:00',
 'PENDING'),

-- Tiru paid before cancellation
(5, 'TIR105UPI',
 'UPI',
 220.00,
 '2026-11-14 19:02:00',
 'SUCCESS');


-- ==========================================
-- 11. REFUND
-- ==========================================

-- Refund belongs to cancelled Tiru order.
-- payment_id 6 is the successful payment
-- for order_id 5.

INSERT INTO refund
(payment_id, refund_amount,
 refund_date, refund_status)
VALUES
(6,
 220.00,
 '2026-11-14 19:30:00',
 'COMPLETED');


-- ==========================================
-- 12. DELIVERY PARTNER
-- ==========================================

INSERT INTO delivery_partner
(partner_name, mobile_number,
 vehicle_number, vehicle_type,
 is_available)
VALUES

('Kiran',
 '9000100001',
 'TS09FK2101',
 'Bike',
 TRUE),

('Vamsi',
 '9000100002',
 'TS08VM4521',
 'Scooter',
 TRUE),

('Teja',
 '9000100003',
 'TS07TJ7352',
 'Bike',
 FALSE);


-- ==========================================
-- 13. DELIVERY
-- ==========================================

INSERT INTO delivery
(order_id, delivery_partner_id,
 assignment_status,
 pickup_time, delivery_time,
 delivery_status)
VALUES

(1, 1,
 'ACCEPTED',
 '2026-11-10 19:50:00',
 '2026-11-10 20:20:00',
 'DELIVERED'),

(2, 2,
 'ACCEPTED',
 '2026-11-11 20:45:00',
 '2026-11-11 21:15:00',
 'DELIVERED'),

(3, 1,
 'ACCEPTED',
 '2026-11-12 18:55:00',
 '2026-11-12 19:20:00',
 'DELIVERED'),

(4, 3,
 'ACCEPTED',
 NULL,
 NULL,
 'ASSIGNED');


-- No delivery row for Order 5 because
-- Tiru's order was cancelled before delivery.


-- ==========================================
-- 14. ORDER STATUS HISTORY
-- ==========================================

INSERT INTO order_status_history
(order_id, order_status,
 status_updated_at,
 estimated_delivery_time)
VALUES

-- Lalli
(1, 'PLACED',
 '2026-11-10 19:15:00',
 '2026-11-10 20:20:00'),

(1, 'CONFIRMED',
 '2026-11-10 19:20:00',
 '2026-11-10 20:20:00'),

(1, 'PREPARING',
 '2026-11-10 19:30:00',
 '2026-11-10 20:20:00'),

(1, 'READY_FOR_PICKUP',
 '2026-11-10 19:45:00',
 '2026-11-10 20:20:00'),

(1, 'OUT_FOR_DELIVERY',
 '2026-11-10 19:55:00',
 '2026-11-10 20:20:00'),

(1, 'DELIVERED',
 '2026-11-10 20:20:00',
 NULL),

-- Shiva
(2, 'PLACED',
 '2026-11-11 20:10:00',
 '2026-11-11 21:15:00'),

(2, 'CONFIRMED',
 '2026-11-11 20:15:00',
 '2026-11-11 21:15:00'),

(2, 'OUT_FOR_DELIVERY',
 '2026-11-11 20:50:00',
 '2026-11-11 21:15:00'),

(2, 'DELIVERED',
 '2026-11-11 21:15:00',
 NULL),

-- Ram
(3, 'PLACED',
 '2026-11-12 18:20:00',
 '2026-11-12 19:20:00'),

(3, 'CONFIRMED',
 '2026-11-12 18:30:00',
 '2026-11-12 19:20:00'),

(3, 'OUT_FOR_DELIVERY',
 '2026-11-12 18:58:00',
 '2026-11-12 19:20:00'),

(3, 'DELIVERED',
 '2026-11-12 19:20:00',
 NULL),

-- Malli
(4, 'PLACED',
 '2026-11-13 17:45:00',
 '2026-11-13 18:45:00'),

(4, 'CONFIRMED',
 '2026-11-13 17:50:00',
 '2026-11-13 18:45:00'),

-- Tiru
(5, 'PLACED',
 '2026-11-14 19:00:00',
 '2026-11-14 19:50:00'),

(5, 'CONFIRMED',
 '2026-11-14 19:05:00',
 '2026-11-14 19:50:00'),

(5, 'CANCELLED',
 '2026-11-14 19:20:00',
 NULL);


-- ==========================================
-- 15. REVIEW
-- ==========================================

-- Only completed/delivered orders are reviewed.

INSERT INTO review
(customer_id, order_id,
 restaurant_id, menu_item_id,
 rating, feedback, review_date)
VALUES

(1, 1, 1, NULL,
 5,
 'Food was tasty and delivery was on time',
 '2026-11-10 20:45:00'),

(1, 1, 1, 6,
 5,
 'Chicken biryani was very good',
 '2026-11-10 20:47:00'),

(2, 2, 2, 2,
 4,
 'Chicken pulav tasted good',
 '2026-11-11 21:30:00'),

(3, 3, 4, 10,
 4,
 'Pizza was fresh and good',
 '2026-11-12 19:40:00');


-- ==========================================
-- 16. COUPON
-- ==========================================

INSERT INTO coupon
(coupon_code, discount_type,
 discount_value,
 valid_from, valid_to,
 minimum_order_value,
 maximum_discount)
VALUES

('LALLI50',
 'FIXED',
 50.00,
 '2026-11-01',
 '2026-11-30',
 500.00,
 50.00),

('FOODIE15',
 'PERCENTAGE',
 15.00,
 '2026-11-01',
 '2026-12-31',
 300.00,
 100.00),

('SWEET40',
 'FIXED',
 40.00,
 '2026-11-01',
 '2026-11-30',
 250.00,
 40.00);


-- ==========================================
-- 17. COUPON REDEMPTION
-- ==========================================

INSERT INTO coupon_redemption
(coupon_id, customer_id,
 order_id, discount_amount,
 redeemed_at)
VALUES

(1, 1, 1,
 50.00,
 '2026-11-10 19:15:00');