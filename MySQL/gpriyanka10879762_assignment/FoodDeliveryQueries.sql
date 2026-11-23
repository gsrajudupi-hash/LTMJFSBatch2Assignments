-- =====================================================================
-- OFDMS  03_queries.sql : solutions to all 30 business problems
-- Level: beginner / intermediate
-- Run after 01_schema.sql and 02_sample_data.sql
-- "a particular customer / restaurant / date" are examples; change the
-- number or date to try others.
-- =====================================================================
USE foodDeliveryDB;

-- =========================== BASIC LEVEL =============================

-- 1. Show all registered customers.
SELECT customer_id, full_name, email, mobile, is_active
FROM customer;

-- 2. Show all active restaurants.
SELECT restaurant_id, name, city, contact_number
FROM restaurant
WHERE is_active = 1;

-- 3. Show all vegetarian food items.
SELECT item_id, name, price, restaurant_id
FROM menu_item
WHERE is_veg = 1;

-- 4. Show the food items of one restaurant (example: restaurant 1).
SELECT item_id, name, price, is_veg, is_available
FROM menu_item
WHERE restaurant_id = 1;

-- 5. Show food items that cost more than 200.
SELECT item_id, name, price, restaurant_id
FROM menu_item
WHERE price > 200
ORDER BY price DESC;

-- 6. Show all orders of one customer (example: customer 5).
SELECT order_id, order_datetime, status, total_amount
FROM orders
WHERE customer_id = 5
ORDER BY order_datetime;

-- 7. Show all orders placed on one date (example: 2026-10-02).
SELECT order_id, customer_id, restaurant_id, status, total_amount
FROM orders
WHERE order_datetime >= '2026-10-02 00:00:00'
  AND order_datetime <  '2026-10-03 00:00:00';

-- 8. Show all available delivery partners.
SELECT partner_id, full_name, mobile, vehicle_type
FROM delivery_partner
WHERE is_available = 1;

-- ======================== INTERMEDIATE LEVEL =========================

-- 9. Show each customer with their address.
--    LEFT JOIN so customers who have no address still appear.
SELECT c.customer_id, c.full_name, c.mobile,
       a.label, a.line1, a.city, a.pincode
FROM customer c
LEFT JOIN customer_address a ON a.customer_id = c.customer_id
ORDER BY c.customer_id;

-- 10. Show each restaurant with the items on its menu.
SELECT r.name AS restaurant, mi.name AS item, mi.price, mi.is_veg
FROM restaurant r
JOIN menu_item mi ON mi.restaurant_id = r.restaurant_id
ORDER BY r.name, mi.name;

-- 11. Show full order details with customer and restaurant names.
SELECT o.order_id,
       o.order_datetime,
       o.status,
       c.full_name AS customer,
       r.name AS restaurant,
       o.subtotal,
       o.delivery_charge,
       o.discount_amount,
       o.total_amount
FROM orders o
JOIN customer c
     ON c.customer_id = o.customer_id
JOIN restaurant r
     ON r.restaurant_id = o.restaurant_id
ORDER BY o.order_id;

-- 12. Count how many orders each customer has placed.
--     LEFT JOIN so customers with zero orders are also shown.
SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS total_orders
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_orders DESC;

-- 13. Count how many available items each restaurant has.
SELECT r.restaurant_id, r.name, COUNT(mi.item_id) AS available_items
FROM restaurant r
LEFT JOIN menu_item mi
       ON mi.restaurant_id = r.restaurant_id AND mi.is_available = 1
GROUP BY r.restaurant_id, r.name
ORDER BY available_items DESC;

-- 14. Total sales of each restaurant (only delivered orders count).
-- Only DELIVERED orders are considered completed sales.
-- COALESCE returns 0 for restaurants without delivered orders.
SELECT r.restaurant_id,
       r.name,
       COALESCE(SUM(o.total_amount), 0) AS total_sales
FROM restaurant r
LEFT JOIN orders o
       ON o.restaurant_id = r.restaurant_id
      AND o.status = 'DELIVERED'
GROUP BY r.restaurant_id,
         r.name
ORDER BY total_sales DESC;

-- 15. Find the most ordered food item (highest total quantity).
-- Total quantity ordered is used to determine frequency.
-- Group by item_id so items with the same name from different
-- restaurants are not combined.
SELECT oi.item_id,
       oi.item_name,
       SUM(oi.quantity) AS total_qty
FROM order_item oi
GROUP BY oi.item_id,
         oi.item_name
ORDER BY total_qty DESC
LIMIT 1;

-- 16. Find customers who never placed an order.
--     LEFT JOIN orders; if there is no matching order, order_id is NULL.
SELECT c.customer_id, c.full_name, c.email
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 17. Find delivery partners who completed more than 5 deliveries.
SELECT dp.partner_id, dp.full_name, COUNT(d.delivery_id) AS completed_deliveries
FROM delivery_partner dp
JOIN delivery d
      ON d.partner_id = dp.partner_id AND d.assignment_status = 'DELIVERED'
GROUP BY dp.partner_id, dp.full_name
HAVING COUNT(d.delivery_id) > 5;

-- 18. Average rating of each restaurant.
-- LEFT JOIN also displays restaurants with no reviews.
-- ROUND displays the average rating to two decimal places.
SELECT r.restaurant_id, r.name,
       ROUND(AVG(rr.rating), 2) AS avg_rating,
       COUNT(rr.review_id)      AS review_count
FROM restaurant r
LEFT JOIN restaurant_review rr ON rr.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.name
ORDER BY avg_rating DESC;

-- ========================== ADVANCED LEVEL ===========================
-- (still using simple joins, GROUP BY, and small subqueries)

