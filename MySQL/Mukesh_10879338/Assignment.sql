CREATE DATABASE food_delivery_db;

USE food_delivery_db;

SHOW DATABASES;

SELECT DATABASE();

SHOW TABLES;

	CREATE TABLE CUSTOMER (customer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
	                     name VARCHAR(100) NOT NULL,
								email VARCHAR(150) NOT NULL UNIQUE,
								mobile VARCHAR(15) NOT NULL UNIQUE,
								password VARCHAR(255) NOT NULL, 
								created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
								updated_at DATETIME);
								
								
	CREATE TABLE RESTAURANT(restaurant_id BIGINT AUTO_INCREMENT PRIMARY KEY,
	                        restaurant_name VARCHAR(150) NOT NULL,
									address VARCHAR(255) NOT NULL,
									city VARCHAR(100) NOT NULL,
									state VARCHAR(100) NOT NULL,
									pincode VARCHAR(10) NOT NULL,
									phone VARCHAR(15) NOT NULL,
									email VARCHAR(150) NOT NULL,
									is_active BOOLEAN DEFAULT TRUE,
									created_at DATETIME DEFAULT CURRENT_TIMESTAMP);
									
							
	CREATE TABLE FOOD_CATEGORY(category_id BIGINT AUTO_INCREMENT PRIMARY KEY,
	                           category_name VARCHAR(100) NOT NULL UNIQUE,
										DESCRIPTION VARCHAR(255));									
										
										
	CREATE TABLE CUSTOMER_ADDRESS(address_id BIGINT AUTO_INCREMENT PRIMARY KEY,
											customer_id BIGINT NOT NULL,
											address_line VARCHAR(255) NOT NULL,
											city VARCHAR(100) NOT NULL,
											state VARCHAR(100) NOT NULL,
											pincode VARCHAR(10) NOT NULL,
											address_type VARCHAR(20),
											is_default BOOLEAN DEFAULT FALSE,
											CONSTRAINT fk_address_customer FOREIGN KEY (customer_id) 
											REFERENCES CUSTOMER(customer_id));
														
		
		CREATE TABLE RESTAURANT_OPERATING_HOURS(operating_hours_id BIGINT AUTO_INCREMENT PRIMARY KEY,
										                restaurant_id BIGINT NOT NULL,
															 day_of_week VARCHAR(100) NOT NULL,
															 open_time TIME,
															 close_time TIME,
															 is_closed BOOLEAN DEFAULT FALSE,
															 FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id));	
															 														 							
											
		CREATE TABLE MENU_ITEM(item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
									  restaurant_id BIGINT NOT NULL,
									  category_id BIGINT NOT NULL,
									  item_name VARCHAR(150) NOT NULL,
									  DESCRIPTION TEXT,
									  price DECIMAL(10,2) NOT NULL CHECK(price >= 0),
									  is_veg BOOLEAN NOT NULL,
									  is_available BOOLEAN DEFAULT TRUE,
									  FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id),
									   FOREIGN KEY(category_id) REFERENCES FOOD_CATEGORY(category_id));
																	
										
		CREATE TABLE CART(cart_id BIGINT AUTO_INCREMENT PRIMARY KEY,
		 							customer_id BIGINT NOT NULL UNIQUE,
									 created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
									 updated_at DATETIME,
									 FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id));	
									 
									 
	   CREATE TABLE CART_ITEM(cart_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,	
	   							  cart_id BIGINT NOT NULL,
									  item_id BIGINT NOT NULL,
									  quantity INT NOT NULL CHECK(quantity > 0),
									  added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
									  UNIQUE (cart_id, item_id), 
									  FOREIGN KEY(cart_id) REFERENCES CART(cart_id),
									  FOREIGN KEY(item_id) REFERENCES MENU_ITEM(item_id));
									  
									  
		CREATE TABLE ORDERS(order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
								  customer_id BIGINT NOT NULL,
								  address_id BIGINT NOT NULL,
								  order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
								  subtotal DECIMAL(10,2) NOT NULL, 
								  delivery_charge DECIMAL(10,2) DEFAULT 0,
								  discount DECIMAL(10,2) DEFAULT 0,
								  total_amount DECIMAL(10,2) NOT NULL,
								  order_status VARCHAR(30) NOT NULL,
								  FOREIGN KEY(customer_id) REFERENCES CUSTOMER(customer_id), 
								  FOREIGN KEY(address_id) REFERENCES CUSTOMER_ADDRESS(address_id));
								  			  
	
	CREATE TABLE RESTAURANT_ORDER(restaurant_order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
	                              order_id BIGINT NOT NULL,
											restaurant_id BIGINT NOT NULL,
											subtotal DECIMAL(10,2) NOT NULL,
											delivery_charge DECIMAL(10,2) DEFAULT 0,
											discount DECIMAL(10,2) DEFAULT 0,
											total_amount DECIMAL(10,2) NOT NULL,
											order_status VARCHAR(30) NOT NULL,
											created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
											UNIQUE (order_id, restaurant_id), 
											FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
											FOREIGN KEY(restaurant_id) REFERENCES RESTAURANT(restaurant_id));
																					
											
	CREATE TABLE ORDER_ITEM(order_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
									restaurant_order_id BIGINT NOT NULL,
									item_id BIGINT NOT NULL,
									quantity INT NOT NULL CHECK(quantity > 0),
									item_price DECIMAL(10,2) NOT NULL,
									FOREIGN KEY (restaurant_order_id) REFERENCES restaurant_order(restaurant_order_id),
									FOREIGN KEY(item_id) REFERENCES MENU_ITEM(item_id));
															
				
	CREATE TABLE PAYMENT(payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
								order_id BIGINT NOT NULL,
								payment_method VARCHAR(30) NOT NULL,
								amount DECIMAL(10,2) NOT NULL CHECK(amount > 0),
								transaction_ref VARCHAR(100) UNIQUE,
								payment_date DATETIME,
								payment_status VARCHAR(20) NOT NULL,
								FOREIGN KEY (order_id) REFERENCES ORDERS(order_id));
								
									
	CREATE TABLE DELIVERY_PARTNER(partner_id BIGINT AUTO_INCREMENT PRIMARY KEY,
											NAME VARCHAR(100) NOT NULL,
											mobile VARCHAR(15) NOT NULL,
											vehicle_number VARCHAR(30) UNIQUE,
											vehicle_type VARCHAR(30), 
											availability_status VARCHAR(20) DEFAULT 'AVAILABLE');
	
	
	CREATE TABLE DELIVERY(delivery_id BIGINT AUTO_INCREMENT PRIMARY KEY,
								 restaurant_order_id BIGINT NOT NULL,
								 partner_id BIGINT NOT NULL,
								 pickup_time DATETIME,
								 delivered_time DATETIME,
								 estimated_delivery_time DATETIME,
								 delivery_status VARCHAR(30) NOT NULL,
								 FOREIGN KEY(restaurant_order_id) REFERENCES RESTAURANT_ORDER(restaurant_order_id),
								 FOREIGN KEY(partner_id) REFERENCES DELIVERY_PARTNER(partner_id));
								 
								 						 
				
	CREATE TABLE ORDER_STATUS_HISTORY(history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
												 order_id BIGINT NOT NULL,
												 STATUS VARCHAR(30) NOT NULL,
												 updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
												 remarks VARCHAR(255),
												 FOREIGN KEY(order_id) REFERENCES ORDERS(order_id));
												 												 											
	
	CREATE TABLE REVIEW(review_id BIGINT AUTO_INCREMENT PRIMARY KEY,
							  customer_id BIGINT NOT NULL,
							  restaurant_id BIGINT NOT  NULL,
							  item_id BIGINT, 
							  order_id BIGINT NOT NULL,
							  rating INT NOT NULL CHECK(rating BETWEEN 1 AND 5),
							  COMMENT TEXT,
							  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
							  FOREIGN KEY(customer_id) REFERENCES CUSTOMER(customer_id),
							  FOREIGN KEY(restaurant_id) REFERENCES RESTAURANT(restaurant_id),
							  FOREIGN KEY(item_id) REFERENCES menu_item(item_id),
							  FOREIGN KEY(order_id) REFERENCES ORDERS(order_id));
															   
	
	CREATE TABLE COUPON(coupon_id BIGINT AUTO_INCREMENT PRIMARY KEY,
							  coupon_code VARCHAR(50) NOT NULL UNIQUE,
							  discount_type VARCHAR(20) NOT NULL,
							  discount_value DECIMAL(10,2) DEFAULT 0,
							  min_order_value DECIMAL(10,2),
							  start_date DATE NOT NULL,
							  expiry_date DATE NOT NULL,
							  usage_limit INT);
							  										  
	
	CREATE TABLE COUPON_REDEMPTION(redemption_id BIGINT AUTO_INCREMENT PRIMARY KEY,
											 coupon_id BIGINT NOT NULL,
											 customer_id BIGINT NOT NULL,
											 order_id BIGINT NOT NULL,
											 redeemed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
											 discount_amount DECIMAL(10,2) NOT NULL,
											 FOREIGN KEY(coupon_id) REFERENCES COUPON(coupon_id),
											 FOREIGN KEY(customer_id) REFERENCES CUSTOMER(customer_id),
											 FOREIGN KEY(order_id) REFERENCES ORDERS(order_id));
																																	 
											 
	CREATE TABLE REFUND(refund_id BIGINT AUTO_INCREMENT PRIMARY KEY,
							  payment_id BIGINT NOT NULL,
							  amount DECIMAL(10,2) NOT NULL,
							  reason VARCHAR(255) NOT NULL,
							  refund_status VARCHAR(20) NOT NULL,
							  refund_date DATETIME,
							  FOREIGN KEY(payment_id) REFERENCES PAYMENT(payment_id));
							  
							  
	
	
							  
							  						  
							  
	SELECT * FROM customer;
	
	INSERT INTO CUSTOMER(customer_id, NAME, email, mobile, password)
	VALUES(1, 'ARUN', 'arun@gmail.com','1234567890','demo_hash_1'),
			(2, 'kumar', 'kumar@gmail.com','2345678901','demo_hash_2'),
			(3, 'Priya', 'priya@gmail.com','3456789012','demo_hash_3');
						
	SELECT * FROM RESTAURANT;
			
	INSERT INTO RESTAURANT(restaurant_id, restaurant_name, address, city, state, pincode,phone, email)
	VALUES(1, 'A2B', 'Anna Nagar','Chennai','TN','600040','900000001','a22b@gmail.com'),
			(2, 'Pizza Corner', 'T Nagar', 'Chennai','TN','600040','988100328','kumar@gmail.com'),
			(3, 'Burger King', 'Tambaram','Chennai','TN','600060','3456789012','priya@gmail.com');
			
	SELECT * FROM FOOD_CATEGORY;
	
	INSERT INTO FOOD_CATEGORY(category_id, category_name, DESCRIPTION)							
	VALUES(1, 'South Indian', 'Traditional South Indian food'),
			(2, 'Pizza', 'Different varieties of pizza'),
			(3, 'Burger', 'Different varieties of burger'),
			(4, 'Beverages', 'Juices and other drinks');	
			
	SELECT * FROM CUSTOMER_ADDRESS;
			
	INSERT INTO CUSTOMER_ADDRESS(address_id, customer_id, address_line, city, state, pincode,address_type, is_default)
	VALUES(1, 1, 'Anna Nagar','Chennai','TN','600040','HOME', TRUE),
			(2, 2, 'T Nagar', 'Chennai','TN','600040','HOME',TRUE),
			(3, 3, 'Tambaram','Chennai','TN','600060','WORK', TRUE);
			
	SELECT * FROM RESTAURANT_OPERATING_HOURS;
			
  	INSERT INTO RESTAURANT_OPERATING_HOURS(operating_hours_id, restaurant_id, day_of_week, open_time,close_time,is_closed)
	VALUES(1, 1, 'MONDAY','09:00:00', '22:00:00', FALSE),
			(2, 2, 'MONDAY', '10:00:00', '23:00:00',FALSE),
			(3, 3, 'MONDAY','11:00:00', '23:00:00', FALSE);
			
	SELECT * FROM MENU_ITEM;
		
	INSERT INTO MENU_ITEM(item_id, restaurant_id, category_id, item_name, DESCRIPTION, price,is_veg, is_available)
	VALUES(1, 1, 1,  'Dosa','South Indian dosa', 80.00, TRUE, TRUE),
			(2, 1, 1,  'Idli', 'Steamed rice cakes',40.00,TRUE,TRUE),
			(3, 2, 2, 'Pizza', 'Classic Cheese Pizza', 250.00, TRUE, TRUE),
			(4,2,2, 'Burger', 'Vegetarain burger', 350.00, FALSE, TRUE),
			(5, 3, 3, 'Chicken burger', 'Chicken burger', 180.00, FALSE, TRUE);	
			
	select * FROM CART;
	
	INSERT INTO CART(cart_id, customer_id)
   VALUES(1,1),
	      (2,2),
	      (3,3);	
			
			
	SELECT * FROM CART_ITEM;
			
	INSERT INTO CART_ITEM(cart_item_id, cart_id, item_id,quantity)
   VALUES(1,1,1,2),
	      (2,1,3,1),
	      (3,2,5,2),
			(4,3,2,1);	
	
		
	SELECT * FROM ORDERS;
	
	INSERT INTO ORDERS(order_id, customer_id, address_id, subtotal,delivery_charge,discount,total_amount,order_status)
	VALUES(1,1, 1,410.00,40.00,10.00,450.00,'PLACED'),
			(2,2,2,240.00,30.00,20.00,250.00,'CONFIRMED'),
			(3,3,3,180.00,30.00,10.00,210.00,'DELIVERED');
	
	
	SELECT * FROM RESTAURANT_ORDER;
		
	INSERT INTO RESTAURANT_ORDER(restaurant_order_id, order_id, restaurant_id, subtotal,delivery_charge,discount,
	total_amount,order_status)
	VALUES(1,1, 1,160.00,20.00,0.00,180.00,'PLACED'),
			(2,1,2,250.00,20.00,0.00,270.00,'PLACED'),
			(3,2,3,240.00,30.00,20.00,250.00,'CONFIRMED'),
			(4,3,3,180.00,30.00,0.00,210.00,'DELIVERED');	
			
	SELECT * FROM ORDER_ITEM;
			
	INSERT INTO ORDER_ITEM(order_item_id, restaurant_order_id, item_id, quantity, item_price)
	VALUES(1,1, 1, 2, 80.00),
			(2,2,3,1,250.00),
			(3,3,5,2,120.00),
			(4,4,5,1,180.00);		
	
	SELECT * FROM PAYMENT;
			
	INSERT INTO PAYMENT(payment_id, order_id, payment_method, amount,transaction_ref,payment_date,payment_status)
	VALUES(1,1,'UPI',450.00,'TXN1001',NOW(),'SUCCESS'),
			(2,1,'CARD',250.00,'TXN1002',NOW(),'SUCCESS'),
			(3,2,'CASH', 210.00, 'TXN1003', NOW(),'SUCCESS');
			
	SELECT * FROM DELIVERY_PARTNER;	
			
	INSERT INTO DELIVERY_PARTNER(partner_id, NAME, mobile, vehicle_number,vehicle_type,availability_status)
	VALUES(1,'Ramesh', '91111111', 'TN01AB1234','BIKE','AVAILABLE'),
			(2,'Suresh', '91111112', 'TN01AB1235','BIKE','AVAILABLE'),
			(3, 'Manoj', '91111113', 'TN01AB1236', 'SCOOTER', 'AVAILABLE');
			
	SELECT * FROM DELIVERY;
			
	INSERT INTO DELIVERY(delivery_id, restaurant_order_id, partner_id, pickup_time,delivered_time,
	estimated_delivery_time,delivery_status)
	VALUES(1,1,1,NOW(), NULL, DATE_ADD(NOW(), INTERVAL 30 MINUTE), 'PICKED_UP'),
		(2,2,2,NOW(), NULL, DATE_ADD(NOW(), INTERVAL 40 MINUTE), 'PICKED_UP'),
		(3,3,3,NOW(), NULL, DATE_ADD(NOW(), INTERVAL 25 MINUTE), 'ASSIGNED'),
		(4,4,1,NOW(), NULL, DATE_ADD(NOW(), INTERVAL 25 MINUTE), 'DELIVERED');	
	
	SELECT * FROM ORDER_STATUS_HISTORY;
	
	INSERT INTO ORDER_STATUS_HISTORY(history_id, order_id, STATUS,remarks)
	VALUES(1,1, 'PLACED', 'Order placed successfully'),
		(2,1, 'CONFIRMED', 'Restaurant confirmed the order'),
		(3,2, 'CONFIRMED', 'Order confirmed'),
		(4,3, 'DELIVERED', 'Order delivered successfully');
	
			
	SELECT * FROM REVIEW;
	
	INSERT INTO REVIEW(review_id, customer_id, restaurant_id,item_id,order_id,rating,COMMENT)
	VALUES(1,3,3,5,3,5,'Excellent food and service'),
		(2,1,1,1,1,4,'Good quality food'),
	(3,2,3,5,2,4,'Nice burger');
	
		
	SELECT * FROM COUPON;
		
	INSERT INTO COUPON(coupon_id, coupon_code, discount_type, discount_value,min_order_value,start_date,expiry_date,usage_limit)
	VALUES(1,'WELCOME20','PERCENTAGE', 20.00,100.00,CURDATE(), DATE_ADD(CURDATE(),INTERVAL 30 DAY), 100),
		(2,'FLAT50','FIXED', 50.00,200.00,CURDATE(), DATE_ADD(CURDATE(),INTERVAL 30 DAY), 50);	
		
	SELECT * FROM COUPON_REDEMPTION;
		
	INSERT INTO COUPON_REDEMPTION(redemption_id, coupon_id, customer_id,order_id,discount_amount)
	VALUES(1,1,2,2,20.00);
	
	
	SELECT * FROM REFUND;
	
	INSERT INTO REFUND(refund_id, payment_id, amount,reason,refund_status,refund_date)
	VALUES(1,1,50.00,'Parcel refund for cancelled item', 'PROCESSED', NOW());
	
	
