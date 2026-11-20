USE db_online_food_delivery_app;

INSERT INTO tbl_roles(role_code,role_name,role_description,is_active) VALUES
('SUPER_ADMIN','Super Admin','Platform-wide administration',TRUE),
('CUSTOMER','Customer','Browse and order food',TRUE),
('RESTAURANT_OWNER','Restaurant Owner','Manage owned restaurant',TRUE),
('RESTAURANT_MANAGER','Restaurant Manager','Manage assigned branch',TRUE),
('RESTAURANT_STAFF','Restaurant Staff','Process restaurant orders',TRUE),
('DELIVERY_PARTNER','Delivery Partner','Accept and deliver orders',TRUE),
('CUSTOMER_SUPPORT','Customer Support','Handle customer issues',TRUE),
('DELIVERY_MANAGER','Delivery Manager','Manage delivery operations',TRUE);

SELECT * FROM tbl_roles;

INSERT INTO tbl_permissions(permission_code,permission_name,module_name) VALUES
('USER_VIEW','View users','USER'),('USER_CREATE','Create users','USER'),
('RESTAURANT_VIEW','View restaurants','RESTAURANT'),('RESTAURANT_UPDATE','Update restaurants','RESTAURANT'),
('MENU_VIEW','View menus','MENU'),('MENU_CREATE','Create menu items','MENU'),('MENU_UPDATE','Update menu items','MENU'),
('ORDER_CREATE','Create orders','ORDER'),('ORDER_VIEW','View orders','ORDER'),('ORDER_UPDATE_STATUS','Update order status','ORDER'),('ORDER_CANCEL','Cancel orders','ORDER'),
('PAYMENT_VIEW','View payments','PAYMENT'),('PAYMENT_PROCESS','Process payments','PAYMENT'),('REFUND_PROCESS','Process refunds','PAYMENT'),
('DELIVERY_ASSIGN','Assign deliveries','DELIVERY'),('DELIVERY_TRACK','Track deliveries','DELIVERY'),('DELIVERY_UPDATE_STATUS','Update delivery status','DELIVERY'),
('COUPON_CREATE','Create coupons','COUPON'),('COUPON_VIEW','View coupons','COUPON'),('REVIEW_CREATE','Create reviews','REVIEW'),('REVIEW_VIEW','View reviews','REVIEW');

-- Grant all permissions to super admin (run once; unique key prevents duplicates)
INSERT IGNORE INTO tbl_role_permissions(role_id,permission_id)
SELECT r.role_id,p.permission_id FROM tbl_roles r CROSS JOIN tbl_permissions p
WHERE r.role_code='SUPER_ADMIN';


-- Q01 registered customers
SELECT u.user_id,u.first_name,u.last_name,u.email,u.phone
FROM tbl_users u JOIN tbl_customers c ON c.user_id=u.user_id
WHERE u.created_at IS NOT NULL;

-- Q02 active restaurants
SELECT restaurant_id,restaurant_name,contact_number FROM restaurants
WHERE restaurant_status='ACTIVE';

-- Q03 vegetarian food items
SELECT menu_item_id,food_name,current_price FROM tbl_menu_items
WHERE food_type='VEG' AND availability_status='AVAILABLE';

-- Q04 food items for a restaurant (parameter: @restaurant_id)
SELECT r.restaurant_name,b.branch_name,mi.food_name,mi.current_price
FROM tbl_restaurants r JOIN tbl_restaurant_branches b ON b.restaurant_id=r.restaurant_id
JOIN tbl_menus m ON m.branch_id=b.branch_id JOIN tbl_menu_items mi ON mi.menu_id=m.menu_id
WHERE r.restaurant_id=@restaurant_id;

-- Q05 items priced above INR 200
SELECT food_name,current_price FROM tbl_menu_items WHERE current_price>200;

-- Q06 orders for a customer (parameter: @customer_id)
SELECT * FROM tbl_orders WHERE customer_id=@customer_id ORDER BY order_date ASC;

-- Q07 orders placed on a date (parameter: @order_day, DATE)
SELECT * FROM tbl_orders WHERE order_date >= @order_day
AND order_date < DATE_ADD(@order_day,INTERVAL 1 DAY);

-- Q08 available delivery partners
SELECT dp.delivery_partner_id,u.first_name,u.last_name,u.phone
FROM tbl_delivery_partners dp JOIN tbl_users u ON u.user_id=dp.user_id
WHERE dp.availability_status='AVAILABLE' AND dp.verification_status='VERIFIED';

