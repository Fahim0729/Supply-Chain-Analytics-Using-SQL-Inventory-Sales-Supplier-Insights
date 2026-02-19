# 📦 Supply Chain Insights: Product Performance, Brand Value, Supplier Trends

This project presents an end-to-end SQL analysis for an electronics company, using products, inventory, and suppliers datasets to address three key business questions related to stock management and sales performance.

<div align="center">

### 🛠️ SQL Functions & Features Used
`SUM()` • `AVG()` • `JOIN()` • `WHERE()` • `BETWEEN()` • `GROUP BY()` • `HAVING()` • `CTEs` • `RANK()` • `ROW_NUMBER()` • `LAG()` • `ORDER BY()` • `CASE` • `Subquery` • `ROUND()` • Filtering Logic

</div>

---

## 📊 Database Schema

The `SQL_Portfolio` database was created with five tables to address the business questions of the electronics company. Three of these are dimension tables, and two are fact tables:

| **Dimension Tables** | **Fact Tables** |
|---------------------|-----------------|
| • product | • received_purchase_orders |
| • suppliers | • stock_level |
| • datetime | |

### 📈 Data Generation Plan
All tables, except the datetime table, were populated from the `staging database`, where four external Excel files related to product, suppliers, received_orders, and stock_level had been previously uploaded. The datetime table was created using a SQL script that generates dates from January 1, 2025, to December 31, 2025.

*The following figure depicts the database tables name along with the data generation plan used to populate them.*
<p align="center">
  <img src="https://github.com/Fahim0729/Supply-Chain-Analytics-Using-SQL-Inventory-Sales-Supplier-Insights/blob/9926429eb37e25222dc4a0924a6475671eb8c358/Data_Generation_Plan.png" alt="Histogram" width="600"/>
  <br>
  <em>Figure: Database Tables and Data Generation Plan</em>
</p>


### 🔗 Database Diagram
Each fact table is connected to the three dimension tables, establishing relationships that support analysis and reporting.

*The following figure presents the database diagram, illustrating the relationships between the fact and dimension tables, with the primary keys of each table also indicated.*
<p align="center">
  <img src="https://github.com/Fahim0729/Supply-Chain-Analytics-Using-SQL-Inventory-Sales-Supplier-Insights/blob/29b2e9fcb6568ae46ca4417bcb80b131f7e53269/Database_Diagram.png" alt="Histogram" width="600"/>
  <br>
  <em>Figure: Database Diagram Illustrating Relationships Between Fact and Dimension Tables</em>
</p>

---

## 📋 Business Questions & SQL Functions

The following section presents the answers to the questions along with the SQL queries used, and lists the SQL functions applied to solve each question.

### 📌 Q1. Brand Inventory Value Analysis
**Identify brands with significant restocking activity (>50 units) in the second half of 2025 (July-December) and analyze their average shelf inventory value to optimize supply chain planning for next year.**

🔹 SQL Functions: SUM(), AVG(), JOIN, BETWEEN, WHERE, GROUP BY, HAVING

📝 The brands JVC, MSCS, Sennheiser, Sony, and Toshiba had restocking activity exceeded 50 units between June and December 2025. The electronics company received the highest number of units (543) from MSCS, followed by Toshiba with 202 units. Sennheiser, JVC, and Sony ranked 3rd, 4th, and 5th respectively in terms of total received units.
However, Sony had the highest average stock value despite being in 5th position based on total received units. In contrast, Toshiba recorded the lowest average stock value among the five brands.

*The figure below illustrates the stock analysis results, showing total received units and average stock value by brand between July and December 2025.*
<p align="center">
  <img src="https://github.com/Fahim0729/Supply-Chain-Analytics-Using-SQL-Inventory-Sales-Supplier-Insights/blob/28f41ad3b6e538d1e7a947c404e91475f4f7f43f/Q1.png" alt="Histogram" width="600"/>
  <br>
  <em>Figure: Stock Analysis by Brand (July–December 2025)</em>
</p>

---

### 📌 Q2. Product Sales Velocity
**Identify the top 5 products by total quantity sold and categorize them as High (more than 90 units) Medium (60 to 90 units), or 
Low velocity (less than 60 units) to understand sales performance trends.**

🔹 SQL Functions: CTEs, JOIN, RANK(), ORDER BY, CASE

📝 Products were classified into High (more than 90 units), Medium (60–90 units), and Low velocity (less than 60 units) categories based on total quantity sold. The top five products were ranked by total sales volume and assigned their respective velocity categories. The Manfrotto MN1004BAC Master Light Stand, Manfrotto MT057C3 Carbon Fibre 3 Section Geared, and Rycote 37705 Portable Recorder Suspension occupied the 1st to 3rd positions and were classified as High Velocity. The Hoya 37S-HOY 37MM Skylight Filter and HOYA 40.5mm CP Filter – Slim were 4th and 5th, classified as Medium Velocity.

*The figure illustrates these rankings and classifications of products.*
<p align="center">
  <img src="https://github.com/Fahim0729/Supply-Chain-Analytics-Using-SQL-Inventory-Sales-Supplier-Insights/blob/28f41ad3b6e538d1e7a947c404e91475f4f7f43f/Q2.png" alt="Histogram" width="600"/>
  <br>
  <em>Figure: Product Rankings and Classifications</em>
</p>

---

### 📌 Q3. Supplier Restocking Trend Analysis
**Identify the top 3 suppliers with the largest positive change in received quantity by comparing their most recent delivery to their previous delivery, to understand suppliers with significant restocking trends.**

🔹 SQL Functions: Subquery, JOIN, LAG, ROW_NUMBER, RANK, ROUND, Filtering Logic

📝 The analysis identifies the top three suppliers with the largest positive change in received quantity by comparing their most recent delivery to the previous one. Samsung recorded the highest increase, receiving 90 units on 20 December 2025, which was 20 units more than its previous delivery. ENE followed with a delivery of 77 units on 2 December 2025, representing an increase of 15 units, while Toshiba ranked third with 64 units received on 14 November 2025, 14 units higher than its prior delivery. These results highlight suppliers exhibiting significant restocking trends during the period.

*The figure below presents the most recent deliveries of suppliers with the largest positive changes in received quantity.*
<p align="center">
  <img src="https://github.com/Fahim0729/Supply-Chain-Analytics-Using-SQL-Inventory-Sales-Supplier-Insights/blob/28f41ad3b6e538d1e7a947c404e91475f4f7f43f/Q3.png" alt="Histogram" width="600"/>
  <br>
  <em>Figure: Suppliers with the Highest Increases in Received Quantity – Latest Delivery Data</em>
</p>

---

### ⚙️ Data Cleaning / Preprocessing
📝 Several data cleaning steps were explored during the project to ensure data quality. Any zero values in Cost_Price or Retail_Price were checked and replaced with NULL or default values using COALESCE, and the price columns were converted to DECIMAL(10,2) for consistency. Additionally, text fields such as Product_Type were standardized by capitalizing the first letter and converting the rest to lowercase. These steps were performed as part of the data preparation process to verify that price and product data were in the correct format.


---

## 🚀 Key Insights

| Analysis | Business Impact |
|----------|-----------------|
| **Brand Value Analysis** | Optimize inventory planning for 2026 |
| **Product Performance** | Identify sales velocity trends for top products |
| **Supplier Trends** | Recognize improving supplier relationships |

---

<div align="center">
  
**[⬆ Back to Top](#top)**

</div>
