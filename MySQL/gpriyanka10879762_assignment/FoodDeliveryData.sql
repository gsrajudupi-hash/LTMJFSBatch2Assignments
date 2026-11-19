-- =====================================================================
-- OFDMS  02_sample_data.sql : sample records
-- Load order: run after 01_schema.sql
-- Data is engineered so all 30 business queries return meaningful rows.
-- =====================================================================
USE foodDeliveryDB;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------- CUSTOMERS (C7 never orders; C6 orders but never reviews) ----------
INSERT INTO customer (customer_id, full_name, email, mobile, password_hash) VALUES
(1,'Rahul Sharma','rahul.sharma@example.com','9800000001','hash1'),
(2,'Priya Menon','priya.menon@example.com','9800000002','hash2'),
(3,'Arjun Nair','arjun.nair@example.com','9800000003','hash3'),
(4,'Sneha Reddy','sneha.reddy@example.com','9800000004','hash4'),
(5,'Vikram Singh','vikram.singh@example.com','9800000005','hash5'),
(6,'Deepa Iyer','deepa.iyer@example.com','9800000006','hash6'),
(7,'Karthik Rao','karthik.rao@example.com','9800000007','hash7'),
(8,'Ananya Das','ananya.das@example.com','9800000008','hash8');

-- ---------- ADDRESSES (sample keeps one default address per customer) ----------
INSERT INTO customer_address (customer_id, label, line1, city, state, pincode, is_default) VALUES
(1,'Home','12 Jubilee Hills','Hyderabad','Telangana','500033',1),
(1,'Work','Hitech City Rd','Hyderabad','Telangana','500081',0),
(2,'Home','45 Banjara Hills','Hyderabad','Telangana','500034',1),
(3,'Home','7 Gachibowli','Hyderabad','Telangana','500032',1),
(4,'Home','90 Kukatpally','Hyderabad','Telangana','500072',1),
(5,'Home','3 Madhapur','Hyderabad','Telangana','500081',1),
(6,'Home','21 Begumpet','Hyderabad','Telangana','500016',1),
(8,'Home','14 Ameerpet','Hyderabad','Telangana','500038',1);

-- ---------- RESTAURANTS (R5 inactive; R4 & R5 receive no orders) ----------
INSERT INTO restaurant
 (restaurant_id,name,address_line,city,state,pincode,contact_number,email,opening_time,closing_time,is_active) VALUES
(1,'Spice Junction','Rd No 1, Jubilee Hills','Hyderabad','Telangana','500033','9900000001','contact@spicejunction.com','08:00:00','23:30:00',1),
(2,'Dragon Wok','Hitech City','Hyderabad','Telangana','500081','9900000002','hello@dragonwok.com','11:00:00','23:00:00',1),
(3,'Burger Barn','Gachibowli','Hyderabad','Telangana','500032','9900000003','team@burgerbarn.com','10:00:00','23:59:00',1),
(4,'Sweet Treats','Banjara Hills','Hyderabad','Telangana','500034','9900000004','care@sweettreats.com','09:00:00','22:00:00',1),
(5,'Old Town Cafe','Secunderabad','Hyderabad','Telangana','500003','9900000005','info@oldtowncafe.com','08:00:00','20:00:00',0);

-- ---------- FOOD CATEGORIES ----------
INSERT INTO food_category (category_id,name,description) VALUES
(1,'South Indian','Dosa, idli, vada and more'),
(2,'North Indian','Curries, breads, biryani'),
(3,'Chinese','Indo-Chinese favourites'),
(4,'Fast Food','Burgers, fries, quick bites'),
(5,'Desserts','Sweets and bakes'),
(6,'Beverages','Hot and cold drinks');