-- Q09 customer details with delivery addresses
SELECT c.customer_id,u.first_name,u.last_name,a.address_line1,a.city,a.postal_code,ca.is_default
FROM tbl_customers c JOIN tbl_users u ON u.user_id=c.user_id
LEFT JOIN tbl_customer_addresses ca ON ca.customer_id=c.customer_id
LEFT JOIN tbl_addresses a ON a.address_id=ca.address_id;

-- Q10 restaurant names and food menu
SELECT r.restaurant_name,b.branch_name,mi.food_name,fc.category_name,mi.current_price
FROM tbl_restaurants r JOIN tbl_restaurant_branches b ON b.restaurant_id=r.restaurant_id
JOIN tbl_menus m ON m.branch_id=b.branch_id JOIN tbl_menu_items mi ON mi.menu_id=m.menu_id
JOIN tbl_food_categories fc ON fc.category_id=mi.category_id
ORDER BY r.restaurant_name,mi.food_name;

-- Q11 order details with customer and restaurant
SELECT o.order_number,u.first_name,u.phone,r.restaurant_name,ro.restaurant_order_number,
       ro.total_amount,ro.preparation_status
FROM tbl_orders o JOIN tbl_customers c ON c.customer_id=o.customer_id
JOIN tbl_users u ON u.user_id=c.user_id
JOIN tbl_restaurant_orders ro ON ro.order_id=o.order_id
JOIN tbl_restaurant_branches b ON b.branch_id=ro.branch_id
JOIN tbl_restaurants r ON r.restaurant_id=b.restaurant_id;

-- Q12 number of orders per customer (include zero)
SELECT c.customer_id,u.first_name,u.last_name,COUNT(o.order_id) total_orders
FROM tbl_customers c JOIN tbl_users u ON u.user_id=c.user_id
LEFT JOIN tbl_orders o ON o.customer_id=c.customer_id
GROUP BY c.customer_id,u.first_name,u.last_name;

-- Q13 available menu item count per restaurant
SELECT r.restaurant_id,r.restaurant_name,COUNT(mi.menu_item_id) available_items
FROM tbl_restaurants r LEFT JOIN tbl_restaurant_branches b ON b.restaurant_id=r.restaurant_id
LEFT JOIN tbl_menus m ON m.branch_id=b.branch_id
LEFT JOIN tbl_menu_items mi ON mi.menu_id=m.menu_id AND mi.availability_status='AVAILABLE'
GROUP BY r.restaurant_id,r.restaurant_name;

-- Q14 sales generated by restaurant (gross completed sales)
SELECT r.restaurant_id,r.restaurant_name,
       SUM(CASE WHEN o.order_status='DELIVERED' THEN ro.total_amount ELSE 0 END) delivered_sales
FROM tbl_restaurants r JOIN tbl_restaurant_branches b ON b.restaurant_id=r.restaurant_id
LEFT JOIN tbl_restaurant_orders ro ON ro.branch_id=b.branch_id
LEFT JOIN tbl_orders o ON o.order_id=ro.order_id
GROUP BY r.restaurant_id,r.restaurant_name;

-- Q15 most frequently ordered food item
SELECT food_name_snapshot,SUM(quantity) units_ordered
FROM tbl_order_items GROUP BY food_name_snapshot
ORDER BY units_ordered DESC LIMIT 2;

-- Q16 customers who never ordered
SELECT c.customer_id,u.first_name,u.last_name
FROM tbl_customers c JOIN tbl_users u ON u.user_id=c.user_id
WHERE EXISTS(SELECT 1 FROM tbl_orders o WHERE o.customer_id=c.customer_id);

-- Q17 delivery partners with more than five completed deliveries
SELECT dp.delivery_partner_id,u.first_name,u.last_name,COUNT(*) completed_deliveries
FROM tbl_delivery_partners dp JOIN tbl_users u ON u.user_id=dp.user_id
JOIN tbl_delivery_assignments da ON da.delivery_partner_id=dp.delivery_partner_id
WHERE da.assignment_status='COMPLETED'
GROUP BY dp.delivery_partner_id,u.first_name,u.last_name
HAVING COUNT(*)<5;

-- Q18 average rating per restaurant
SELECT r.restaurant_id,r.restaurant_name,ROUND(AVG(rv.rating),2) average_rating
FROM tbl_restaurants r LEFT JOIN tbl_reviews rv ON rv.restaurant_id=r.restaurant_id
GROUP BY r.restaurant_id,r.restaurant_name;

