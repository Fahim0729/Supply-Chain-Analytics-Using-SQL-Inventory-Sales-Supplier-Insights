-----
-- *******Creating_Dimension_Table********_______________________________
Create table dim_product
(
Product_ID int not null primary key,
Product_SKU nvarchar(255),
Product_Name nvarchar(255),
Product_Type nvarchar(255),
Brand nvarchar(150),
Supplier_Name nvarchar(255),
Cost_Price int,
Retail_Price int
)

create table dim_suppliers
(
Supplier_ID int identity(1,1) not null primary key,           --## SupplierID is ony auto generated
Supplier_Name nvarchar(255),
Phone varchar(50),                            --#### should be varchar cause -- null value
Email nvarchar(255),
Country nvarchar(100)
)

create table dim_datetime
(
Date_ID date not null primary key,
Full_Date date,
Day_Of_Week int,
Week_Of_Year int,
Month_Of_Year int,
Calendar_Year int
)

--*****Creating_Fact_Table*******______________________________________
create table Fact_received_purchase_orders
(
Purchase_ID_Rec int not null primary key,
Product_ID int foreign key references dim_product(Product_ID),
Supplier_ID int foreign key references dim_suppliers(Supplier_ID),
Received_Date date foreign key references dim_datetime(Date_ID),
Received_Quantity int,
Ordered_Quantity int
)
create table Fact_stock_level
(
Stock_ID int not null primary key,
Product_ID int foreign key references dim_product(Product_ID),
Supplier_ID int foreign key references dim_suppliers(Supplier_ID),
As_of_Date date foreign key references dim_datetime(Date_ID),
Received_Quantity int,
Shelf_Quantity int,
Quantity_Sold  int
);

 --___________________________________*********** Insert values under tables **********______________

DECLARE @start DATE = '2025-01-01';                  -- Date Table create
DECLARE @end   DATE = '2025-12-31';

WHILE @start <= @end
BEGIN
    INSERT INTO [[SQl_Portfolio]]].dbo.dim_datetime
    (Date_ID, Full_Date, Day_Of_Week, Week_Of_Year, Month_Of_Year, Calendar_Year)
    VALUES
    (
        @start,
        @start,
        DATEPART(dw, @start),
        DATEPART(week, @start),
        DATEPART(month, @start),
        DATEPART(year, @start)
    );

    SET @start = DATEADD(day, 1, @start);
END;

-- dim_product
INSERT INTO [[SQl_Portfolio]]].dbo.dim_product (Product_ID, Product_SKU, Product_Name, Product_Type, Brand, Supplier_Name, Cost_Price, Retail_Price)
SELECT Product_ID, Product_SKU, ProductName AS Product_Name, ProductType AS Product_Type, Brand, SupplierName AS Supplier_Name, CostPrice AS Cost_Price, RetailPrice AS Retail_Price
FROM StagingDB.dbo.Product_info;

-- dim_suppliers
INSERT INTO [[SQl_Portfolio]]].dbo.dim_suppliers (Supplier_Name, Phone, Email, Country)
SELECT SupplierName AS Supplier_Name, Phone, Email, Country
FROM StagingDB.dbo.Suppliers_info;

-- Fact_received_purchase_orders
INSERT INTO [[SQl_Portfolio]]].dbo.Fact_received_purchase_orders (Purchase_ID_Rec, Product_ID, Supplier_ID, Received_Date, Received_Quantity, Ordered_Quantity)
SELECT fr.PurchaseOrderCode as Purchase_ID_Rec, p.Product_ID, s.Supplier_ID, d.Date_ID, fr.ReceivedQty AS Received_Quantity, fr.OrderQty as Ordered_Quantity
FROM StagingDB.dbo.Fact_Received fr
JOIN [[SQl_Portfolio]]].dbo.dim_product p ON fr.Product_ID = p.Product_ID
JOIN [[SQl_Portfolio]]].dbo.dim_suppliers s ON fr.SupplierName = s.Supplier_Name
JOIN [[SQl_Portfolio]]].dbo.dim_datetime  d ON fr.ReceivedDate = d.Date_ID;

-- Fact_stock_level
INSERT INTO [[SQl_Portfolio]]].dbo.Fact_stock_level (Stock_ID, Product_ID, Supplier_ID, As_of_Date, Received_Quantity, Shelf_Quantity, Quantity_Sold)
SELECT fr.Stock_ID, p.Product_ID, s.Supplier_ID, d.Date_ID AS As_of_Date,
    fr.ReceivedQty AS Received_Quantity,
    fr.shelf_quantity AS Shelf_Quantity,
    fr.[Sold Qty] AS Quantity_Sold
FROM StagingDB.dbo.Fact_Stock fr
JOIN [[SQl_Portfolio]]].dbo.dim_product p
    ON fr.Product_ID = p.Product_ID
JOIN [[SQl_Portfolio]]].dbo.dim_suppliers s
    ON fr.SupplierName = s.Supplier_Name
JOIN [[SQl_Portfolio]]].dbo.dim_datetime d
    ON CAST(fr.[Current_Date] AS date) = d.Date_ID;

select *
from [[SQl_Portfolio]]].dbo.Fact_received_purchase_orders


--- Data cleaning --- 

-- 1. 1. Handle potential zeros (CASE WHEN Shelf_Quantity = 0 THEN NULL, COALESCE(Shelf_Quantity, 0))
SELECT 
    Product_ID,
    Product_Name,
    COALESCE(CAST([[SQl_Portfolio]]].dbo.dim_product.Cost_Price AS DECIMAL(10,2)), 0) AS Cost_Price_update,
    COALESCE(CAST([[SQl_Portfolio]]].dbo.dim_product.Retail_Price AS DECIMAL(10,2)), 0) AS Retail_Price_update
FROM [[SQl_Portfolio]]].dbo.dim_product;



-- 2. Standardize text (trim (upper, lower letter)
SELECT 
    Product_Name,
    -- Capitalize first letter, lowercase the rest
    UPPER(LEFT([[SQl_Portfolio]]].dbo.dim_product.Product_Type, 1)) +
    LOWER(SUBSTRING([[SQl_Portfolio]]].dbo.dim_product.Product_Type, 2, LEN([[SQl_Portfolio]]].dbo.dim_product.Product_Type))) 
    AS Product_Type_Formatted
FROM [[SQl_Portfolio]]].dbo.dim_product;



-- 3. 3. Type conversion (CAST(Cost_Price AS DECIMAL(10,2)), TRY_CAST())
-- Convert both columns to DECIMAL(10,2)
SELECT 
    Product_Name, Cost_Price, Retail_Price,
    CAST([[SQl_Portfolio]]].dbo.dim_product.Cost_Price AS DECIMAL(10,2)) AS Cost_Price_Decimal,
    CAST([[SQl_Portfolio]]].dbo.dim_product.Retail_Price AS DECIMAL(10,2)) AS Retail_Price_Decimal
FROM [[SQl_Portfolio]]].dbo.dim_product;

select *
from [[SQl_Portfolio]]].dbo.dim_product

