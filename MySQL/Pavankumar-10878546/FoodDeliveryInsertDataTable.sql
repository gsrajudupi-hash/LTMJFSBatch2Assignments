USE ofdms_db;

-- 1. Customers (Customer 5 has no orders; Customer 4 has orders but no reviews)
INSERT INTO customers (full_name, email, phone, password_hash) VALUES
('Aarav Sharma', 'aarav.sharma@example.com', '9876543210', 'hash_pw_1'),
('Priya Nair', 'priya.nair@example.com', '9876543211', 'hash_pw_2'),
('Rohan Verma', 'rohan.verma@example.com', '9876543212', 'hash_pw_3'),
('Sneha Reddy', 'sneha.reddy@example.com', '9876543213', 'hash_pw_4'),
('Vikram Joshi', 'vikram.joshi@example.com', '9876543214', 'hash_pw_5');

-- 2. Customer Addresses
INSERT INTO customer_addresses (customer_id, label, address_line, city, state, pincode, is_default) VALUES
(1, 'Home', '12 MG Road, Indiranagar', 'Bengaluru', 'Karnataka', '560038', TRUE),
(1, 'Work', '45 Outer Ring Road, Bellandur', 'Bengaluru', 'Karnataka', '560103', FALSE),
(2, 'Home', '88 Koramangala 4th Block', 'Bengaluru', 'Karnataka', '560034', TRUE),
(3, 'Home', '21 Jayanagar 3rd Block', 'Bengaluru', 'Karnataka', '560011', TRUE),
(4, 'Home', '104 HSR Layout Sector 2', 'Bengaluru', 'Karnataka', '560102', TRUE);

-- 3. Restaurants (Restaurant 4 is inactive & has 0 orders)
INSERT INTO restaurants (name, address, city, phone, email, opening_time, closing_time, is_active, avg_rating) VALUES
('Udupi Grand', '10 Church Street', 'Bengaluru', '08022221111', 'contact@udupigrand.in', '07:00:00', '22:30:00', TRUE, 4.50),
('Tandoor Tales', '54 Residency Road', 'Bengaluru', '08022222222', 'hello@tandoortales.in', '11:30:00', '23:30:00', TRUE, 4.20),
('Wok & Roll Express', '77 Brigade Road', 'Bengaluru', '08022223333', 'orders@wokandroll.in', '12:00:00', '23:00:00', TRUE, 3.80),
('Midnight Cravings', '9 Whitefield Main Rd', 'Bengaluru', '08022224444', 'info@midnightcravings.in', '18:00:00', '03:00:00', FALSE, 0.00);

-- 4. Food Categories
INSERT INTO food_categories (name, description) VALUES
('South Indian', 'Traditional dosas, idlis, vadas, and filter coffee'),
('North Indian', 'Curries, biryanis, breads, and tandoori platters'),
('Chinese', 'Noodles, fried rice, dim sums, and Manchurian'),
('Desserts', 'Sweets, ice creams, and pastries'),
('Beverages', 'Juices, milkshakes, lassi, and coffee');

-- 5. Menu Items (Item 8 has never been ordered; Item 7 is unavailable)
INSERT INTO menu_items (restaurant_id, category_id, name, description, price, is_veg, is_available) VALUES
(1, 1, 'Masala Dosa', 'Crispy dosa stuffed with spiced potato masala', 120.00, TRUE, TRUE),
(1, 1, 'Ghee Roast Idli', 'Steamed idlis tossed in aromatic ghee and podi', 95.00, TRUE, TRUE),
(1, 5, 'Filter Coffee', 'Authentic South Indian decoction coffee', 50.00, TRUE, TRUE),
(2, 2, 'Paneer Tikka Masala', 'Chargrilled paneer cubes in rich tomato gravy', 280.00, TRUE, TRUE),
(2, 2, 'Chicken Dum Biryani', 'Slow-cooked basmati rice with spiced chicken', 340.00, FALSE, TRUE),
(2, 2, 'Mutton Rogan Josh', 'Slow-braised Kashmiri lamb curry', 420.00, FALSE, TRUE),
(3, 3, 'Veg Hakka Noodles', 'Wok-tossed noodles with crisp vegetables', 210.00, TRUE, FALSE),
(3, 3, 'Chilli Chicken Dry', 'Crispy chicken tossed in spicy garlic soy sauce', 260.00, FALSE, TRUE),
(2, 4, 'Gulab Jamun (2 pcs)', 'Warm khoya dumplings soaked in saffron syrup', 90.00, TRUE, TRUE);

