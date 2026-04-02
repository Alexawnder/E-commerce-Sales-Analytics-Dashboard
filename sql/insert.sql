
-- Step 1: Load Customers
INSERT INTO customers (customer_id, customer_name, segment)
SELECT DISTINCT
    customer_id,
    customer_name,
    segment
FROM staging_orders
ON CONFLICT (customer_id) DO NOTHING;


-- Step 2: Load Locations
INSERT INTO locations (location_id, postal_code, city, state, region, country)
SELECT DISTINCT
    ROW_NUMBER() OVER (ORDER BY city, state) AS location_id,
    postal_code,
    city,
    state,
    region,
    country
FROM staging_orders
ON CONFLICT (location_id) DO NOTHING;


-- Step 3: Load Products
INSERT INTO products (product_id, product_name, category, sub_category)
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM staging_orders
ON CONFLICT (product_id) DO NOTHING;


-- Step 4: Load Orders
INSERT INTO orders (order_id, order_date, ship_date, ship_mode, customer_id, location_id)
SELECT DISTINCT
    so.order_id,
    so.order_date::DATE,
    so.ship_date::DATE,
    so.ship_mode,
    so.customer_id,
    l.location_id
FROM staging_orders so
JOIN locations l 
    ON so.city = l.city 
    AND so.state = l.state
ON CONFLICT (order_id) DO NOTHING;


-- Step 5: Load Order Items
INSERT INTO order_items (order_id, product_id, sales)
SELECT 
    order_id,
    product_id,
    sales
FROM staging_orders
ON CONFLICT (order_id, product_id) DO NOTHING;