-- ---------- MENU ITEMS (items 7,16,17,18 are never ordered) ----------
INSERT INTO menu_item (item_id,restaurant_id,category_id,name,description,price,is_veg,is_available) VALUES
(1 ,1,1,'Masala Dosa','Crisp dosa with potato masala',120.00,1,1),
(2 ,1,1,'Idli Vada','Two idlis and a vada',90.00 ,1,1),
(3 ,1,2,'Paneer Butter Masala','Creamy paneer curry',240.00,1,1),
(4 ,1,2,'Chicken Biryani','Hyderabadi dum biryani',280.00,0,1),
(5 ,1,2,'Butter Naan','Tandoor butter naan',40.00 ,1,1),
(6 ,1,6,'Filter Coffee','South Indian filter coffee',50.00,1,1),
(7 ,1,6,'Mango Lassi','Thick mango yogurt drink',80.00,1,1),
(8 ,2,3,'Veg Hakka Noodles','Wok-tossed noodles',160.00,1,1),
(9 ,2,3,'Chicken Manchurian','Spicy chicken manchurian',220.00,0,1),
(10,2,3,'Veg Fried Rice','Classic fried rice',150.00,1,1),
(11,2,3,'Spring Rolls','Veg spring rolls (4 pc)',110.00,1,1),
(12,3,4,'Veg Burger','Crunchy veg patty burger',100.00,1,1),
(13,3,4,'Chicken Burger','Grilled chicken burger',150.00,0,1),
(14,3,4,'French Fries','Salted fries',80.00,1,1),
(15,3,6,'Cold Coffee','Iced cold coffee',120.00,1,1),
(16,4,5,'Gulab Jamun','Two pieces in syrup',90.00,1,1),
(17,4,5,'Chocolate Brownie','Warm fudge brownie',130.00,1,1),
(18,5,4,'Veg Sandwich','Grilled veg sandwich',70.00,1,0);

-- ---------- PRICE HISTORY (Paneer Butter Masala 220 -> 240) ----------
INSERT INTO menu_item_price_history (item_id, old_price, new_price, changed_at) VALUES
(3, 220.00, 240.00, '2026-07-01 10:00:00');

-- ---------- COUPONS ----------
INSERT INTO coupon
 (coupon_id,code,description,discount_type,discount_value,max_discount_amount,min_order_value,
  valid_from,valid_to,is_active) VALUES
(1,'WELCOME50','Flat 50 off on first order','FIXED',50.00,NULL,300.00,'2026-01-01','2026-12-31',1),
(2,'SAVE20','20% off up to 150','PERCENT',20.00,150.00,500.00,'2026-01-01','2026-12-31',1),
(3,'NEWUSER','Flat 75 off (unused)','FIXED',75.00,NULL,400.00,'2026-01-01','2026-12-31',1);

-- ---------- DELIVERY PARTNERS (P5 unavailable) ----------
INSERT INTO delivery_partner (partner_id,full_name,mobile,vehicle_type,vehicle_number,is_available) VALUES
(1,'Suresh Kumar','9700000001','BIKE','TS09AB1234',1),
(2,'Ramesh Babu','9700000002','SCOOTER','TS09CD5678',1),
(3,'Mahesh Varma','9700000003','BIKE','TS09EF9012',1),
(4,'Ganesh Pillai','9700000004','BICYCLE',NULL,1),
(5,'Dinesh Goud','9700000005','CAR','TS09GH3456',0);

-- =====================================================================
-- ORDERS (16 orders; subtotal, charges and total_amount are stored)
-- total_amount = subtotal + delivery_charge - discount_amount
-- coupon_id is set where a coupon was applied (orders 2 and 9)
-- =====================================================================
INSERT INTO orders
 (order_id,customer_id,restaurant_id,address_id,coupon_id,order_datetime,status,
  subtotal,delivery_charge,discount_amount,total_amount,estimated_delivery_time,cancellation_reason) VALUES
