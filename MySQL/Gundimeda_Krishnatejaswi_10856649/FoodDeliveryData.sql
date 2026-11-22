INSERT INTO Customer (name, email, mobile, password_hash) VALUES
('Rahul Sharma', 'rahul@email.com', '9876543210', 'hash1'),
('Priya Patel',  'priya@email.com', '9876543211', 'hash2'),
('Amit Kumar',   'amit@email.com',  '9876543212', 'hash3');
INSERT INTO Customer_Address (customer_id, address_line, city, state, pincode, is_default) VALUES
(1, '12 MG Road', 'Hyderabad', 'Telangana', '500001', 1),
(2, '45 Jubilee Hills', 'Hyderabad', 'Telangana', '500033', 1),
(3, '78 Banjara Hills', 'Hyderabad', 'Telangana', '500034', 1);
INSERT INTO Restaurant (name, address, contact_number, is_active, avg_rating) VALUES
('Spice Garden', 'Madhapur', '040-1234567', 1, 4.5),
('China Town',   'Gachibowli', '040-7654321', 1, 4.2),
('South Delight','Kukatpally', '040-1122334', 0, 3.8);
INSERT INTO Food_Category (category_name) VALUES
('South Indian'), ('North Indian'), ('Chinese'), ('Fast Food'), ('Desserts'), ('Beverages');
INSERT INTO Menu_Item (restaurant_id, category_id, item_name, price, is_veg, is_available) VALUES
(1, 1, 'Masala Dosa', 120.00, 1, 1),
(1, 1, 'Idli Sambar', 80.00, 1, 1),
(1, 2, 'Butter Chicken', 280.00, 0, 1),
(2, 3, 'Chicken Fried Rice', 220.00, 0, 1),
(2, 3, 'Veg Manchurian', 180.00, 1, 1),
(3, 1, 'Pesarattu', 100.00, 1, 0);


INSERT INTO Cart (customer_id) VALUES

(1), (2), (3);

-- 2. Cart Items

INSERT INTO Cart_Item (cart_id, item_id, quantity) VALUES

(1, 1, 2),   -- Rahul: 2 Masala Dosa

(1, 3, 1),   -- Rahul: 1 Butter Chicken

(2, 4, 1),   -- Priya: 1 Chicken Fried Rice

(2, 5, 2);   -- Priya: 2 Veg Manchurian

-- 3. Coupons

INSERT INTO Coupon (coupon_code, discount_type, discount_value, min_order_value, max_discount, valid_from, valid_to, usage_limit) VALUES

('WELCOME50', 'FIXED', 50.00, 200.00, 50.00, '2026-01-01', '2026-12-31', 1),

('FOOD20', 'PERCENT', 20.00, 300.00, 100.00, '2026-01-01', '2026-12-31', 3),

('FLAT100', 'FIXED', 100.00, 500.00, 100.00, '2026-11-01', '2026-11-30', 2);

-- 4. Orders

INSERT INTO Orders (customer_id, restaurant_id, address_id, order_datetime, status, subtotal, delivery_charge, discount_amount, final_amount, coupon_id) VALUES

(1, 1, 1, '2026-11-10 12:30:00', 'DELIVERED', 400.00, 40.00, 50.00, 390.00, 1),

(1, 2, 1, '2026-11-12 19:15:00', 'DELIVERED', 400.00, 30.00, 0.00, 430.00, NULL),

(2, 1, 2, '2026-11-11 13:00:00', 'DELIVERED', 280.00, 40.00, 0.00, 320.00, NULL),

(2, 2, 2, '2026-11-13 20:00:00', 'OUT_FOR_DELIVERY', 580.00, 30.00, 100.00, 510.00, 3),

(3, 1, 3, '2026-11-09 18:45:00', 'CANCELLED', 200.00, 40.00, 0.00, 240.00, NULL);

-- 5. Order Items (historical prices)

INSERT INTO Order_Item (order_id, item_id, quantity, unit_price) VALUES

-- Order 1 (Rahul - Spice Garden)

(1, 1, 2, 120.00),   -- 2 Masala Dosa

(1, 3, 1, 280.00),   -- 1 Butter Chicken

-- Order 2 (Rahul - China Town)

(2, 4, 1, 220.00),

(2, 5, 1, 180.00),

-- Order 3 (Priya - Spice Garden)

(3, 3, 1, 280.00),

