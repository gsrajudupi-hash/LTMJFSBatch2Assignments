-- 1
SELECT * FROM Customer;
-- 2
SELECT * FROM Restaurant WHERE is_active = 1;
-- 3
SELECT * FROM Menu_Item WHERE is_veg = 1;
-- 4
SELECT * FROM Menu_Item WHERE restaurant_id = 1;   -- replace 1 with desired restaurant
-- 5
SELECT * FROM Menu_Item WHERE price > 200;
-- 6
SELECT * FROM Orders WHERE customer_id = 1;
-- 7
SELECT * FROM Orders WHERE DATE(order_datetime) = '2026-11-13';
-- 8
SELECT * FROM Delivery_Partner WHERE is_available = 1;


-- intermediate operationss


-- 9
SELECT c.name, c.email, ca.address_line, ca.city, ca.pincode
FROM Customer c
JOIN Customer_Address ca ON c.customer_id = ca.customer_id;
-- 10
SELECT r.name AS restaurant, mi.item_name, mi.price, mi.is_veg
FROM Restaurant r
JOIN Menu_Item mi ON r.restaurant_id = mi.restaurant_id;
-- 11
SELECT o.order_id, c.name AS customer, r.name AS restaurant,
      o.order_datetime, o.status, o.final_amount
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Restaurant r ON o.restaurant_id = r.restaurant_id;
-- 12
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM Customer c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
-- 13
SELECT r.name, COUNT(mi.item_id) AS total_items
FROM Restaurant r
LEFT JOIN Menu_Item mi ON r.restaurant_id = mi.restaurant_id
GROUP BY r.restaurant_id, r.name;
-- 14
SELECT r.name, SUM(o.final_amount) AS total_sales
FROM Restaurant r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'DELIVERED'
GROUP BY r.restaurant_id, r.name;
-- 15
SELECT mi.item_name, SUM(oi.quantity) AS times_ordered
FROM Order_Item oi
JOIN Menu_Item mi ON oi.item_id = mi.item_id
GROUP BY mi.item_id, mi.item_name
ORDER BY times_ordered DESC
LIMIT 1;
-- 16
SELECT c.*
FROM Customer c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
-- 17
SELECT dp.name, COUNT(d.delivery_id) AS completed
FROM Delivery_Partner dp
JOIN Delivery d ON dp.partner_id = d.partner_id
WHERE d.status = 'DELIVERED'
GROUP BY dp.partner_id, dp.name
HAVING completed > 5;
-- 18
SELECT r.name, AVG(rv.rating) AS avg_rating
FROM Restaurant r
JOIN Review rv ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.name;


-- advanced level

-- 19
SELECT c.name, SUM(o.final_amount) AS total_spent
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.status = 'DELIVERED'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 1;
-- 20
SELECT r.name, SUM(o.final_amount) AS revenue
FROM Restaurant r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'DELIVERED'
GROUP BY r.restaurant_id, r.name
ORDER BY revenue DESC
LIMIT 1;
-- 21
SELECT item_name, price
FROM Menu_Item
ORDER BY price DESC
LIMIT 1 OFFSET 1;
-- 22
SELECT r.name, AVG(rv.rating) AS restaurant_avg
FROM Restaurant r
JOIN Review rv ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.name
HAVING restaurant_avg > (SELECT AVG(rating) FROM Review);
-- 23
SELECT c.name, COUNT(o.order_id) AS order_count
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING order_count > (
   SELECT AVG(cnt) FROM (
       SELECT COUNT(*) AS cnt FROM Orders GROUP BY customer_id
   ) t
);
-- 24
SELECT mi.*
FROM Menu_Item mi
LEFT JOIN Order_Item oi ON mi.item_id = oi.item_id
WHERE oi.order_item_id IS NULL;
-- 25
SELECT mi.item_name, SUM(oi.quantity) AS total_sold
FROM Order_Item oi
JOIN Menu_Item mi ON oi.item_id = mi.item_id
GROUP BY mi.item_id, mi.item_name
ORDER BY total_sold DESC
LIMIT 3;
-- 26
SELECT DISTINCT c.name, c.email
FROM Customer c
JOIN Coupon_Redemption cr ON c.customer_id = cr.customer_id;
-- 27
SELECT r.*
FROM Restaurant r
LEFT JOIN Orders o ON r.restaurant_id = o.restaurant_id
WHERE o.order_id IS NULL;
-- 28
SELECT r.name,
      DATE_FORMAT(o.order_datetime, '%Y-%m') AS month,
      SUM(o.final_amount) AS monthly_revenue
FROM Restaurant r
JOIN Orders o ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'DELIVERED'
GROUP BY r.restaurant_id, r.name, month
ORDER BY r.name, month;
-- 29
SELECT dp.name, COUNT(*) AS completed_deliveries
FROM Delivery_Partner dp
JOIN Delivery d ON dp.partner_id = d.partner_id
WHERE d.status = 'DELIVERED'
GROUP BY dp.partner_id, dp.name
ORDER BY completed_deliveries DESC
LIMIT 1;
-- 30
SELECT DISTINCT c.name, c.email
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Review rv ON c.customer_id = rv.customer_id
WHERE rv.review_id IS NULL;