(1 ,1,1,1 ,NULL,'2026-08-05 12:30:00','DELIVERED',340.00,30.00,0.00  ,370.00,'2026-08-05 13:15:00',NULL),
(2 ,1,2,2 ,1   ,'2026-09-10 20:05:00','DELIVERED',380.00,40.00,50.00 ,370.00,'2026-09-10 20:50:00',NULL),
(3 ,1,3,1 ,NULL,'2026-10-02 13:10:00','DELIVERED',280.00,25.00,0.00  ,305.00,'2026-10-02 13:55:00',NULL),
(4 ,2,1,3 ,NULL,'2026-08-15 19:40:00','DELIVERED',360.00,30.00,0.00  ,390.00,'2026-08-15 20:25:00',NULL),
(5 ,2,1,3 ,NULL,'2026-09-20 18:00:00','CANCELLED',240.00,30.00,0.00  ,270.00,NULL,'Customer changed mind'),
(6 ,3,2,4 ,NULL,'2026-09-05 21:15:00','DELIVERED',410.00,35.00,0.00  ,445.00,'2026-09-05 22:00:00',NULL),
(7 ,4,1,5 ,NULL,'2026-08-25 09:20:00','DELIVERED',260.00,25.00,0.00  ,285.00,'2026-08-25 10:05:00',NULL),
(8 ,4,3,5 ,NULL,'2026-10-12 14:00:00','DELIVERED',420.00,30.00,0.00  ,450.00,'2026-10-12 14:45:00',NULL),
(9 ,5,1,6 ,2   ,'2026-08-30 20:30:00','DELIVERED',800.00,0.00 ,150.00,650.00,'2026-08-30 21:15:00',NULL),
(10,5,2,6 ,NULL,'2026-09-18 21:00:00','DELIVERED',600.00,0.00 ,0.00  ,600.00,'2026-09-18 21:40:00',NULL),
(11,5,3,6 ,NULL,'2026-10-08 13:30:00','DELIVERED',410.00,25.00,0.00  ,435.00,'2026-10-08 14:10:00',NULL),
(12,5,1,6 ,NULL,'2026-10-20 12:00:00','DELIVERED',420.00,30.00,0.00  ,450.00,'2026-10-20 12:45:00',NULL),
(13,6,1,7 ,NULL,'2026-09-28 11:45:00','DELIVERED',360.00,30.00,0.00  ,390.00,'2026-09-28 12:30:00',NULL),
(14,6,2,7 ,NULL,'2026-10-15 20:20:00','DELIVERED',370.00,35.00,0.00  ,405.00,'2026-10-15 21:05:00',NULL),
(15,6,3,7 ,NULL,'2026-11-10 19:30:00','OUT_FOR_DELIVERY',100.00,20.00,0.00,120.00,'2026-11-10 20:10:00',NULL),
(16,8,2,8 ,NULL,'2026-10-25 22:10:00','CANCELLED',110.00,20.00,0.00  ,130.00,NULL,'Restaurant closed');

-- ---------- ORDER ITEMS (item_name + unit_price snapshotted) ----------
INSERT INTO order_item (order_id,item_id,item_name,unit_price,quantity) VALUES
(1,1,'Masala Dosa',120.00,2),(1,6,'Filter Coffee',50.00,2),
(2,8,'Veg Hakka Noodles',160.00,1),(2,9,'Chicken Manchurian',220.00,1),
(3,12,'Veg Burger',100.00,2),(3,14,'French Fries',80.00,1),
(4,4,'Chicken Biryani',280.00,1),(4,5,'Butter Naan',40.00,2),
(5,3,'Paneer Butter Masala',240.00,1),
(6,10,'Veg Fried Rice',150.00,2),(6,11,'Spring Rolls',110.00,1),
(7,1,'Masala Dosa',120.00,1),(7,2,'Idli Vada',90.00,1),(7,6,'Filter Coffee',50.00,1),
(8,13,'Chicken Burger',150.00,2),(8,15,'Cold Coffee',120.00,1),
(9,4,'Chicken Biryani',280.00,2),(9,3,'Paneer Butter Masala',240.00,1),
(10,9,'Chicken Manchurian',220.00,2),(10,8,'Veg Hakka Noodles',160.00,1),
(11,13,'Chicken Burger',150.00,1),(11,12,'Veg Burger',100.00,1),(11,14,'French Fries',80.00,2),
(12,4,'Chicken Biryani',280.00,1),(12,5,'Butter Naan',40.00,1),(12,6,'Filter Coffee',50.00,2),
(13,1,'Masala Dosa',120.00,3),
(14,10,'Veg Fried Rice',150.00,1),(14,11,'Spring Rolls',110.00,2),
(15,12,'Veg Burger',100.00,1),
(16,11,'Spring Rolls',110.00,1);