-- Q19 highest-spending customer (delivered orders)
SELECT c.customer_id,u.first_name,u.last_name,SUM(o.grand_total) total_spent
FROM customers c JOIN users u ON u.user_id=c.user_id
JOIN orders o ON o.customer_id=c.customer_id
WHERE o.order_status='DELIVERED'
GROUP BY c.customer_id,u.first_name,u.last_name
ORDER BY total_spent DESC LIMIT 1;

-- Q20 restaurant with highest delivered revenue
SELECT r.restaurant_id,r.restaurant_name,SUM(ro.total_amount) revenue
FROM tbl_restaurants r JOIN tbl_restaurant_branches b ON b.restaurant_id=r.restaurant_id
JOIN tbl_restaurant_orders ro ON ro.branch_id=b.branch_id
JOIN tbl_orders o ON o.order_id=ro.order_id
WHERE o.order_status='DELIVERED'
GROUP BY r.restaurant_id,r.restaurant_name
ORDER BY revenue DESC LIMIT 5;

-- Q21 second-highest distinct menu price (ties handled by DENSE_RANK)
WITH ranked_prices AS (
 SELECT menu_item_id,food_name,current_price,
        DENSE_RANK() OVER(ORDER BY current_price DESC) price_rank
 FROM tbl_menu_items
)
SELECT menu_item_id,food_name,current_price FROM ranked_prices WHERE price_rank=2;

-- Q22 restaurants above overall average restaurant rating
WITH restaurant_ratings AS (
 SELECT restaurant_id,AVG(rating) avg_rating FROM tbl_reviews GROUP BY restaurant_id
)
SELECT r.restaurant_id,r.restaurant_name,rr.avg_rating
FROM tbl_restaurants r JOIN tbl_restaurant_ratings rr ON rr.restaurant_id=r.restaurant_id
WHERE rr.avg_rating>(SELECT AVG(rating) FROM tbl_reviews);

-- Q23 customers with more orders than average number of orders per customer
WITH customer_counts AS (
 SELECT c.customer_id,COUNT(o.order_id) order_count
 FROM tbl_customers c LEFT JOIN tbl_orders o ON o.customer_id=c.customer_id
 GROUP BY c.customer_id
)
SELECT cc.customer_id,u.first_name,u.last_name,cc.order_count
FROM customer_counts cc JOIN tbl_customers c ON c.customer_id=cc.customer_id
JOIN tbl_users u ON u.user_id=c.user_id
WHERE cc.order_count>(SELECT AVG(order_count) FROM customer_counts);

-- Q24 food items never ordered
SELECT mi.menu_item_id,mi.food_name
FROM tbl_menu_items mi
WHERE NOT EXISTS(SELECT 1 FROM tbl_order_items oi WHERE oi.menu_item_id=mi.menu_item_id);

-- Q25 top three best-selling items
SELECT food_name_snapshot,SUM(quantity) units_sold
FROM tbl_order_items GROUP BY food_name_snapshot
ORDER BY units_sold DESC LIMIT 3;

-- Q26 customers who redeemed promotional coupons
SELECT DISTINCT c.customer_id,u.first_name,u.last_name,cp.coupon_code,cr.discount_amount
FROM coupon_redemptions cr JOIN customers c ON c.customer_id=cr.customer_id
JOIN users u ON u.user_id=c.user_id JOIN coupons cp ON cp.coupon_id=cr.coupon_id
WHERE cr.redemption_status='REDEEMED';

-- Q27 restaurants that have never received an order
SELECT r.restaurant_id,r.restaurant_name
FROM restaurants r
WHERE NOT EXISTS(
 SELECT 1 FROM restaurant_branches b JOIN restaurant_orders ro ON ro.branch_id=b.branch_id
 WHERE b.restaurant_id=r.restaurant_id
);

-- Q28 monthly restaurant revenue (MySQL DATE_FORMAT)
SELECT r.restaurant_id,r.restaurant_name,
       DATE_FORMAT(o.order_date,'%Y-%m') revenue_month,
       SUM(ro.total_amount) delivered_revenue
FROM restaurants r JOIN restaurant_branches b ON b.restaurant_id=r.restaurant_id
JOIN restaurant_orders ro ON ro.branch_id=b.branch_id
JOIN orders o ON o.order_id=ro.order_id
WHERE o.order_status='DELIVERED'
GROUP BY r.restaurant_id,r.restaurant_name,DATE_FORMAT(o.order_date,'%Y-%m')
ORDER BY revenue_month,r.restaurant_name;

