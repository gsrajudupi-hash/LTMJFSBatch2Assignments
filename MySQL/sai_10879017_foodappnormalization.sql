USE food_delivery_db;

SHOW TABLES;

DESCRIBE customers;
DESCRIBE customer_addresses;
DESCRIBE restaurants;
DESCRIBE food_categories;
DESCRIBE menu_items;
DESCRIBE carts;
DESCRIBE cart_items;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE payments;
DESCRIBE deliveries;


/*
=========================================================
1NF - FIRST NORMAL FORM
=========================================================

Rule:
Every column must contain atomic (single) values.
No repeating groups or multiple values in one cell.

Example of an incorrect design:

order_id    customer_name    food_items
101         Ravi             Pizza, Burger, Coke

Here, food_items contains multiple values.

Correct normalized design:

Table: orders

order_id    customer_id
101         1

Table: order_items

order_item_id    order_id    food_item
1                101         Pizza
2                101         Burger
3                101         Coke

Your order_items table supports this structure.
*/


/*
=========================================================
2NF - SECOND NORMAL FORM
=========================================================

Rule:
The table must be in 1NF, and every non-key attribute
must depend on the whole candidate key, not just part
of a composite key.

Example:

Incorrect design:

order_id    menu_item_id    customer_name    quantity

If the primary key is (order_id, menu_item_id),
customer_name depends only on order_id,
not the complete key.

Correct design:

1. Customer information belongs in customers.
2. Order information belongs in orders.
3. Individual food items belong in order_items.
*/


/*
=========================================================
3NF - THIRD NORMAL FORM
=========================================================

Rule:
The table must be in 2NF, and non-key attributes
must not depend transitively on candidate keys.

Example:

Incorrect design:

menu_item_id    item_name       category_id    category_name
1               Veg Pizza       1              Pizza
2               Cheese Burger   2              Burgers

Here, category_name depends on category_id,
rather than directly on the menu item key.

Correct design:

Table: food_categories

category_id    category_name
1              Pizza
2              Burgers

Table: menu_items

menu_item_id    item_name       category_id
1               Veg Pizza       1
2               Cheese Burger   2

Your database already has separate
food_categories and menu_items tables.
*/


-- =========================================================
-- VERIFY NORMALIZATION
-- =========================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_KEY,
    IS_NULLABLE,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'food_delivery_db'
ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- =========================================================
-- INSPECT PRIMARY KEYS AND FOREIGN KEYS
-- =========================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'food_delivery_db'
ORDER BY TABLE_NAME, CONSTRAINT_NAME;


/*
=========================================================
CONCLUSION
=========================================================

The Food Delivery Application database was designed
using normalization principles up to Third Normal Form
(3NF).

Repeating groups were separated into individual records,
partial dependencies were eliminated, and transitive
dependencies were reduced by separating entities into
related tables.

Primary keys and foreign keys maintain referential
integrity and reduce data redundancy.

Full 3NF compliance requires verification of functional
dependencies and business rules.
*/

