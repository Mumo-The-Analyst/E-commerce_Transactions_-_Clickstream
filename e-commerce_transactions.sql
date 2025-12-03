USE ecommerce_transactions;


-- Data Cleaning and Preparation
-- 1. customers table
-- checking the data types for each column in customers table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers';

-- checking for NULL values
SELECT COUNT(*) AS rows_with_nulls
FROM customers
WHERE 
    customer_id IS NULL OR
    name IS NULL OR
    email IS NULL OR
    country IS NULL OR
    age IS NULL OR
    signup_date IS NULL OR
    marketing_opt_in IS NULL;

-- checking for DUPLICATES
SELECT *, COUNT(*) AS duplicates
FROM customers
GROUP BY customer_id, name, email, country, age, signup_date, marketing_opt_in
HAVING COUNT(*) > 1;

-- altering data types
ALTER TABLE customers
ALTER COLUMN customer_id INT NOT NULL;

ALTER TABLE customers
ALTER COLUMN age INT NOT NULL;



-- 2. products table
-- checking the data types for each column in products table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'products';


-- checking for NULL values
SELECT COUNT(*) AS rows_with_nulls
FROM products
WHERE 
    product_id IS NULL OR
    category IS NULL OR
    name IS NULL OR
    price_usd IS NULL OR
    cost_usd IS NULL OR
    margin_usd IS NULL;

-- checking for DUPLICATES
SELECT *, COUNT(*) AS duplicates
FROM products
GROUP BY product_id, name, category, name, price_usd, cost_usd, margin_usd
HAVING COUNT(*) > 1;

-- altering data types 
ALTER TABLE products
ALTER COLUMN product_id INT NOT NULL;

ALTER TABLE products
ALTER COLUMN price_usd DECIMAL(10,2) NOT NULL;

ALTER TABLE products
ALTER COLUMN cost_usd DECIMAL(10,2) NOT NULL;

ALTER TABLE products
ALTER COLUMN margin_usd DECIMAL(10,2) NOT NULL;


-- 3. sessions table
-- checking the data types for each column in sessions table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sessions';

-- checking for NULL values
SELECT COUNT(*) AS rows_with_nulls
FROM sessions
WHERE 
    session_id IS NULL OR
    customer_id IS NULL OR
    start_time IS NULL OR
    device IS NULL OR
    source IS NULL OR
    country IS NULL;

-- checking for DUPLICATES
SELECT *, COUNT(*) AS duplicates
FROM sessions
GROUP BY session_id, customer_id, start_time, device, source, country
HAVING COUNT(*) > 1;



-- 4. events table
-- checking the data types for each column in events table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'events';

-- checking for NULL values
SELECT COUNT(*) AS rows_with_nulls
FROM events
WHERE 
    event_id IS NULL OR
    session_id IS NULL OR
    timestamp IS NULL OR
    event_type IS NULL OR
    product_id IS NULL OR
	qty IS NULL OR
	cart_size IS NULL OR
	payment IS NULL OR
	discount_pct IS NULL OR
    amount_usd IS NULL;

-- checking for DUPLICATES
SELECT *, COUNT(*) AS duplicates
FROM events
GROUP BY event_id, session_id, timestamp, event_type, product_id, qty, cart_size, payment,discount_pct, amount_usd
HAVING COUNT(*) > 1;

-- altering data types
ALTER TABLE events
ALTER COLUMN product_id INT NULL;

ALTER TABLE events
ALTER COLUMN qty INT NULL;

ALTER TABLE events
ALTER COLUMN cart_size INT NULL;

ALTER TABLE events
ALTER COLUMN discount_pct DECIMAL(10,2) NULL;

ALTER TABLE events
ALTER COLUMN amount_usd DECIMAL(10,2) NULL;


-- 5. orders table
-- checking the data types for each column in orders table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'orders';


-- checking for NULL values
SELECT COUNT(*) AS rows_with_nulls
FROM orders
WHERE 
    order_id IS NULL OR
    customer_id IS NULL OR
    order_time IS NULL OR
    payment_method IS NULL OR
    discount_pct IS NULL OR
	subtotal_usd IS NULL OR
	total_usd IS NULL OR
	country IS NULL OR
	device IS NULL OR
    source IS NULL;

-- checking for DUPLICATES
SELECT *, COUNT(*) AS duplicates
FROM orders
GROUP BY order_id, customer_id, order_time, payment_method, discount_pct, subtotal_usd, total_usd, country, device, source 
HAVING COUNT(*) > 1;

-- altering data types 
ALTER TABLE orders
ALTER COLUMN customer_id INT NOT NULL;

ALTER TABLE orders
ALTER COLUMN discount_pct INT NOT NULL;

ALTER TABLE orders
ALTER COLUMN customer_id INT NOT NULL;

