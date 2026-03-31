-- ============================================
-- CREATE TABLES
-- ============================================

-- Customers Table
CREATE TABLE customers (
    customer_id   VARCHAR(20)  PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    segment       VARCHAR(50)
);

-- Locations Table
CREATE TABLE locations (
    location_id INTEGER      PRIMARY KEY,
    postal_code VARCHAR(20),
    city        VARCHAR(50),
    state       VARCHAR(50),
    region      VARCHAR(50),
    country     VARCHAR(50)
);

-- Products Table
CREATE TABLE products (
    product_id   VARCHAR(20) PRIMARY KEY,
    product_name TEXT,
    category     VARCHAR(50),
    sub_category VARCHAR(50)
);

-- Orders Table
CREATE TABLE orders (
    order_id    VARCHAR(20) PRIMARY KEY,
    order_date  DATE,
    ship_date   DATE,
    ship_mode   VARCHAR(50),
    customer_id VARCHAR(20) REFERENCES customers(customer_id),
    location_id INTEGER     REFERENCES locations(location_id)
);

-- Order Items Table
CREATE TABLE order_items (
    order_id   VARCHAR(20) REFERENCES orders(order_id),
    product_id VARCHAR(20) REFERENCES products(product_id),
    sales      NUMERIC(10,2),
    PRIMARY KEY (order_id, product_id)
);