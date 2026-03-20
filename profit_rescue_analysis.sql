-- ============================================================
-- Project: Profit Rescue Analysis (SQL + Excel)
-- Objective: Identify profit loss drivers and prepare data for dashboarding
-- ============================================================


-- ============================================================
-- STEP 1: DATABASE SETUP
-- Create and use project database
-- ============================================================

CREATE DATABASE superstore_project;
USE superstore_project;


-- ============================================================
-- STEP 2: RAW DATA TABLE (STAGING LAYER)
-- Store original CSV data without transformation
-- Dates are kept as VARCHAR for initial ingestion
-- ============================================================

CREATE TABLE superstore_raw (
    row_id INT,
    order_id VARCHAR(50),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,4)
);

-- Validate raw data import
SELECT COUNT(*) FROM superstore_raw;
SELECT * FROM superstore_raw LIMIT 10;


-- ============================================================
-- STEP 3: CLEAN DATA TABLE (ANALYTICAL LAYER)
-- Convert data types and prepare structured dataset
-- ============================================================

CREATE TABLE superstore (
    row_id INT,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,4)
);


-- ============================================================
-- STEP 4: DATA CLEANING AND TRANSFORMATION
-- Convert date fields and move data from raw to clean table
-- ============================================================

INSERT INTO superstore
SELECT
    row_id,
    order_id,
    STR_TO_DATE(order_date, '%m/%d/%Y'),
    STR_TO_DATE(ship_date, '%m/%d/%Y'),
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit
FROM superstore_raw;

-- Validate cleaned data
SELECT COUNT(*) FROM superstore;
SELECT MIN(order_date), MAX(order_date) FROM superstore;
SELECT * FROM superstore LIMIT 5;


-- ============================================================
-- STEP 5: FEATURE ENGINEERING
-- Create derived metrics for analysis
-- profit_margin: profitability efficiency
-- is_loss: flag for loss-making transactions
-- delivery_days: operational efficiency metric
-- ============================================================

ALTER TABLE superstore
ADD COLUMN profit_margin DECIMAL(10,4),
ADD COLUMN is_loss INT,
ADD COLUMN delivery_days INT;

UPDATE superstore
SET 
    profit_margin = profit / sales,
    is_loss = CASE WHEN profit < 0 THEN 1 ELSE 0 END,
    delivery_days = DATEDIFF(ship_date, order_date);

-- Verify engineered features
SELECT 
    sales, profit, profit_margin, is_loss, delivery_days
FROM superstore
LIMIT 10;


-- ============================================================
-- STEP 6: KPI VIEW #1 - MONTHLY SALES TREND
-- Analyze revenue and profit trends over time
-- ============================================================

CREATE VIEW monthly_sales AS
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) AS profit_margin
FROM superstore
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

SELECT * FROM monthly_sales;


-- ============================================================
-- STEP 7: KPI VIEW #2 - PROFIT BY REGION
-- Identify regional performance differences
-- ============================================================

CREATE VIEW profit_by_region AS
SELECT 
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(profit) / SUM(sales) AS profit_margin
FROM superstore
GROUP BY region
ORDER BY total_profit DESC;

SELECT * FROM profit_by_region;


-- ============================================================
-- STEP 8: KPI VIEW #3 - LOSS MAKING PRODUCTS
-- Identify products contributing to losses
-- ============================================================

CREATE VIEW loss_products AS
SELECT 
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_loss
FROM superstore
WHERE profit < 0
GROUP BY product_name
ORDER BY total_loss ASC;

SELECT * FROM loss_products LIMIT 10;


-- ============================================================
-- STEP 9: KPI VIEW #4 - DISCOUNT ANALYSIS
-- Analyze impact of discount levels on profitability
-- ============================================================

CREATE VIEW discount_analysis AS
SELECT 
    discount,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    AVG(profit) AS avg_profit
FROM superstore
GROUP BY discount
ORDER BY discount;

SELECT * FROM discount_analysis;


-- ============================================================
-- END OF PROJECT
-- SQL output is used for Excel dashboard and business insights
-- ============================================================