--Basic 
	
	SELECT * FROM customer;
	
	SELECT * FROM restaurant WHERE is_active = TRUE;
	
	SELECT * FROM menu_item WHERE is_veg = TRUE;
	
	SELECT * FROM menu_item WHERE restaurant_id = 1;
	
	SELECT * FROM menu_item WHERE price > 200;
		
	SELECT * FROM orders WHERE customer_id = 1;
	
	SELECT * FROM orders WHERE DATE(order_date) = '2026-11-15';	
	
	SELECT * FROM delivery_partner WHERE availability_status = 'AVAILABLE';
	
--Intermediate
 
  SELECT c.customer_id, c.name, c.email, a.address_line, a.city, a.state, a.pincode
  FROM customer c 
  JOIN customer_address a 
  ON c.customer_id  = a.customer_id;
  
  SELECT r.restaurant_name, m.item_name, m.price 
  FROM restaurant r
  JOIN menu_item m
  ON r.restaurant_id = m.restaurant_id;
  
  SELECT o.order_id, c.name AS customer_name, r.restaurant_name, ro.subtotal, ro.total_amount, ro.order_status
  FROM orders o 
  JOIN customer c
  ON o.customer_id = c.customer_id
  JOIN restaurant_order ro 
  ON o.order_id = ro.order_id
  JOIN restaurant r
  ON ro.restaurant_id = r.restaurant_id;
  
  SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
  FROM customer c 
  LEFT JOIN orders o
  ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, c.name;
  
  SELECT r.restaurant_id, r.restaurant_name, COUNT(m.item_id) AS available_items
  FROM restaurant r
  LEFT JOIN menu_item m
  ON r.restaurant_id = m.restaurant_id
  AND m.is_available = TRUE
  GROUP BY r.restaurant_id, r.restaurant_name;
  
  SELECT r.restaurant_id, r.restaurant_name,SUM(ro.subtotal - ro.discount) AS total_sales
  FROM restaurant r
  JOIN restaurant_order ro
  ON r.restaurant_id = ro.restaurant_id
  GROUP BY r.restaurant_id, r.restaurant_name;
  
  SELECT m.item_id, m.item_name, SUM(oi.quantity) AS total_quantity_ordered 
  FROM menu_item m 
  JOIN order_item oi
  ON m.item_id = oi.item_id 
  GROUP BY m.item_id, m.item_name 
  ORDER BY total_quantity_ordered DESC 
  LIMIT 1;
  
  SELECT c.customer_id, c.name 
  FROM customer c
  LEFT JOIN orders o
  ON c.customer_id = o.customer_id
  WHERE o.order_id IS NULL;
  
  SELECT dp.partner_id, dp.name, COUNT(d.delivery_id) AS completed_deliverires 
  FROM delivery_partner dp 
  JOIN delivery d
  ON dp.partner_id = d.partner_id
  WHERE d.delivery_status = 'DELIVERED'
  GROUP BY dp.partner_id, dp.name
  HAVING COUNT(d.delivery_id) > 2;
  
  SELECT r.restaurant_id, r.restaurant_name, AVG(rv.rating) AS average_rating
  FROM restaurant r
  LEFT JOIN review rv
  ON r.restaurant_id = rv.restaurant_id
  GROUP BY r.restaurant_id, r.restaurant_name;
  