-- Q29 delivery partner(s) with highest completed delivery count (ties retained)
WITH partner_counts AS (
 SELECT dp.delivery_partner_id,u.first_name,u.last_name,COUNT(*) completed_count
 FROM delivery_partners dp JOIN users u ON u.user_id=dp.user_id
 JOIN delivery_assignments da ON da.delivery_partner_id=dp.delivery_partner_id
 WHERE da.assignment_status='COMPLETED'
 GROUP BY dp.delivery_partner_id,u.first_name,u.last_name
)
SELECT * FROM partner_counts
WHERE completed_count=(SELECT MAX(completed_count) FROM partner_counts);

-- Q30 customers who ordered but have never submitted a restaurant review
SELECT DISTINCT c.customer_id,u.first_name,u.last_name
FROM customers c JOIN users u ON u.user_id=c.user_id
JOIN orders o ON o.customer_id=c.customer_id
WHERE NOT EXISTS(SELECT 1 FROM reviews rv WHERE rv.customer_id=c.customer_id);

-- RBAC: permission check scoped to a restaurant/branch.
-- Parameters: @user_id, @permission_code, @restaurant_id, @branch_id
SELECT EXISTS (
 SELECT 1
 FROM user_roles ur
 JOIN roles r ON r.role_id=ur.role_id AND r.is_active=TRUE
 JOIN role_permissions rp ON rp.role_id=r.role_id
 JOIN permissions p ON p.permission_id=rp.permission_id AND p.is_active=TRUE
 WHERE ur.user_id=@user_id AND ur.is_active=TRUE
   AND p.permission_code=@permission_code
   AND (ur.restaurant_id IS NULL OR ur.restaurant_id=@restaurant_id)
   AND (ur.branch_id IS NULL OR ur.branch_id=@branch_id)
) AS has_permission;

-- Transaction-safe order placement pattern (application validates availability and totals).
-- Lock menu row(s) during final validation; insert order and snapshots in same transaction.
START TRANSACTION;
SELECT menu_item_id,current_price,availability_status
FROM menu_items
WHERE menu_item_id=@menu_item_id
FOR UPDATE;
-- Application checks AVAILABLE, recomputes totals using current server-side price,
-- inserts orders, restaurant_orders and order_items; never trusts client price.
COMMIT;

-- Useful operational indexes (many FK/search indexes are already declared above)
CREATE INDEX idx_orders_status_created ON tbl_orders(order_status,created_at);
CREATE INDEX idx_reviews_restaurant_rating ON tbl_reviews(restaurant_id,rating);
CREATE INDEX idx_menu_category ON tbl_menu_items(category_id,availability_status);


-- Remaining sample INSERT statements for Food_Delivery_Database_MySQL8.sql
-- MySQL 8.0.16+ | Run after all CREATE TABLE statements and after roles/permissions seed data.
-- This seed uses explicit IDs 1.. so the sample foreign keys are predictable.
-- Run against empty business tables. Do not run repeatedly without clearing the sample rows.
USE food_delivery_db;

START TRANSACTION;

-- 1. USERS (role and permission master data already inserted)
INSERT INTO tbl_users
(user_id, first_name, last_name, email, phone, user_password,
 account_status)
VALUES
(1,'System','Admin','admin@foodapp.test','9000000001','Guru@123','ACTIVE'),
(2,'Arun','Kumar','arun.owner@foodapp.test','9000000002','arun@123','ACTIVE'),
(3,'Priya','Sharma','priya.owner@foodapp.test','9000000003','priya@1234','ACTIVE'),
(4,'Rahul','Raj','rahul.customer@foodapp.test','9000000004','rahul@123','ACTIVE'),
(5,'Vijay','Kumar','vijay.delivery@foodapp.test','9000000005','vijay@123','ACTIVE'),
(6,'Meena','Devi','meena.manager@foodapp.test','9000000006','meena@123','ACTIVE'),
(7,'Karthik','S','karthik.staff@foodapp.test','9000000007','karthik@12345','ACTIVE');

-- 2. CUSTOMER AND DELIVERY-PARTNER PROFILES
INSERT INTO tbl_customers (customer_id,user_id,date_of_birth,loyalty_points)
VALUES (1,4,'1998-05-12',120);

INSERT INTO tbl_delivery_partners
(delivery_partner_id,user_id,vehicle_type,vehicle_number,license_number,availability_status,verification_status)
VALUES (1,5,'BIKE','TN09AB1234','DL-TN-123456789','AVAILABLE','VERIFIED');