-- 19. Find the customer who spent the most (on delivered orders).
--     Sort by total spent, keep the top row.
SELECT c.customer_id, c.full_name, SUM(o.total_amount) AS total_spent
FROM customer c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'DELIVERED'
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC
LIMIT 1;

-- 20. Find the restaurant that earned the most revenue.
SELECT r.restaurant_id, r.name, SUM(o.total_amount) AS revenue
FROM restaurant r
JOIN orders o ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'DELIVERED'
GROUP BY r.restaurant_id, r.name
ORDER BY revenue DESC
LIMIT 1;

-- 21. Find the second most expensive food item.
-- This finds the second DISTINCT highest price.
-- If multiple items have that price, all of them are returned.
SELECT item_id,
       name,
       price
FROM menu_item
WHERE price = (
    SELECT MAX(price)
    FROM menu_item
    WHERE price < (
        SELECT MAX(price)
        FROM menu_item
    )
);

-- 22. Find restaurants whose average rating is above the overall average.
--     The subquery is one number: the average of all ratings.
SELECT r.restaurant_id, r.name, ROUND(AVG(rr.rating), 2) AS avg_rating
FROM restaurant r
JOIN restaurant_review rr ON rr.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.name
HAVING AVG(rr.rating) > (SELECT AVG(rating) FROM restaurant_review);

-- 23. Find customers who placed more orders than the average customer.
-- the average number of orders per registered customer.
--
-- This version includes registered customers with zero orders
-- when calculating the average.
-- ---------------------------------------------------------------------
SELECT c.customer_id,
       c.full_name,
       COUNT(o.order_id) AS order_count
FROM customer c
JOIN orders o
     ON o.customer_id = c.customer_id
GROUP BY c.customer_id,
         c.full_name
HAVING COUNT(o.order_id) > (
    SELECT COUNT(*) * 1.0 /
           (SELECT COUNT(*) FROM customer)
    FROM orders
)
ORDER BY order_count DESC;

-- 24. Find food items that were never ordered.
--     LEFT JOIN order_item; items with no match have oi.item_id = NULL.
SELECT mi.item_id, mi.name, mi.restaurant_id
FROM menu_item mi
LEFT JOIN order_item oi ON oi.item_id = mi.item_id
WHERE oi.item_id IS NULL
ORDER BY mi.item_id;

-- 25. Find the top 3 best-selling food items.
-- Best-selling is determined by total quantity ordered.
-- item_id prevents same-named items from being combined.
-- ---------------------------------------------------------------------
SELECT oi.item_id,
       oi.item_name,
       SUM(oi.quantity) AS total_qty
FROM order_item oi
GROUP BY oi.item_id,
         oi.item_name
ORDER BY total_qty DESC
LIMIT 3;

-- 26. Find customers who used a coupon.
SELECT DISTINCT c.customer_id, c.full_name
FROM customer c
JOIN coupon_redemption cr ON cr.customer_id = c.customer_id;

-- 27. Find restaurants that received no orders.
SELECT r.restaurant_id, r.name, r.is_active
FROM restaurant r
LEFT JOIN orders o ON o.restaurant_id = r.restaurant_id
WHERE o.order_id IS NULL;

-- 28. Monthly revenue of each restaurant (delivered orders).
-- Only DELIVERED orders are counted as revenue.
-- restaurant_id prevents restaurants with identical names
-- from being combined.
-- ---------------------------------------------------------------------
SELECT r.restaurant_id,
       r.name AS restaurant,
       YEAR(o.order_datetime) AS order_year,
       MONTH(o.order_datetime) AS order_month,
       COUNT(o.order_id) AS orders_count,
       SUM(o.total_amount) AS revenue
FROM orders o
JOIN restaurant r
     ON r.restaurant_id = o.restaurant_id
WHERE o.status = 'DELIVERED'
GROUP BY r.restaurant_id,
         r.name,
         YEAR(o.order_datetime),
         MONTH(o.order_datetime)
ORDER BY order_year,
         order_month,
         restaurant;


-- 29. Find the delivery partner with the most completed deliveries.
SELECT dp.partner_id, dp.full_name, COUNT(d.delivery_id) AS completed
FROM delivery_partner dp
JOIN delivery d
      ON d.partner_id = dp.partner_id AND d.assignment_status = 'DELIVERED'
GROUP BY dp.partner_id, dp.full_name
ORDER BY completed DESC
LIMIT 1;

-- 30. Find customers who placed orders but never wrote a review.
--     Join orders (they ordered) and LEFT JOIN reviews (none found = NULL).
SELECT DISTINCT c.customer_id, c.full_name
FROM customer c
JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN restaurant_review rr ON rr.customer_id = c.customer_id
WHERE rr.review_id IS NULL
ORDER BY c.customer_id;

-- =====================================================================
-- EXTRA: simple INSERT / UPDATE / DELETE examples
-- =====================================================================

-- INSERT: add a new food item
-- INSERT INTO menu_item (restaurant_id, category_id, name, description, price, is_veg)
-- VALUES (1, 1, 'Rava Dosa', 'Crispy semolina dosa', 130.00, 1);

-- UPDATE: change the price of an item
-- UPDATE menu_item SET price = 260.00 WHERE item_id = 3;

-- DELETE: remove an item from a cart
-- DELETE FROM cart_item WHERE cart_id = 1 AND item_id = 6;

-- RIGHT JOIN demonstration (every menu item, with its restaurant):
SELECT r.name AS restaurant, mi.name AS item
FROM restaurant r
RIGHT JOIN menu_item mi ON mi.restaurant_id = r.restaurant_id
ORDER BY item;