--Advanced 

SELECT c.customer_id,c.name SUM(o.total_amount) AS total_spent
FROM customer c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name 
ORDER BY total_spent DESC
LIMIT 1;

SELECT r.restaurant_id, r.restaurant_name, SUM(ro.subtoal - ro.discount)AS total_revenue
FROM restaurant r 
JOIN restaurant_order ro 
ON r.restaurant_id = ro.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 1;

SELECT * 
FROM menu_item
WHERE price = (SELECT MAX(price) FROM menu_item WHERE price < (SELECT MAX(price) FROM menu_item));

SELECT r.restaurant_id , r.restaurant_name, AVG(rv.rating) AS average_rating 
FROM restaurant r JOIN review rv 
ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
HAVING AVG(rv.rating) > (SELECT AVG(rating) FROM review);

SELECT c.customer_id, c.name, COUNT(o.order_id)AS total_orders 
FROM customer c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > (SELECT AVG(order_count) FROM (SELECT COUNT(o2.order_id) AS order_count FROM customer c2
LEFT JOIN orders o2 ON c2.customer_id = o2.customer_id GROUP BY c2.customer_id) AS customer_orders);

SELECT m.item_id, m.item_name
FROM menu_item m
LEFT JOIN order_item oi
ON m.item_id = oi.item_id 
WHERE oi.order_item_id IS NULL;