-- 6. Carts & Cart Items
INSERT INTO carts (customer_id) VALUES (1), (2), (5);
INSERT INTO cart_items (cart_id, item_id, quantity) VALUES
(1, 1, 2),
(3, 4, 1);

-- 7. Coupons
INSERT INTO coupons (code, discount_type, discount_value, min_order_value, max_discount, valid_from, valid_to, usage_limit_per_user, is_active) VALUES
('WELCOME50', 'FIXED', 50.00, 200.00, 50.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 1, TRUE),
('FEAST20', 'PERCENTAGE', 20.00, 500.00, 150.00, '2026-01-01 00:00:00', '2026-12-31 23:59:59', 2, TRUE);

-- 8. Delivery Partners
INSERT INTO delivery_partners (full_name, phone, vehicle_type, vehicle_number, is_available) VALUES
('Karthik Gowda', '9900112201', 'BIKE', 'KA01AB1234', TRUE),
('Suresh Kumar', '9900112202', 'SCOOTER', 'KA02CD5678', TRUE),
('Imran Pasha', '9900112203', 'EV', 'KA03EF9012', FALSE);

-- 9. Orders (Includes completed orders across months + 1 cancelled order)
INSERT INTO orders (customer_id, restaurant_id, address_id, coupon_id, order_date, subtotal, delivery_fee, discount_amount, final_amount, order_status, cancellation_reason) VALUES
(1, 1, 1, 1, '2026-10-10 13:15:00', 290.00, 30.00, 50.00, 270.00, 'DELIVERED', NULL),
(1, 2, 1, 2, '2026-10-18 20:30:00', 620.00, 40.00, 124.00, 536.00, 'DELIVERED', NULL),
(2, 2, 3, NULL, '2026-11-02 19:45:00', 760.00, 40.00, 0.00, 800.00, 'DELIVERED', NULL),
(3, 1, 4, NULL, '2026-11-05 09:20:00', 240.00, 25.00, 0.00, 265.00, 'DELIVERED', NULL),
(4, 2, 5, 1, '2026-11-12 21:00:00', 340.00, 35.00, 50.00, 325.00, 'DELIVERED', NULL),
(1, 1, 1, NULL, '2026-11-15 14:10:00', 240.00, 25.00, 0.00, 265.00, 'DELIVERED', NULL),
(2, 1, 3, NULL, '2026-11-20 12:30:00', 170.00, 25.00, 0.00, 195.00, 'CANCELLED', 'Customer requested cancellation');

-- 10. Order Items
INSERT INTO order_items (order_id, item_id, quantity, unit_price) VALUES
(1, 1, 2, 120.00),
(1, 3, 1, 50.00),
(2, 4, 1, 280.00),
(2, 5, 1, 340.00),
(3, 5, 1, 340.00),
(3, 6, 1, 420.00),
(4, 1, 2, 120.00),
(5, 5, 1, 340.00),
(6, 1, 2, 120.00),
(7, 1, 1, 120.00),
(7, 3, 1, 50.00);