-- 3. RESTAURANTS AND SHARED ADDRESS MASTER
INSERT INTO tbl_restaurants
(restaurant_id,owner_user_id,restaurant_name,description,email,contact_number,restaurant_status)
VALUES
(1,2,'Chennai Tiffin House','South Indian breakfast and meals','contact@chennaifin.test','04440000001','ACTIVE'),
(2,3,'Spice Garden','North Indian and biryani restaurant','hello@spicegarden.test','04440000002','ACTIVE');

INSERT INTO tbl_addresses
(address_id,address_line1,address_line2,landmark,city,state,country,postal_code,latitude,longitude)
VALUES
(1,'12 Anna Salai','Teynampet','Near Metro Station','Chennai','Tamil Nadu','India','600018',13.0418000,80.2341000),
(2,'45 OMR','Thoraipakkam','Near Bus Stop','Chennai','Tamil Nadu','India','600097',12.9365000,80.2376000),
(3,'7 Customer Street','Velachery','Near Railway Station','Chennai','Tamil Nadu','India','600042',12.9815000,80.2180000);

INSERT INTO tbl_customer_addresses
(customer_address_id,customer_id,address_id,address_type,is_default)
VALUES (1,1,3,'HOME',TRUE);

-- 4. BRANCHES AND RESTAURANT-SCOPED USER ROLES
INSERT INTO tbl_restaurant_branches
(branch_id,restaurant_id,address_id,branch_name,contact_number,branch_status)
VALUES
(1,1,1,'Teynampet Branch','04440000011','ACTIVE'),
(2,2,2,'OMR Branch','04440000022','ACTIVE');

-- Resolve role IDs by role_code; no assumption about auto-generated role IDs.
INSERT INTO tbl_user_roles (user_id,role_id,restaurant_id,branch_id,assigned_by,is_active)
SELECT 1,r.role_id,NULL,NULL,NULL,TRUE FROM tbl_roles r WHERE r.role_code='SUPER_ADMIN';

INSERT INTO tbl_user_roles (user_id,role_id,restaurant_id,branch_id,assigned_by,is_active)
SELECT 4,r.role_id,NULL,NULL,1,TRUE FROM tbl_roles r WHERE r.role_code='CUSTOMER';

INSERT INTO tbl_user_roles (user_id,role_id,restaurant_id,branch_id,assigned_by,is_active)
SELECT 2,r.role_id,1,NULL,1,TRUE FROM tbl_roles r WHERE r.role_code='RESTAURANT_OWNER';

INSERT INTO tbl_user_roles (user_id,role_id,restaurant_id,branch_id,assigned_by,is_active)
SELECT 3,r.role_id,2,NULL,1,TRUE FROM tbl_roles r WHERE r.role_code='RESTAURANT_OWNER';

INSERT INTO tbl_user_roles (user_id,role_id,restaurant_id,branch_id,assigned_by,is_active)
SELECT 6,r.role_id,1,1,2,TRUE FROM tbl_roles r WHERE r.role_code='RESTAURANT_MANAGER';

INSERT INTO tbl_user_roles (user_id,role_id,restaurant_id,branch_id,assigned_by,is_active)
SELECT 7,r.role_id,1,1,2,TRUE FROM tbl_roles r WHERE r.role_code='RESTAURANT_STAFF';

INSERT INTO tbl_user_roles (user_id,role_id,restaurant_id,branch_id,assigned_by,is_active)
SELECT 5,r.role_id,NULL,NULL,1,TRUE FROM tbl_roles r WHERE r.role_code='DELIVERY_PARTNER';

-- 5. RESTAURANT HOURS, FOOD CATEGORIES, MENUS AND MENU ITEMS
INSERT INTO tbl_restaurant_operating_hours
(operating_hour_id,branch_id,day_of_week,opening_time,closing_time,is_closed)
VALUES
(1,1,1,'07:00:00','22:00:00',FALSE),(2,1,2,'07:00:00','22:00:00',FALSE),
(3,1,3,'07:00:00','22:00:00',FALSE),(4,1,4,'07:00:00','22:00:00',FALSE),
(5,1,5,'07:00:00','22:00:00',FALSE),(6,1,6,'07:00:00','22:00:00',FALSE),
(7,1,7,'07:00:00','22:00:00',FALSE),
(8,2,1,'11:00:00','23:00:00',FALSE),(9,2,2,'11:00:00','23:00:00',FALSE),
(10,2,3,'11:00:00','23:00:00',FALSE),(11,2,4,'11:00:00','23:00:00',FALSE),
(12,2,5,'11:00:00','23:00:00',FALSE),(13,2,6,'11:00:00','23:00:00',FALSE),
(14,2,7,'11:00:00','23:00:00',FALSE);

