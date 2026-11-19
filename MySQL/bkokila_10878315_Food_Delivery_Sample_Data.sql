-- Synthetic demonstration data for the 18 CREATE TABLE statements provided in chat.
-- Run on empty tables only, after CREATE TABLE statements, in this order.
-- Explicit IDs are used for reproducible foreign-key relationships.
-- MySQL 8.0.16+; no schema changes or deletes.
USE food_delivery_management_db;

-- customer (5 rows)
INSERT INTO customer (customer_id, firstName, lastName, email, phoneNum, status) VALUES
  (1, 'Asha', 'Rao', 'asha@example.com', '9000000001', 'ACTIVE'),
  (2, 'Vikram', 'Shah', 'vikram@example.com', '9000000002', 'ACTIVE'),
  (3, 'Meera', 'Iyer', 'meera@example.com', '9000000003', 'ACTIVE'),
  (4, 'Arjun', 'Nair', 'arjun@example.com', '9000000004', 'INACTIVE'),
  (5, 'Priya', 'Das', 'priya@example.com', '9000000005', 'ACTIVE');

-- customerAddress (6 rows)
INSERT INTO customerAddress (addressId, customerId, label, addressLine1, addressLine2, city, state, pincode, is_default) VALUES
  (1, 1, 'Home', '12 Lake View Road', NULL, 'Hyderabad', 'Telangana', '500081', 1),
  (2, 1, 'Office', 'Tech Park Building 4', 'Hitech City', 'Hyderabad', 'Telangana', '500084', 0),
  (3, 2, 'Home', '22 Park Street', NULL, 'Chennai', 'Tamil Nadu', '600042', 1),
  (4, 3, 'Home', '18 MG Road', 'Flat 3A', 'Bengaluru', 'Karnataka', '560001', 1),
  (5, 4, 'Home', '5 Temple Lane', NULL, 'Chennai', 'Tamil Nadu', '600020', 1),
  (6, 5, 'Home', '31 Jubilee Hills', NULL, 'Hyderabad', 'Telangana', '500033', 1);

-- restaurant (3 rows)
INSERT INTO restaurant (restaurantId, ownerName, email, phoneNum, addressLine1, addressLine2, city, state, pincode, openingTime, closingTime, isActive, rating) VALUES
  (1, 'Ravi Kumar', 'spice@example.com', '9100000001', '45 Food Street', NULL, 'Hyderabad', 'Telangana', '500081', '09:00:00', '23:00:00', 1, 5),
  (2, 'Neha Menon', 'green@example.com', '9100000002', '10 Market Road', NULL, 'Chennai', 'Tamil Nadu', '600042', '08:00:00', '22:00:00', 1, 4),
  (3, 'Sanjay Patel', 'pizza@example.com', '9100000003', '77 Central Avenue', NULL, 'Bengaluru', 'Karnataka', '560001', '10:00:00', '23:30:00', 1, 4);

-- foodCategory (6 rows)
INSERT INTO foodCategory (categoryId, restaurantId, categoryName, description, is_active) VALUES
  (1, 1, 'Hyderabadi Biryani', 'Rice specials', 1),
  (2, 1, 'Hyderabadi Starters', 'Appetizers', 1),
  (3, 2, 'South Indian Breakfast', 'Dosa and idli', 1),
  (4, 2, 'Healthy Bowls', 'Fresh meals', 1),
  (5, 3, 'Italian Pizza', 'Stone baked pizzas', 1),
  (6, 3, 'Italian Sides', 'Side dishes', 1);

-- menuItem (9 rows)
INSERT INTO menuItem (menuItemId, restaurantId, categoryId, itemName, description, price, foodType, is_available) VALUES
  (1, 1, 1, 'Chicken Biryani', 'Spiced chicken rice', 249, 'NON_VEG', 1),
  (2, 1, 1, 'Veg Biryani', 'Vegetable rice', 189, 'VEG', 1),
  (3, 1, 2, 'Paneer Tikka', 'Grilled paneer', 199, 'VEG', 1),
  (4, 2, 3, 'Masala Dosa', 'Dosa with potato filling', 120, 'VEG', 1),
  (5, 2, 3, 'Idli Sambar', 'Steamed idli', 90, 'VEG', 1),
  (6, 2, 4, 'Quinoa Bowl', 'Vegetables and quinoa', 220, 'VEG', 1),
  (7, 3, 5, 'Margherita Pizza', 'Classic cheese pizza', 299, 'VEG', 1),
  (8, 3, 5, 'Chicken Pizza', 'Spicy chicken pizza', 399, 'NON_VEG', 1),
  (9, 3, 6, 'Garlic Bread', 'Toasted garlic bread', 129, 'VEG', 1);