-- Order 4 (Priya - China Town)

(4, 4, 2, 220.00),

(4, 5, 1, 180.00),

-- Order 5 (Amit - cancelled)

(5, 1, 1, 120.00),

(5, 2, 1, 80.00);

-- 6. Payments

INSERT INTO Payment (order_id, payment_method, transaction_ref, amount, payment_datetime, status) VALUES

(1, 'UPI', 'UPI123456789', 390.00, '2026-11-10 12:32:00', 'SUCCESS'),

(2, 'CREDIT_CARD', 'CC987654321', 430.00, '2026-11-12 19:17:00', 'SUCCESS'),

(3, 'UPI', 'UPI112233445', 320.00, '2026-11-11 13:02:00', 'SUCCESS'),

(4, 'DEBIT_CARD', 'DC556677889', 510.00, '2026-11-13 20:02:00', 'SUCCESS'),

(5, 'UPI', 'UPI998877665', 240.00, '2026-11-09 18:47:00', 'REFUNDED');

-- 7. Delivery Partners

INSERT INTO Delivery_Partner (name, mobile, vehicle_type, vehicle_number, is_available) VALUES

('Ravi Kumar', '9000000001', 'Bike', 'TS09AB1234', 1),

('Suresh Yadav', '9000000002', 'Bike', 'TS09CD5678', 1),

('Anil Reddy', '9000000003', 'Scooter', 'TS09EF9012', 0);

-- 8. Delivery

INSERT INTO Delivery (order_id, partner_id, assigned_at, picked_up_at, delivered_at, status) VALUES

(1, 1, '2026-11-10 12:40:00', '2026-11-10 13:05:00', '2026-11-10 13:35:00', 'DELIVERED'),

(2, 2, '2026-11-12 19:25:00', '2026-11-12 19:50:00', '2026-11-12 20:20:00', 'DELIVERED'),

(3, 1, '2026-11-11 13:10:00', '2026-11-11 13:30:00', '2026-11-11 14:00:00', 'DELIVERED'),

(4, 2, '2026-11-13 20:10:00', '2026-11-13 20:35:00', NULL, 'PICKED_UP');

-- 9. Order Status History

INSERT INTO Order_Status_History (order_id, status, changed_at, remarks) VALUES

(1, 'PLACED', '2026-11-10 12:30:00', 'Order placed by customer'),

(1, 'CONFIRMED', '2026-11-10 12:35:00', 'Restaurant confirmed'),

(1, 'PREPARING', '2026-11-10 12:40:00', NULL),

(1, 'READY_FOR_PICKUP', '2026-11-10 13:00:00', NULL),

(1, 'OUT_FOR_DELIVERY', '2026-11-10 13:05:00', NULL),

(1, 'DELIVERED', '2026-11-10 13:35:00', 'Delivered successfully'),

(2, 'PLACED', '2026-11-12 19:15:00', NULL),

(2, 'CONFIRMED', '2026-11-12 19:20:00', NULL),

(2, 'DELIVERED', '2026-11-12 20:20:00', NULL),

(4, 'PLACED', '2026-11-13 20:00:00', NULL),

(4, 'CONFIRMED', '2026-11-13 20:05:00', NULL),

(4, 'OUT_FOR_DELIVERY', '2026-11-13 20:35:00', NULL),

(5, 'PLACED', '2026-11-09 18:45:00', NULL),

(5, 'CANCELLED', '2026-11-09 18:55:00', 'Customer cancelled');

-- 10. Reviews

INSERT INTO Review (customer_id, restaurant_id, order_id, item_id, rating, comment) VALUES

(1, 1, 1, 1, 5, 'Best Masala Dosa in Hyderabad!'),

(1, 1, 1, 3, 4, 'Butter Chicken was good'),

(1, 2, 2, NULL, 4, 'Overall nice Chinese food'),

(2, 1, 3, 3, 5, 'Loved the Butter Chicken');

-- 11. Coupon Redemption

INSERT INTO Coupon_Redemption (coupon_id, customer_id, order_id) VALUES

(1, 1, 1),   -- Rahul used WELCOME50

(3, 2, 4);   -- Priya used FLAT100

-- 12. Refund (for cancelled order)

INSERT INTO Refund (payment_id, refund_amount, reason, status) VALUES

(5, 240.00, 'Order cancelled by customer', 'PROCESSED');
 