INSERT INTO tbl_food_categories (category_id,category_name,description,parent_category_id,is_active)
VALUES
(1,'South Indian','South Indian dishes',NULL,TRUE),
(2,'Beverages','Hot and cold beverages',NULL,TRUE),
(3,'Biryani','Rice and biryani dishes',NULL,TRUE),
(4,'Breakfast','Breakfast dishes',1,TRUE);

INSERT INTO tbl_menus (menu_id,branch_id,menu_name,available_from,available_until,is_active)
VALUES
(1,1,'Breakfast','07:00:00','11:00:00',TRUE),
(2,1,'Lunch','11:00:00','15:30:00',TRUE),
(3,2,'All Day','11:00:00','23:00:00',TRUE);

INSERT INTO tbl_menu_items
(menu_item_id,menu_id,category_id,food_name,description,food_type,current_price,availability_status,preparation_time_minutes)
VALUES
(1,1,4,'Idli','Three steamed idlis with chutney','VEG',40.00,'AVAILABLE',10),
(2,1,1,'Masala Dosa','Crispy dosa with potato masala','VEG',90.00,'AVAILABLE',15),
(3,2,2,'Filter Coffee','Traditional South Indian filter coffee','VEG',30.00,'AVAILABLE',5),
(4,3,3,'Chicken Biryani','Aromatic chicken biryani','NON_VEG',220.00,'AVAILABLE',25),
(5,3,3,'Veg Biryani','Vegetable biryani','VEG',180.00,'AVAILABLE',20);

INSERT INTO tbl_food_item_prices
(price_id,menu_item_id,price,effective_from,effective_until,changed_by)
VALUES
(1,1,40.00,'2026-01-01 00:00:00',NULL,2),
(2,2,90.00,'2026-01-01 00:00:00',NULL,2),
(3,3,30.00,'2026-01-01 00:00:00',NULL,2),
(4,4,220.00,'2026-01-01 00:00:00',NULL,3),
(5,5,180.00,'2026-01-01 00:00:00',NULL,3);

-- 6. CART
INSERT INTO tbl_carts (cart_id,customer_id,cart_status)
VALUES (1,1,'CONVERTED');

INSERT INTO tbl_cart_items
(cart_item_id,cart_id,menu_item_id,quantity,displayed_unit_price)
VALUES
(1,1,1,2,40.00),
(2,1,4,1,220.00);

-- 7. ORDER: one master order containing items from TWO restaurants
INSERT INTO tbl_orders
(order_id,order_number,customer_id,order_date,subtotal,tax_amount,delivery_charge,discount_amount,grand_total,order_status,payment_status)
VALUES
(1,'FD-2026-000001',1,'2026-11-15 19:30:00',300.00,15.00,35.00,20.00,330.00,'DELIVERED','PARTIALLY_REFUNDED');

INSERT INTO tbl_order_delivery_addresses
(order_address_id,order_id,recipient_name,recipient_mobile,address_line1,address_line2,landmark,city,state,country,postal_code,latitude,longitude)
VALUES
(1,1,'Rahul Raj','9000000004','7 Customer Street','Velachery','Near Railway Station','Chennai','Tamil Nadu','India','600042',12.9815000,80.2180000);

INSERT INTO tbl_restaurant_orders
(restaurant_order_id,order_id,branch_id,restaurant_order_number,food_subtotal,tax_amount,total_amount,preparation_status)
VALUES
(1,1,1,'FD-2026-000001-01',80.00,4.00,84.00,'READY_FOR_PICKUP'),
(2,1,2,'FD-2026-000001-02',220.00,11.00,231.00,'READY_FOR_PICKUP');

INSERT INTO tbl_order_items
(order_item_id,restaurant_order_id,menu_item_id,food_name_snapshot,food_type_snapshot,quantity,unit_price,tax_amount,discount_amount,total_amount)
VALUES
(1,1,1,'Idli','VEG',2,40.00,4.00,0.00,84.00),
(2,2,4,'Chicken Biryani','NON_VEG',1,220.00,11.00,0.00,231.00);

INSERT INTO tbl_order_item_variants
(order_item_variant_id,order_item_id,variant_name_snapshot,additional_price_snapshot)
VALUES (1,2,'Regular',0.00);

INSERT INTO tbl_order_item_addons
(order_item_addon_id,order_item_id,addon_name_snapshot,addon_price_snapshot)
VALUES (1,2,'Extra Raita',15.00);