-- cart (5 rows)
INSERT INTO cart (cartId, customerId, restaurantId) VALUES
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3),
  (4, 4, NULL),
  (5, 5, 1);

-- cartItem (6 rows)
INSERT INTO cartItem (cartItemId, cartId, menuItemId, quantity) VALUES
  (1, 1, 1, 2),
  (2, 1, 3, 1),
  (3, 2, 4, 1),
  (4, 2, 5, 2),
  (5, 3, 7, 1),
  (6, 5, 2, 2);

-- coupon (3 rows)
INSERT INTO coupon (couponId, couponCode, discountType, discountValue, min_order_value, max_discount, validfrom, validto, per_customer_limit, total_usage_limit, isActive) VALUES
  (1, 'WELCOME10', 'PERCENT', 10, 200, 100, '2026-01-01 00:00:00', '2027-12-31 23:59:59', 2, 1000, 1),
  (2, 'FLAT50', 'FIXED', 50, 300, NULL, '2026-01-01 00:00:00', '2027-12-31 23:59:59', 3, 500, 1),
  (3, 'SAVE20', 'PERCENT', 20, 500, 150, '2026-01-01 00:00:00', '2027-12-31 23:59:59', 1, 200, 1);

-- customerOrder (6 rows)
INSERT INTO customerOrder (orderId, customerId, restaurantId, addressId, couponId, orderTime, orderStatus, restaurantDecision, subtotal, deliveryCharge, discountAmt, totalAmt, specialInstructions) VALUES
  (1, 1, 1, 1, 1, '2026-11-10 12:00:00', 'DELIVERED', 'ACCEPTED', 697, 40, 69.7, 667.3, 'Less spicy'),
  (2, 2, 2, 3, NULL, '2026-11-11 08:30:00', 'DELIVERED', 'ACCEPTED', 300, 30, 0, 330, NULL),
  (3, 3, 3, 4, 2, '2026-11-12 19:15:00', 'DELIVERED', 'ACCEPTED', 428, 40, 50, 418, 'Extra sauce'),
  (4, 1, 1, 2, NULL, '2026-11-13 13:10:00', 'CANCELLED', 'REJECTED', 189, 30, 0, 219, NULL),
  (5, 5, 1, 6, 3, '2026-11-14 20:00:00', 'PREPARING', 'ACCEPTED', 687, 40, 137.4, 589.6, 'No onions'),
  (6, 2, 2, 3, NULL, '2026-11-15 09:00:00', 'PLACED', 'PENDING', 120, 30, 0, 150, NULL);

-- orderItem (10 rows)
INSERT INTO orderItem (orderItemId, orderId, menuItemId, itemName, quantity, unitPrice) VALUES
  (1, 1, 1, 'Chicken Biryani', 2, 249),
  (2, 1, 3, 'Paneer Tikka', 1, 199),
  (3, 2, 4, 'Masala Dosa', 1, 120),
  (4, 2, 5, 'Idli Sambar', 2, 90),
  (5, 3, 7, 'Margherita Pizza', 1, 299),
  (6, 3, 9, 'Garlic Bread', 1, 129),
  (7, 4, 2, 'Veg Biryani', 1, 189),
  (8, 5, 1, 'Chicken Biryani', 2, 249),
  (9, 5, 2, 'Veg Biryani', 1, 189),
  (10, 6, 4, 'Masala Dosa', 1, 120);

-- payment (7 rows)
INSERT INTO payment (paymentId, orderId, attemptNo, paymentMethod, transactionrefNum, amount, paymentStatus, paymentDate, failureReason) VALUES
  (1, 1, 1, 'UPI', 'TXN1001', 667.3, 'SUCCESS', '2026-11-10 12:01:00', NULL),
  (2, 2, 1, 'CREDIT_CARD', 'TXN1002', 330, 'SUCCESS', '2026-11-11 08:31:00', NULL),
  (3, 3, 1, 'UPI', NULL, 418, 'FAILED', NULL, 'Bank timeout'),
  (4, 3, 2, 'UPI', 'TXN1003', 418, 'SUCCESS', '2026-11-12 19:18:00', NULL),
  (5, 4, 1, 'UPI', 'TXN1004', 219, 'REFUNDED', '2026-11-13 13:11:00', NULL),
  (6, 5, 1, 'DEBIT_CARD', 'TXN1005', 589.6, 'SUCCESS', '2026-11-14 20:01:00', NULL),
  (7, 6, 1, 'COD', NULL, 150, 'INITIATED', NULL, NULL);