-- ---------- PAYMENTS (order 9 shows a failed attempt then a retry) ----------
INSERT INTO payment (order_id,method,amount,txn_reference,status,attempt_no,paid_at) VALUES
(1 ,'UPI'        ,370.00,'TXN0001','SUCCESS' ,1,'2026-08-05 12:31:00'),
(2 ,'UPI'        ,370.00,'TXN0002','SUCCESS' ,1,'2026-09-10 20:06:00'),
(3 ,'CREDIT_CARD',305.00,'TXN0003','SUCCESS' ,1,'2026-10-02 13:11:00'),
(4 ,'UPI'        ,390.00,'TXN0004','SUCCESS' ,1,'2026-08-15 19:41:00'),
(5 ,'UPI'        ,270.00,'TXN0005','REFUNDED',1,'2026-09-20 18:01:00'),
(6 ,'DEBIT_CARD' ,445.00,'TXN0006','SUCCESS' ,1,'2026-09-05 21:16:00'),
(7 ,'COD'        ,285.00,NULL     ,'SUCCESS' ,1,'2026-08-25 10:05:00'),
(8 ,'UPI'        ,450.00,'TXN0008','SUCCESS' ,1,'2026-10-12 14:01:00'),
(9 ,'UPI'        ,650.00,'TXN0009','FAILED'  ,1,'2026-08-30 20:31:00'),
(9 ,'CREDIT_CARD',650.00,'TXN0010','SUCCESS' ,2,'2026-08-30 20:33:00'),
(10,'UPI'        ,600.00,'TXN0011','SUCCESS' ,1,'2026-09-18 21:01:00'),
(11,'DEBIT_CARD' ,435.00,'TXN0012','SUCCESS' ,1,'2026-10-08 13:31:00'),
(12,'COD'        ,450.00,NULL     ,'SUCCESS' ,1,'2026-10-20 12:45:00'),
(13,'UPI'        ,390.00,'TXN0014','SUCCESS' ,1,'2026-09-28 11:46:00'),
(14,'UPI'        ,405.00,'TXN0015','SUCCESS' ,1,'2026-10-15 20:21:00'),
(15,'UPI'        ,120.00,'TXN0016','PENDING' ,1,NULL),
(16,'UPI'        ,130.00,'TXN0017','REFUNDED',1,'2026-10-25 22:11:00');

-- ---------- REFUNDS (for the two cancelled, prepaid orders) ----------
INSERT INTO refund (order_id,payment_id,amount,reason,status,refunded_at) VALUES
(5 ,(SELECT payment_id FROM payment WHERE txn_reference='TXN0005'),270.00,'Order cancelled by customer','COMPLETED','2026-09-20 18:30:00'),
(16,(SELECT payment_id FROM payment WHERE txn_reference='TXN0017'),130.00,'Restaurant was closed','COMPLETED','2026-10-25 22:40:00');

-- ---------- COUPON REDEMPTIONS (C1 used WELCOME50, C5 used SAVE20) ----------
INSERT INTO coupon_redemption (coupon_id,customer_id,order_id,discount_applied) VALUES
(1,1,2,50.00),
(2,5,9,150.00);

-- =====================================================================
-- DELIVERIES (P1 completes 7, P2 3, P3 2, P4 1; order 15 still en route)
-- =====================================================================
INSERT INTO delivery (order_id,partner_id,assignment_status,assigned_at,picked_up_at,delivered_at) VALUES
(1 ,1,'DELIVERED','2026-08-05 12:40:00','2026-08-05 12:55:00','2026-08-05 13:14:00'),
(2 ,1,'DELIVERED','2026-09-10 20:15:00','2026-09-10 20:30:00','2026-09-10 20:48:00'),
(4 ,1,'DELIVERED','2026-08-15 19:50:00','2026-08-15 20:05:00','2026-08-15 20:24:00'),
(7 ,1,'DELIVERED','2026-08-25 09:30:00','2026-08-25 09:45:00','2026-08-25 10:04:00'),
(9 ,1,'DELIVERED','2026-08-30 20:40:00','2026-08-30 20:55:00','2026-08-30 21:14:00'),
(11,1,'DELIVERED','2026-10-08 13:40:00','2026-10-08 13:55:00','2026-10-08 14:09:00'),
(13,1,'DELIVERED','2026-09-28 11:55:00','2026-09-28 12:10:00','2026-09-28 12:29:00'),
(3 ,2,'DELIVERED','2026-10-02 13:20:00','2026-10-02 13:35:00','2026-10-02 13:54:00'),
(8 ,2,'DELIVERED','2026-10-12 14:10:00','2026-10-12 14:25:00','2026-10-12 14:44:00'),
(14,2,'DELIVERED','2026-10-15 20:30:00','2026-10-15 20:45:00','2026-10-15 21:04:00'),
(6 ,3,'DELIVERED','2026-09-05 21:25:00','2026-09-05 21:40:00','2026-09-05 21:59:00'),
(10,3,'DELIVERED','2026-09-18 21:10:00','2026-09-18 21:25:00','2026-09-18 21:39:00'),
(12,4,'DELIVERED','2026-10-20 12:10:00','2026-10-20 12:25:00','2026-10-20 12:44:00'),
(15,3,'PICKED_UP','2026-11-10 19:40:00','2026-11-10 19:55:00',NULL);

