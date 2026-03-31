-- ============================================
-- 1. BASIC AGGREGATIONS
-- ============================================

-- Total Sales by Category
SELECT 
    p.category,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_sales DESC;


-- Total Sales by Region
SELECT 
    l.region,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN locations l ON o.location_id = l.location_id
GROUP BY l.region
ORDER BY total_sales DESC;


-- Top 10 Customers by Sales
SELECT 
    c.customer_name,
    c.segment,
    ROUND(SUM(oi.sales), 2) AS total_spent,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name, c.segment
ORDER BY total_spent DESC
LIMIT 10;


-- ============================================
-- 2. TIME-BASED ANALYSIS
-- ============================================

-- Monthly Sales Trend
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;


-- Sales by Year and Category
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS year,
    p.category,
    ROUND(SUM(oi.sales), 2) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY year, p.category
ORDER BY year, total_sales DESC;


-- Average Shipping Days by Ship Mode
SELECT 
    ship_mode,
    ROUND(AVG(ship_date - order_date), 1) AS avg_shipping_days,
    COUNT(*) AS total_orders
FROM orders
GROUP BY ship_mode
ORDER BY avg_shipping_days;


-- ============================================
-- 3. WINDOW FUNCTIONS
-- ============================================

-- Running Total of Sales Over Time
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(oi.sales), 2) AS monthly_sales,
    ROUND(SUM(SUM(oi.sales)) OVER (ORDER BY DATE_TRUNC('month', o.order_date)), 2) AS running_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;


-- Rank Products by Sales Within Each Category
SELECT 
    p.category,
    p.product_name,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.sales) DESC) AS rank_in_category
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category, p.product_name
ORDER BY p.category, rank_in_category;


-- Month Over Month Sales Growth
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', o.order_date) AS month,
        ROUND(SUM(oi.sales), 2) AS total_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT 
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month)) 
        / LAG(total_sales) OVER (ORDER BY month) * 100, 2
    ) AS growth_pct
FROM monthly_sales
ORDER BY month;


-- ============================================
-- 4. CTEs (Common Table Expressions)
-- ============================================

-- Customer Segments Performance
WITH segment_stats AS (
    SELECT 
        c.segment,
        ROUND(SUM(oi.sales), 2) AS total_sales,
        COUNT(DISTINCT c.customer_id) AS total_customers,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.segment
)
SELECT 
    segment,
    total_sales,
    total_customers,
    total_orders,
    ROUND(total_sales / total_customers, 2) AS avg_sales_per_customer,
    ROUND(total_sales / total_orders, 2) AS avg_order_value
FROM segment_stats
ORDER BY total_sales DESC;


-- Top 5 Products Per Region
WITH regional_product_sales AS (
    SELECT 
        l.region,
        p.product_name,
        p.category,
        ROUND(SUM(oi.sales), 2) AS total_sales,
        RANK() OVER (PARTITION BY l.region ORDER BY SUM(oi.sales) DESC) AS rank_in_region
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN locations l ON o.location_id = l.location_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY l.region, p.product_name, p.category
)
SELECT *
FROM regional_product_sales
WHERE rank_in_region <= 5
ORDER BY region, rank_in_region;