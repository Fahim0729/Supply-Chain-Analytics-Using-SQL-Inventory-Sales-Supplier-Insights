
-- Q-1. Identify brands that received significant restocking (more than 50 units) in the second half of 2025 (July–December) and 
--      analyze their average shelf inventory value to support supply chain optimization for 2026.

-- SQL Aggregate and Filtering Functions: SUM(), AVG(), JOIN, BETWEEN, WHERE, GROUP BY, HAVING 
SELECT
    p.Brand,
    SUM(s.Received_Quantity) AS Total_Received_Units,
    AVG(s.Shelf_Quantity * p.Cost_Price) AS Avg_Stock_Value
FROM fact_stock_level s
JOIN dim_product p
    ON s.Product_ID = p.Product_ID
WHERE s.As_of_Date BETWEEN '2025-07-01' AND '2025-12-31'
GROUP BY p.Brand
HAVING SUM(s.Received_Quantity) > 50;



-- Q2. Identify the top 5 products by total quantity sold and categorize them as High (more than 90 units) Medium (60 to 90 units), or 
--     Low velocity (less than 60 units) to understand sales performance trends.**

-- SQL CTEs with Ranking and Conditional Logic: CTEs, JOIN, RANK(), ORDER BY, CASE

WITH product_sales AS (
    SELECT
        p.Product_ID,
        p.Product_Name,
        SUM(s.Quantity_Sold) AS total_units_sold
    FROM [[SQl_Portfolio]]].dbo.dim_product p
    INNER JOIN [[SQl_Portfolio]]].dbo.Fact_stock_level s 
        ON p.Product_ID = s.Product_ID
    GROUP BY 
        p.Product_ID,
        p.Product_Name
),
ranked_products AS (
    SELECT
        Product_ID,
        Product_Name,
        total_units_sold,
        RANK() OVER (ORDER BY total_units_sold DESC) AS sales_rank
    FROM product_sales
)
SELECT
    Product_ID,
    Product_Name,
    sales_rank,
    CASE
        WHEN total_units_sold < 60 THEN 'Low Velocity'
        WHEN total_units_sold >= 60 AND total_units_sold < 90 THEN 'Medium Velocity'
        ELSE 'High Velocity'
    END AS velocity_category
FROM ranked_products
WHERE sales_rank <= 5
ORDER BY sales_rank;

-- Q3. Subquery+ LAG  -- Identify the top 3 suppliers with the largest positive change in received quantity by comparing
--             their most recent delivery to their previous delivery, to understand suppliers with significant restocking trends

-- SQL Subquery with Window Functions: Subquery, JOIN, LAG, ROW_NUMBER, RANK, ROUND, and filtering logic

SELECT TOP 3
    o.Supplier_Name,
    o.Received_Date,
    o.Received_Quantity,
    ROUND((o.Received_Quantity - o.prev_qty), 2) AS difference,
    RANK() OVER (ORDER BY (o.Received_Quantity - o.prev_qty) DESC) AS rank
FROM (
    SELECT 
        s.Supplier_Name,
        r.Received_Date,
        r.Received_Quantity,
        LAG(r.Received_Quantity) OVER (PARTITION BY r.Supplier_ID ORDER BY r.Received_Date) AS prev_qty,
        ROW_NUMBER() OVER (PARTITION BY r.Supplier_ID ORDER BY r.Received_Date DESC) AS rn
    FROM fact_received_purchase_orders r
    JOIN dim_suppliers s ON r.Supplier_ID = s.Supplier_ID
) AS o
WHERE o.rn = 1
  AND o.prev_qty IS NOT NULL
  AND o.Received_Quantity > o.prev_qty
ORDER BY difference DESC;




-------------------