ALTER TABLE orders
ALTER COLUMN subtotal_usd DECIMAL(10,2) NOT NULL;

ALTER TABLE orders
ALTER COLUMN total_usd DECIMAL(10,2) NOT NULL;



-- 6. order_items table
-- checking the data types for each column in order_items table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'order_items';

-- checking for NULL values
SELECT COUNT(*) AS rows_with_nulls
FROM order_items
WHERE 
    order_id IS NULL OR
    product_id IS NULL OR
    unit_price_usd IS NULL OR
    quantity IS NULL OR
    line_total_usd IS NULL;

-- checking for DUPLICATES
SELECT *, COUNT(*) AS duplicates
FROM order_items
GROUP BY order_id, product_id, unit_price_usd, quantity, line_total_usd
HAVING COUNT(*) > 1;

-- handling DUPLICATES in order_items
WITH duplicates_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY order_id, product_id, unit_price_usd, quantity, line_total_usd
               ORDER BY order_id
           ) AS rn
    FROM order_items
)
DELETE FROM duplicates_cte
WHERE rn > 1;


-- altering data types 
ALTER TABLE order_items
ALTER COLUMN unit_price_usd DECIMAL(10,2) NOT NULL;

ALTER TABLE order_items
ALTER COLUMN line_total_usd DECIMAL(10,2) NOT NULL;

-- 7. reviews table
-- checking the data types for each column in reviews table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'reviews';

-- checking for NULL values
SELECT COUNT(*) AS rows_with_nulls
FROM reviews
WHERE 
    review_id IS NULL OR
	order_id IS NULL OR
    product_id IS NULL OR
    rating IS NULL OR
    review_text IS NULL OR
    review_time IS NULL;

-- checking for DUPLICATES
SELECT *, COUNT(*) AS duplicates
FROM reviews
GROUP BY review_id, order_id, product_id, rating, review_text, review_time
HAVING COUNT(*) > 1;




-- Answering Business Questions
-- Q1. What is the total revenue and profit per year?
WITH revenue_per_year AS (
    SELECT 
        YEAR(order_time) AS year,
        SUM(total_usd) AS total_revenue
    FROM orders
    GROUP BY YEAR(order_time)
),

profit_per_year AS (
    SELECT 
        YEAR(o.order_time) AS year,
        SUM(oi.line_total_usd - (oi.quantity * p.cost_usd)) AS total_profit
    FROM order_items oi
    JOIN orders o 
        ON oi.order_id = o.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY YEAR(o.order_time)
)

SELECT 
    r.year,
    r.total_revenue,
    p.total_profit
FROM revenue_per_year r
JOIN profit_per_year p 
    ON r.year = p.year
ORDER BY r.year;


-- Q2. Which ten products generate the highest revenue?
SELECT TOP 10
    p.product_id,
    p.name AS product_name,
    p.category,
    SUM(oi.line_total_usd) AS total_revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY 
    p.product_id, 
    p.name, 
    p.category
ORDER BY 
    total_revenue DESC;   


-- Q3. Who are the top 10 customers by total spending and how frequently do they order?
SELECT TOP 10
    c.customer_id,
    c.name AS customer_name,
    c.country,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_usd) AS total_spending,
    RANK() OVER (ORDER BY SUM(o.total_usd) DESC) AS spending_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.name, c.country
ORDER BY spending_rank;


-- Q4. What percentage of customers make repeat purchases, and how does it change over time?
WITH customer_orders AS (
    SELECT 
        customer_id,
        YEAR(order_time) AS order_year,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY customer_id, YEAR(order_time)
),

repeat_flag AS (
    SELECT 
        order_year,
        COUNT(CASE WHEN total_orders > 1 THEN 1 END) AS repeat_customers,
        COUNT(customer_id) AS total_customers
    FROM customer_orders
    GROUP BY order_year
)

SELECT 
    order_year,
    repeat_customers,
    total_customers,
    ROUND((repeat_customers * 1.0 / total_customers) * 100, 2) AS repeat_purchase_rate_pct
FROM repeat_flag
ORDER BY order_year;


-- Q5. Which acquisition sources (e.g., ads, organic, email) generate the highest conversion rates and revenue?
WITH conversions AS (
    SELECT 
        s.source,
        COUNT(*) AS total_sessions,
        SUM(CASE WHEN o.order_id IS NOT NULL THEN 1 ELSE 0 END) AS converted_sessions
    FROM sessions s
    LEFT JOIN orders o
        ON s.customer_id = o.customer_id
        AND CAST(s.start_time AS DATE) = CAST(o.order_time AS DATE)
    GROUP BY s.source
),

revenues AS (
    SELECT 
        source,
        SUM(total_usd) AS total_revenue,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY source
)