INSERT INTO tbl_order_status_history
(order_status_history_id,order_id,previous_status,current_status,updated_by,remarks,created_at)
VALUES
(1,1,NULL,'PLACED',4,'Customer placed the order','2026-11-15 19:30:00'),
(2,1,'PLACED','CONFIRMED',1,'Order confirmed','2026-11-15 19:32:00'),
(3,1,'CONFIRMED','PREPARING',6,'Restaurants started preparation','2026-11-15 19:35:00'),
(4,1,'PREPARING','OUT_FOR_DELIVERY',5,'Order picked up','2026-11-15 20:05:00'),
(5,1,'OUT_FOR_DELIVERY','DELIVERED',5,'Order delivered','2026-11-15 20:30:00');

INSERT INTO tbl_restaurant_order_status_history
(history_id,restaurant_order_id,previous_status,current_status,updated_by,remarks,created_at)
VALUES
(1,1,NULL,'PLACED',4,'Suborder created','2026-11-15 19:30:00'),
(2,1,'PLACED','ACCEPTED',6,'Accepted by branch','2026-11-15 19:32:00'),
(3,1,'ACCEPTED','PREPARING',7,'Kitchen started preparing','2026-11-15 19:35:00'),
(4,1,'PREPARING','READY_FOR_PICKUP',7,'Food is ready','2026-11-15 19:55:00'),
(5,2,NULL,'PLACED',4,'Suborder created','2026-11-15 19:30:00'),
(6,2,'PLACED','ACCEPTED',3,'Accepted by branch','2026-11-15 19:33:00'),
(7,2,'ACCEPTED','PREPARING',3,'Kitchen started preparing','2026-11-15 19:36:00'),
(8,2,'PREPARING','READY_FOR_PICKUP',3,'Food is ready','2026-11-15 20:00:00');

-- 8. MULTIPLE PAYMENT METHODS AND PAYMENT ATTEMPTS FOR THE SAME ORDER
INSERT INTO tbl_order_payments
(order_payment_id,order_id,payment_method,allocated_amount,payment_status)
VALUES
(1,1,'UPI',200.00,'SUCCESS'),
(2,1,'WALLET',130.00,'PARTIALLY_REFUNDED');

INSERT INTO tbl_payment_attempts
(payment_attempt_id,order_payment_id,attempt_number,gateway_name,gateway_transaction_id,idempotency_key,attempted_amount,attempt_status,failure_reason,attempted_at,completed_at)
VALUES
(1,1,1,'RAZORPAY','RAZORPAY-TXN-0001','IDEMP-ORDER1-UPI-1',200.00,'FAILED','Bank declined the first attempt','2026-11-15 19:31:00','2026-11-15 19:31:10'),
(2,1,2,'RAZORPAY','RAZORPAY-TXN-0002','IDEMP-ORDER1-UPI-2',200.00,'SUCCESS',NULL,'2026-11-15 19:32:00','2026-11-15 19:32:08'),
(3,2,1,'INTERNAL_WALLET','WALLET-TXN-0003','IDEMP-ORDER1-WALLET-1',130.00,'SUCCESS',NULL,'2026-11-15 19:32:15','2026-11-15 19:32:16');

-- 9. DELIVERY, ASSIGNMENT, STATUS HISTORY AND GPS TRACKING
INSERT INTO tbl_deliveries
(delivery_id,restaurant_order_id,delivery_status,pickup_time,estimated_delivery_time,delivered_at)
VALUES
(1,1,'DELIVERED','2026-11-15 20:05:00','2026-11-15 20:30:00','2026-11-15 20:30:00'),
(2,2,'DELIVERED','2026-11-15 20:05:00','2026-11-15 20:30:00','2026-11-15 20:30:00');

INSERT INTO tbl_delivery_assignments
(assignment_id,delivery_id,delivery_partner_id,assignment_status,assigned_at,accepted_at,completed_at)
VALUES
(1,1,1,'COMPLETED','2026-11-15 19:58:00','2026-11-15 20:00:00','2026-11-15 20:30:00'),
(2,2,1,'COMPLETED','2026-11-15 19:58:00','2026-11-15 20:00:00','2026-11-15 20:30:00');