-- 11. Payments (Order 2 has a failed attempt followed by a successful attempt; Order 7 was refunded)
INSERT INTO payments (order_id, attempt_no, payment_method, transaction_ref, amount, payment_status, payment_date) VALUES
(1, 1, 'UPI', 'TXN_UPI_1001', 270.00, 'SUCCESS', '2026-10-10 13:15:10'),
(2, 1, 'CREDIT_CARD', 'TXN_CC_1002A', 536.00, 'FAILED', '2026-10-18 20:30:05'),
(2, 2, 'UPI', 'TXN_UPI_1002B', 536.00, 'SUCCESS', '2026-10-18 20:31:00'),
(3, 1, 'DEBIT_CARD', 'TXN_DC_1003', 800.00, 'SUCCESS', '2026-11-02 19:45:12'),
(4, 1, 'COD', 'TXN_COD_1004', 265.00, 'SUCCESS', '2026-11-05 09:55:00'),
(5, 1, 'UPI', 'TXN_UPI_1005', 325.00, 'SUCCESS', '2026-11-12 21:00:15'),
(6, 1, 'UPI', 'TXN_UPI_1006', 265.00, 'SUCCESS', '2026-11-15 14:10:08'),
(7, 1, 'UPI', 'TXN_UPI_1007', 195.00, 'REFUNDED', '2026-11-20 12:30:05');

-- 12. Refunds
INSERT INTO refunds (payment_id, order_id, refund_amount, refund_reason, refund_status, refund_date) VALUES
(8, 7, 195.00, 'Order cancelled before preparation', 'PROCESSED', '2026-11-20 12:40:00');

-- 13. Deliveries (Partner 1 has 6 completed deliveries so Query 17 returns > 5)
INSERT INTO deliveries (order_id, partner_id, assignment_status, delivery_status, estimated_delivery_time, picked_up_at, delivered_at) VALUES
(1, 1, 'ACCEPTED', 'DELIVERED', '2026-10-10 14:00:00', '2026-10-10 13:35:00', '2026-10-10 13:52:00'),
(2, 1, 'ACCEPTED', 'DELIVERED', '2026-10-18 21:20:00', '2026-10-18 20:55:00', '2026-10-18 21:15:00'),
(3, 1, 'ACCEPTED', 'DELIVERED', '2026-11-02 20:35:00', '2026-11-02 20:10:00', '2026-11-02 20:30:00'),
(4, 1, 'ACCEPTED', 'DELIVERED', '2026-11-05 10:05:00', '2026-11-05 09:40:00', '2026-11-05 09:55:00'),
(5, 1, 'ACCEPTED', 'DELIVERED', '2026-11-12 21:50:00', '2026-11-12 21:25:00', '2026-11-12 21:44:00'),
(6, 1, 'ACCEPTED', 'DELIVERED', '2026-11-15 14:55:00', '2026-11-15 14:30:00', '2026-11-15 14:48:00');

-- 14. Order Status History
INSERT INTO order_status_history (order_id, status, remarks, changed_at) VALUES
(1, 'PLACED', 'Order placed by customer', '2026-10-10 13:15:00'),
(1, 'CONFIRMED', 'Accepted by Udupi Grand', '2026-10-10 13:17:00'),
(1, 'PREPARING', 'Kitchen started preparation', '2026-10-10 13:20:00'),
(1, 'OUT_FOR_DELIVERY', 'Picked up by Karthik Gowda', '2026-10-10 13:35:00'),
(1, 'DELIVERED', 'Delivered to customer', '2026-10-10 13:52:00'),
(7, 'PLACED', 'Order placed by customer', '2026-11-20 12:30:00'),
(7, 'CANCELLED', 'Cancelled by customer', '2026-11-20 12:33:00');

-- 15. Reviews (Customer 4 has ordered but submitted no review)
INSERT INTO reviews (order_id, customer_id, restaurant_id, item_id, rating, comment) VALUES
(1, 1, 1, 1, 5, 'Crisp masala dosa and hot filter coffee!'),
(2, 1, 2, 5, 4, 'Biryani was flavorful, slightly spicy.'),
(3, 2, 2, 6, 5, 'Mutton Rogan Josh was tender and rich.'),
(4, 3, 1, 1, 4, 'Quick morning delivery and fresh food.');

-- 16. Coupon Redemptions
INSERT INTO coupon_redemptions (coupon_id, customer_id, order_id, discount_applied, redeemed_at) VALUES
(1, 1, 1, 50.00, '2026-10-10 13:15:00'),
(2, 1, 2, 124.00, '2026-10-18 20:30:00'),
(1, 4, 5, 50.00, '2026-11-12 21:00:00');