SELECT 
    c.source,
    c.total_sessions,
    c.converted_sessions,
    ROUND((c.converted_sessions * 1.0 / c.total_sessions) * 100, 2) AS conversion_rate_pct,
    r.total_orders,
    r.total_revenue
FROM conversions c
LEFT JOIN revenues r
    ON c.source = r.source
ORDER BY conversion_rate_pct DESC;


-- Q6. Which devices (mobile, desktop, tablet) contribute most to revenue?
SELECT 
    device,
    COUNT(order_id) AS total_orders,
    SUM(total_usd) AS total_revenue,
    ROUND(AVG(total_usd), 2) AS avg_order_value
FROM orders
GROUP BY device
ORDER BY total_revenue DESC;


-- Q7. How do discounts affect total revenue, order volume, and profit margins?
SELECT 
    CASE 
        WHEN discount_pct = 0 THEN 'No Discount'
        WHEN discount_pct BETWEEN 0.01 AND 10 THEN '1-10%'
        WHEN discount_pct BETWEEN 10.01 AND 20 THEN '11-20%'
        WHEN discount_pct BETWEEN 20.01 AND 50 THEN '21-50%'
        ELSE '51%+'
    END AS discount_range, -- defining Discount buckets
    
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_usd) AS total_revenue,
    SUM(oi.line_total_usd - (oi.quantity * p.cost_usd)) AS total_profit,
    ROUND(
        CASE WHEN SUM(o.total_usd) = 0 THEN 0
        ELSE SUM(oi.line_total_usd - (oi.quantity * p.cost_usd)) * 1.0 / SUM(o.total_usd) * 100
        END, 2
    ) AS avg_profit_margin_pct

FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id

GROUP BY 
    CASE 
        WHEN discount_pct = 0 THEN 'No Discount'
        WHEN discount_pct BETWEEN 0.01 AND 10 THEN '1-10%'
        WHEN discount_pct BETWEEN 10.01 AND 20 THEN '11-20%'
        WHEN discount_pct BETWEEN 20.01 AND 50 THEN '21-50%'
        ELSE '51%+'
    END

ORDER BY total_revenue DESC;



-- Q8. What is the average cart size and conversion rate per session?
WITH session_cart AS (
    -- Calculate cart size per session
    SELECT 
        s.session_id,
        s.customer_id,
        s.source,
        s.device,
        SUM(e.qty) AS total_cart_qty
    FROM sessions s
    LEFT JOIN events e
        ON s.session_id = e.session_id
    WHERE e.event_type = 'add_to_cart'  -- only consider add-to-cart events
    GROUP BY s.session_id, s.customer_id, s.source, s.device
),

session_conversion AS (
    -- Flag sessions that resulted in at least one order
    SELECT 
        s.session_id,
        CASE WHEN o.order_id IS NOT NULL THEN 1 ELSE 0 END AS converted
    FROM sessions s
    LEFT JOIN orders o
        ON s.customer_id = o.customer_id
        AND CAST(s.start_time AS DATE) = CAST(o.order_time AS DATE)
)

SELECT 
    AVG(sc.total_cart_qty * 1.0) AS avg_cart_size,
    ROUND(AVG(conv.converted * 1.0) * 100, 2) AS conversion_rate_pct
FROM session_cart sc
JOIN session_conversion conv
    ON sc.session_id = conv.session_id;


-- Q9. How does product rating affect sales volume and revenue?
SELECT 
    CASE 
        WHEN r.rating BETWEEN 1 AND 1.99 THEN '1-1.99'
        WHEN r.rating BETWEEN 2 AND 2.99 THEN '2-2.99'
        WHEN r.rating BETWEEN 3 AND 3.99 THEN '3-3.99'
        WHEN r.rating BETWEEN 4 AND 4.99 THEN '4-4.99'
        ELSE '5'
    END AS rating_range,
    
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.line_total_usd) AS total_revenue,
    COUNT(DISTINCT p.product_id) AS num_products

FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
LEFT JOIN reviews r
    ON p.product_id = r.product_id

GROUP BY 
    CASE 
        WHEN r.rating BETWEEN 1 AND 1.99 THEN '1-1.99'
        WHEN r.rating BETWEEN 2 AND 2.99 THEN '2-2.99'
        WHEN r.rating BETWEEN 3 AND 3.99 THEN '3-3.99'
        WHEN r.rating BETWEEN 4 AND 4.99 THEN '4-4.99'
        ELSE '5'
    END
ORDER BY rating_range DESC;


-- Q10. Which 10 countries generate the highest revenue?
SELECT TOP 10
    country,
    COUNT(order_id) AS total_orders,
    SUM(total_usd) AS total_revenue
FROM orders
GROUP BY country
ORDER BY total_revenue DESC;