-- deliveryPartner (3 rows)
INSERT INTO deliveryPartner (partnerId, partnerFirstName, partnerLastName, mobile, vehicleNumber, vehicleType, availabilityStatus, isActive, rating) VALUES
  (1, 'Kiran', 'Reddy', '9200000001', 'TS09AB1001', 'BIKE', 'AVAILABLE', 1, 5),
  (2, 'Deepa', 'Singh', '9200000002', 'TN10CD2002', 'SCOOTER', 'AVAILABLE', 1, 4),
  (3, 'Rahul', 'Verma', '9200000003', 'KA03EF3003', 'BIKE', 'BUSY', 1, 5);

-- delivery (3 rows)
INSERT INTO delivery (deliveryId, orderId, partnerId, assignmentStatus, deliveryStatus, assigned_at, accepted_at, pickup_at, delivered_at, estimated_delivery_at) VALUES
  (1, 1, 1, 'ACCEPTED', 'DELIVERED', '2026-11-10 12:20:00', '2026-11-10 12:21:00', '2026-11-10 12:40:00', '2026-11-10 13:05:00', '2026-11-10 13:10:00'),
  (2, 2, 2, 'ACCEPTED', 'DELIVERED', '2026-11-11 08:45:00', '2026-11-11 08:46:00', '2026-11-11 09:00:00', '2026-11-11 09:25:00', '2026-11-11 09:30:00'),
  (3, 3, 3, 'ACCEPTED', 'DELIVERED', '2026-11-12 19:30:00', '2026-11-12 19:32:00', '2026-11-12 19:55:00', '2026-11-12 20:25:00', '2026-11-12 20:30:00');

-- order_status_history (12 rows)
INSERT INTO order_status_history (historyId, orderId, orderStatus, changed_at, note, changed_by_type, changed_by_id) VALUES
  (1, 1, 'PLACED', '2026-11-10 12:00:00', 'Order created', 'CUSTOMER', 1),
  (2, 1, 'CONFIRMED', '2026-11-10 12:05:00', 'Accepted', 'RESTAURANT', 1),
  (3, 1, 'DELIVERED', '2026-11-10 13:05:00', 'Delivered', 'PARTNER', 1),
  (4, 2, 'PLACED', '2026-11-11 08:30:00', 'Order created', 'CUSTOMER', 2),
  (5, 2, 'DELIVERED', '2026-11-11 09:25:00', 'Delivered', 'PARTNER', 2),
  (6, 3, 'PLACED', '2026-11-12 19:15:00', 'Order created', 'CUSTOMER', 3),
  (7, 3, 'DELIVERED', '2026-11-12 20:25:00', 'Delivered', 'PARTNER', 3),
  (8, 4, 'PLACED', '2026-11-13 13:10:00', 'Order created', 'CUSTOMER', 1),
  (9, 4, 'CANCELLED', '2026-11-13 13:15:00', 'Kitchen unavailable', 'RESTAURANT', 1),
  (10, 5, 'PLACED', '2026-11-14 20:00:00', 'Order created', 'CUSTOMER', 5),
  (11, 5, 'PREPARING', '2026-11-14 20:08:00', 'Preparing food', 'RESTAURANT', 1),
  (12, 6, 'PLACED', '2026-11-15 09:00:00', 'Order created', 'CUSTOMER', 2);

-- review (4 rows)
INSERT INTO review (reviewId, orderId, customerId, restaurantId, menuItemId, rating, reviewComments) VALUES
  (1, 1, 1, 1, NULL, 5, 'Fast delivery'),
  (2, 1, 1, 1, 1, 5, 'Great biryani'),
  (3, 2, 2, 2, NULL, 4, 'Fresh breakfast'),
  (4, 3, 3, 3, 7, 5, 'Tasty pizza');

-- couponRedemption (3 rows)
INSERT INTO couponRedemption (redemptionId, couponId, customerId, orderId, discountAmount, redeemed_at) VALUES
  (1, 1, 1, 1, 69.7, '2026-11-10 12:00:00'),
  (2, 2, 3, 3, 50, '2026-11-12 19:15:00'),
  (3, 3, 5, 5, 137.4, '2026-11-14 20:00:00');

-- refund (1 rows)
INSERT INTO refund (refundId, paymentId, orderId, refund_ref, amount, reason, refund_status, requested_at, processed_at) VALUES
  (1, 5, 4, 'RF1001', 219, 'Restaurant rejected order', 'SUCCESS', '2026-11-13 13:16:00', '2026-11-13 14:00:00');

-- restaurant_order_cancellation (1 rows)
INSERT INTO restaurant_order_cancellation (cancellationId, orderId, cancelled_by, reason_code, reason_text, cancelled_at) VALUES
  (1, 4, 'RESTAURANT', 'KITCHEN_CLOSED', 'Kitchen unavailable for order', '2026-11-13 13:15:00');

SELECT * FROM customer;