INSERT INTO tbl_delivery_status_history
(delivery_status_history_id,delivery_id,assignment_id,previous_status,current_status,updated_by,remarks,updated_at)
VALUES
(1,1,1,NULL,'ASSIGNED',5,'Delivery partner assigned','2026-11-15 20:00:00'),
(2,1,1,'ASSIGNED','PICKED_UP',5,'Picked up from restaurant','2026-11-15 20:05:00'),
(3,1,1,'PICKED_UP','OUT_FOR_DELIVERY',5,'On the way to customer','2026-11-15 20:10:00'),
(4,1,1,'OUT_FOR_DELIVERY','DELIVERED',5,'Delivered to customer','2026-11-15 20:30:00'),
(5,2,2,NULL,'ASSIGNED',5,'Delivery partner assigned','2026-11-15 20:00:00'),
(6,2,2,'ASSIGNED','PICKED_UP',5,'Picked up from restaurant','2026-11-15 20:05:00'),
(7,2,2,'PICKED_UP','OUT_FOR_DELIVERY',5,'On the way to customer','2026-11-15 20:10:00'),
(8,2,2,'OUT_FOR_DELIVERY','DELIVERED',5,'Delivered to customer','2026-11-15 20:30:00');

INSERT INTO tbl_delivery_tracking
(tracking_id,delivery_id,delivery_partner_id,latitude,longitude,speed_kmh,recorded_at)
VALUES
(1,1,1,12.9900000,80.2200000,18.50,'2026-11-15 20:10:00'),
(2,1,1,12.9850000,80.2190000,15.00,'2026-11-15 20:20:00'),
(3,2,1,12.9900000,80.2200000,18.50,'2026-11-15 20:10:00'),
(4,2,1,12.9815000,80.2180000,0.00,'2026-11-15 20:30:00');

-- 10. REFUND EXAMPLE (separate payment can have its own refund)
INSERT INTO tbl_payment_refunds
(refund_id,order_payment_id,payment_attempt_id,refund_reference,refund_amount,refund_reason,refund_status,requested_at,completed_at)
VALUES
(1,2,3,'REF-2026-000001',10.00,'Goodwill partial refund','SUCCESS','2026-11-16 09:00:00','2026-11-16 09:05:00');

-- 11. COUPONS AND REDEMPTION
INSERT INTO tbl_coupons
(coupon_id,coupon_code,description,discount_type,discount_value,minimum_order_value,maximum_discount,total_usage_limit,per_customer_usage_limit,valid_from,valid_until,is_active)
VALUES
(1,'WELCOME20','Welcome discount for new customers','PERCENTAGE',20.00,199.00,50.00,1000,1,'2026-01-01 00:00:00','2026-12-31 23:59:59',TRUE),
(2,'FLAT30','Flat discount on eligible orders','FIXED',30.00,249.00,30.00,500,2,'2026-01-01 00:00:00','2026-12-31 23:59:59',TRUE);

INSERT INTO tbl_coupon_redemptions
(redemption_id,coupon_id,customer_id,order_id,discount_amount,redemption_status,redeemed_at)
VALUES (1,1,1,1,20.00,'REDEEMED','2026-11-15 19:30:00');

-- 12. RESTAURANT AND FOOD REVIEWS
INSERT INTO tbl_reviews
(review_id,customer_id,restaurant_id,restaurant_order_id,rating,comments,created_at)
VALUES
(1,1,1,1,5,'Fresh and tasty food','2026-11-15 21:00:00'),
(2,1,2,2,4,'Good biryani and timely delivery','2026-11-15 21:02:00');

INSERT INTO tbl_food_reviews
(food_review_id,customer_id,order_item_id,rating,comments,created_at)
VALUES
(1,1,1,5,'Idli was soft','2026-11-15 21:05:00'),
(2,1,2,4,'Biryani was flavourful','2026-11-15 21:06:00');

COMMIT;

-- Verify seeded data
SELECT 'users' AS table_nameUNT(*) AS row_count FROM tbl_users
UNION ALL SELECT 'customers', COUNT(*) FROM tbl_customers
UNION ALL SELECT 'restaurants', COUNT(*) FROM tbl_restaurants
UNION ALL SELECT 'restaurant_branches', COUNT(*) FROM tbl_restaurant_branches
UNION ALL SELECT 'menu_items', COUNT(*) FROM tbl_menu_items
UNION ALL SELECT 'orders', COUNT(*) FROM tbl_orders
UNION ALL SELECT 'restaurant_orders', COUNT(*) FROM tbl_restaurant_orders
UNION ALL SELECT 'order_payments', COUNT(*) FROM tbl_order_payments
UNION ALL SELECT 'payment_attempts', COUNT(*) FROM tbl_payment_attempts
UNION ALL SELECT 'deliveries', COUNT(*) FROM tbl_deliveries;