-- ---------- ORDER STATUS HISTORY ----------
-- Full chain for order 1 and 9, cancellation chain for 5, in-progress for 15,
-- and a PLACED/DELIVERED pair for every other delivered order.
INSERT INTO order_status_history (order_id,status,changed_at,notes) VALUES
(1,'PLACED','2026-08-05 12:30:00','Order placed'),
(1,'CONFIRMED','2026-08-05 12:33:00','Restaurant accepted'),
(1,'PREPARING','2026-08-05 12:38:00',NULL),
(1,'READY_FOR_PICKUP','2026-08-05 12:52:00',NULL),
(1,'OUT_FOR_DELIVERY','2026-08-05 12:56:00',NULL),
(1,'DELIVERED','2026-08-05 13:14:00','Delivered to customer'),
(9,'PLACED','2026-08-30 20:30:00','Order placed'),
(9,'CONFIRMED','2026-08-30 20:34:00','Paid after retry'),
(9,'PREPARING','2026-08-30 20:40:00',NULL),
(9,'OUT_FOR_DELIVERY','2026-08-30 20:56:00',NULL),
(9,'DELIVERED','2026-08-30 21:14:00','Delivered'),
(5,'PLACED','2026-09-20 18:00:00','Order placed'),
(5,'CONFIRMED','2026-09-20 18:02:00',NULL),
(5,'CANCELLED','2026-09-20 18:10:00','Customer changed mind'),
(15,'PLACED','2026-11-10 19:30:00','Order placed'),
(15,'CONFIRMED','2026-11-10 19:34:00',NULL),
(15,'PREPARING','2026-11-10 19:38:00',NULL),
(15,'OUT_FOR_DELIVERY','2026-11-10 19:56:00',NULL),
(2 ,'PLACED','2026-09-10 20:05:00',NULL),(2 ,'DELIVERED','2026-09-10 20:48:00',NULL),
(3 ,'PLACED','2026-10-02 13:10:00',NULL),(3 ,'DELIVERED','2026-10-02 13:54:00',NULL),
(4 ,'PLACED','2026-08-15 19:40:00',NULL),(4 ,'DELIVERED','2026-08-15 20:24:00',NULL),
(6 ,'PLACED','2026-09-05 21:15:00',NULL),(6 ,'DELIVERED','2026-09-05 21:59:00',NULL),
(7 ,'PLACED','2026-08-25 09:20:00',NULL),(7 ,'DELIVERED','2026-08-25 10:04:00',NULL),
(8 ,'PLACED','2026-10-12 14:00:00',NULL),(8 ,'DELIVERED','2026-10-12 14:44:00',NULL),
(10,'PLACED','2026-09-18 21:00:00',NULL),(10,'DELIVERED','2026-09-18 21:39:00',NULL),
(11,'PLACED','2026-10-08 13:30:00',NULL),(11,'DELIVERED','2026-10-08 14:09:00',NULL),
(12,'PLACED','2026-10-20 12:00:00',NULL),(12,'DELIVERED','2026-10-20 12:44:00',NULL),
(13,'PLACED','2026-09-28 11:45:00',NULL),(13,'DELIVERED','2026-09-28 12:29:00',NULL),
(14,'PLACED','2026-10-15 20:20:00',NULL),(14,'DELIVERED','2026-10-15 21:04:00',NULL),
(16,'PLACED','2026-10-25 22:10:00',NULL),(16,'CANCELLED','2026-10-25 22:12:00','Restaurant closed');

-- ---------- RESTAURANT REVIEWS (only from delivered, eligible orders) ----------
INSERT INTO restaurant_review (customer_id,restaurant_id,order_id,rating,comment) VALUES
(1,1,1,5,'Great dosa, fast delivery'),
(1,2,2,4,'Tasty noodles'),
(1,3,3,3,'Average burger'),
(4,1,7,4,'Good filter coffee'),
(5,1,9,5,'Best biryani in town'),
(5,2,10,5,'Loved the manchurian'),
(3,2,6,3,'Was okay'),
(4,3,8,4,'Juicy chicken burger');delivery

-- ---------- MENU ITEM REVIEWS (food-level reviews) ----------
INSERT INTO menu_item_review (customer_id,item_id,order_id,rating,comment) VALUES
(1,1,1,5,'Perfectly crisp'),
(5,4,9,5,'Authentic dum biryani'),
(4,13,8,4,'Well grilled');

-- ---------- ACTIVE CARTS (C5 shopping at R1; C1 shopping at R2) ----------
INSERT INTO cart (cart_id,customer_id,restaurant_id) VALUES
(1,5,1),
(2,1,2);

INSERT INTO cart_item (cart_id,item_id,quantity) VALUES
(1,4,1),(1,6,2),   -- Vikram: 1 biryani + 2 filter coffees
(2,8,2);           -- Rahul: 2 veg hakka noodles