SELECT m.item_id, m.item_name, SUM(oi.quantity) AS total_quantity_sold 
FROM menu_item m
JOIN order_item oi
ON m.item_id = oi.item_id
GROUP BY m.item_id, m.item_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

SELECT DISTINCT c.customer_id, c.name, cp.coupon_code
FROM cusotmer c
JOIN coupon_redemption cr
ON c.cusotmer_id = cr.customer_id 
JOIN coupon cp
ON cr.coupon_id = cp.coupon_id;

SELECT r.restaurant_ID, r.restaurant_name
FROM restaurant r
LEFT JOIN restaurant_order ro
ON r.restaurant_id = ro.restaurant_id
WHERE ro.restaurant_order_id IS NULL;

SELECT r.restaurant_name, DATE_FORMAT(ro.created_at, '%Y-%m') AS revenue_month, SUM(ro.subtotal - ro.discount) AS monthly_revenue
FROM restaurant r
JOIN restaurant_order ro
ON r.restaurant_id = ro.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name, DATE_FORMAT(ro.created_at, '%Y-%m')
ORDER BY revenue_month, r.restaurant_name;

SELECT dp.partner_id, dp.name, COUNT(d.delivery_id) AS completed_deliveries 
FROM delivery_partner dp 
JOIN delivery d
ON dp.partner_id = d.partner_id
WHERE d.delivery_status = 'DELIVERED'
GROUP BY dp.partner_id , dp.name
HAVING COUNT(d.delivery_id) = (SELECT MAX(delivery_count) FROM (SELECT COUNT(*) AS delivery_count
FROM delivery WHERE delivery_status = 'DELIVERED' GROUP BY partner_id) AS delivery_counts);


SELECT c.customer_id, c.name
FROM customer c
JOIN orders o
ON c.customer_id = o.customer_id
LEFT JOIN review rv
ON c.customer_id = rv.customer_id 
WHERE rv.review_id IS NULL
GROUP BY c.customer_id, c.name;

