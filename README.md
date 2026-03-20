# Profit Rescue Analysis (SQL + Excel)

## Project Overview

Profit Rescue Analysis is an end-to-end retail analytics project built using MySQL and Excel 2021.  
The goal of the project is to identify the key drivers of profit loss in the Superstore dataset and present the findings through a business dashboard.

The workflow follows a simple pipeline:

CSV Dataset -> MySQL (Cleaning + Feature Engineering + Views) -> Excel (Dashboard) -> Insights

## Business Objective

The dataset was analyzed to answer the following business questions:

- Which regions are most profitable?
- Which products are generating losses?
- How does discounting affect profit?
- How do sales and profit trend over time?
- What actionable steps can improve profitability?

## Tools Used

- MySQL
- Excel 2021

## Dataset

Source: Superstore retail dataset

The dataset contains order-level retail transactions including:

- Order and ship dates
- Sales, profit, quantity, and discount
- Customer, product, and region information

## SQL Workflow

### 1. Database Setup
Created a separate MySQL database for the project and loaded the raw CSV data into a staging table.

### 2. Data Cleaning
A raw table was used to store the original CSV data with dates initially kept as text.  
The cleaned table converted order and ship dates into proper SQL DATE fields.

### 3. Feature Engineering
Additional analytical columns were created:

- `profit_margin = profit / sales`
- `is_loss = CASE WHEN profit < 0 THEN 1 ELSE 0 END`
- `delivery_days = DATEDIFF(ship_date, order_date)`

These fields made it easier to analyze profitability, loss-making orders, and delivery performance.

### 4. KPI Views
Four SQL views were created for dashboarding:

- `monthly_sales` — monthly sales and profit trend
- `profit_by_region` — regional performance comparison
- `loss_products` — top loss-making products
- `discount_analysis` — discount level vs profit analysis

## Excel Dashboard

The SQL views were connected directly to Excel using ODBC and loaded into Power Query / worksheet tables.  
Charts were then built in Excel to create a dashboard with the following visuals:

- Monthly Sales and Profit Trend
- Profit by Region
- Discount vs Profit Impact
- Top Loss-Making Products

## Key Insights

### 1. Discounting is the main profit leak
Higher discount levels are strongly associated with lower profit.  
At higher discount buckets, average profit turns negative, which suggests excessive discounting is hurting profitability.

### 2. Central region underperforms
The Central region has the lowest profit margin among all regions despite still contributing significant sales.

### 3. Certain products consistently lose money
High-sales products such as printers and binding systems appear repeatedly among the biggest loss-making products.

### 4. Sales growth does not always translate into profit growth
Monthly sales and profit do not move proportionally.  
This suggests that revenue growth is being offset by discounting, product mix issues, or other margin pressures.

## Recommendations

Based on the analysis, the following actions are recommended:

- Reduce aggressive discounting, especially at higher discount levels
- Review pricing and cost structure for loss-making products
- Investigate the Central region for margin leakage
- Focus on products and categories that generate healthy profit margins
- Use profit margin as a decision metric, not just sales volume

## Files in This Repository

- `profit_rescue_analysis.sql` — Full SQL code for database setup, cleaning, feature engineering, and view creation
- `dashboard_pra.xlsx` — Excel dashboard built from the SQL views
- `sample - superstore.csv` - Dataset utilized for the project containing the Superstore data
- `README.md` — Project documentation

## How to Reproduce

1. Create the `superstore_project` database in MySQL
2. Run the SQL script to create the raw table, clean table, feature columns, and views
3. Connect Excel 2021 to MySQL using ODBC
4. Load the SQL views into Excel
5. Create the charts and dashboard
6. Review the insights and recommendations

## Project Outcome

This project demonstrates end-to-end data analysis using SQL for preparation and Excel for presentation.  
It highlights how business questions can be answered through a clean analytics pipeline and summarized in a dashboard for decision-making.

