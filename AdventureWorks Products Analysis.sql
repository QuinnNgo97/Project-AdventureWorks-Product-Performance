-- Null check on Sales order details:
SELECT *
    FROM AdventureWorks2022.Sales.SalesOrderDetail
    WHERE [SalesOrderID] IS NULL 
    OR [OrderQty] IS NULL 
    OR [ProductID] IS NULL
    OR [SpecialOfferID] IS NULL
    OR [UnitPrice] IS NULL
    OR [LineTotal] IS NULL;
-- Null check on Product details:
SELECT *
    FROM AdventureWorks2022.Production.Product
    WHERE [ProductSubcategoryID] IS NULL
        OR [StandardCost] IS NULL
        OR [ListPrice] IS NULL
        OR [Name] IS NULL 
        OR [ProductLine] IS NULL
        OR [Class] IS NULL
        OR [Style] IS NULL
        OR [Size] IS NULL
        OR [SafetyStockLevel] IS NULL
        OR [Color] IS NULL
        OR [MakeFlag] IS NULL;

-- Getting table information:
SELECT 
    c.name 'Column Name',
    t.Name 'Data type',
    ISNULL(i.is_primary_key, 0) 'Primary Key'
FROM    
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE
    c.object_id = OBJECT_ID('Production.ProductInventory');
-- Check the how often product change costs:
WITH ChangeRate AS (
            SELECT 
                CONCAT(CONVERT(VARCHAR, [StartDate], 120), ' - ', CONVERT(VARCHAR, [EndDate], 120)) AS [DateRange]
            FROM 
                AdventureWorks2022.Production.ProductCostHistory
            )
    SELECT 
        [DateRange], 
        COUNT([DateRange]) as [Instances]
        FROM ChangeRate 
        GROUP BY [DateRange];

-- Check Null StandardCost on the table. If not then all of the productid each has at least a value for cost:
SELECT  *
    FROM AdventureWorks2022.Production.ProductCostHistory
    WHERE [StandardCost] IS NULL;

-- Is all the listed products in the SalesOrder is also within this CostHistory table. If yes count PID from OrderDetail before and after inner join with CostHistory would be the same.
SELECT COUNT(DISTINCT([ProductID])) AS [NoProductID]
    FROM 
        AdventureWorks2022.Sales.SalesOrderDetail;

WITH NullCheck AS (
            SELECT sod.* 
                FROM 
                    AdventureWorks2022.Sales.SalesOrderDetail sod 
                INNER JOIN 
                    AdventureWorks2022.Production.ProductCostHistory pch 
                ON 
                    sod.[ProductID] = pch.[ProductID]
            )
    SELECT COUNT(DISTINCT([ProductID])) AS [NoProductID]
        FROM NullCheck;

-- This sequence result in a cost list for all products, with the most recent available cost:
DROP TABLE IF EXISTS #TempCost;
with cte5 as (select * from Production.ProductCostHistory where StartDate = '2013-05-30')
    , cte6 as (select * from Production.ProductCostHistory where StartDate = '2012-05-30')
    , cte7 as (select * from Production.ProductCostHistory where StartDate = '2011-05-31')
    ,cte8 as (select sod.*, cte5.StandardCost from Sales.SalesOrderDetail sod
    left join cte5
    on cte5.ProductID = sod.ProductID)

    ,cte9 as (select cte8.*, cte6.StandardCost as StandardCost2 from cte8
    left join cte6
    on cte6.ProductID = cte8.ProductID)

    ,cte10 as (select cte9.*, cte7.StandardCost as StandardCost3 from cte9
    left join cte7
    on cte7.ProductID = cte9.ProductID)

    ,cte11 as (select *, COALESCE(StandardCost, StandardCost2) AS MergedColumn from cte10)

    ,cte12 as (select *, COALESCE(MergedColumn, StandardCost3) AS MergedColumn2 from cte11)

select ProductID, Min(MergedColumn2) as Cost into #TempCost from cte12 group by ProductID;

-- Select SalesTerritory:
SELECT 
    [TerritoryID], 
    [Name], 
    [CountryRegionCode], 
    [Group]
FROM 
    AdventureWorks2022.Sales.SalesTerritory;

-- Select ProductInventory:
SELECT 
    [ProductID], 
    [Quantity]
FROM 
    AdventureWorks2022.Production.ProductInventory;

-- Create cte to house Product that are Salable Products: FinishedGoodsFlag = 1
DROP TABLE IF EXISTS #TempProduct;
WITH ProductInfo AS (
        SELECT 
            [ProductID], 
            [Name], 
            [StandardCost], 
            [ListPrice], 
            ([ListPrice] - [StandardCost]) AS StandardProfit, 
            [ProductSubcategoryID], 
            [ProductLine], 
            [Class], 
            [Style], 
            [Size], 
            [SafetyStockLevel], 
            [Color], 
            [MakeFlag]
        FROM 
            AdventureWorks2022.Production.Product tp
        WHERE 
            [FinishedGoodsFlag] = 1
            )
-- Add productcategoryname + productsubcategoryname and create a temp table to house Product info:
    SELECT 
        ProductInfo.* , 
        ps.[Name] AS [SubCatName], 
        ps.[ProductCategoryID], 
        pc.[Name] AS [CatName] 
    INTO #TempProduct 
    FROM 
        ProductInfo
    LEFT JOIN 
        AdventureWorks2022.Production.ProductSubcategory AS ps
    ON 
        ProductInfo.[ProductSubcategoryID] = ps.[ProductSubcategoryID]
    LEFT JOIN 
        AdventureWorks2022.Production.ProductCategory AS pc
    ON 
        ps.[ProductCategoryID] = pc.[ProductCategoryID];

-- Drop CategoryID column:
ALTER TABLE #TempProduct 
    DROP COLUMN [ProductSubCategoryID];

-- Check temporary Product table:
SELECT * FROM #TempProduct;

-- Create temp table to house SalesOrderDetail:
DROP TABLE IF EXISTS #TempSales;
WITH OrderHeader AS (
            SELECT 
                [SalesOrderID], 
                [OrderDate], 
                [TerritoryID],
                [CustomerID]
            FROM 
                AdventureWorks2022.Sales.SalesOrderHeader
            WHERE 
                [OrderDate] BETWEEN '2012-05-30' AND '2014-05-30'
                    )
    , CostHistory2012 AS (
            SELECT *
            FROM 
                AdventureWorks2022.Production.ProductCostHistory
            WHERE 
                [StartDate] = '2012-05-30'
                    )
    , CostHistory2013 AS (
            SELECT * 
            FROM 
                AdventureWorks2022.Production.ProductCostHistory
            WHERE 
                [StartDate] = '2013-05-30'
                    )
    ,OrderDetail as(SELECT 
        OrderHeader.*,
        tc.[Cost],
        s.[ProductID], 
        s.[OrderQty], 
        s.[SpecialOfferID], 
        s.[UnitPrice], 
        s.[LineTotal],
                CASE 
                    WHEN OrderHeader.[OrderDate] BETWEEN '2012-05-30' AND '2013-05-29' THEN CostHistory2012.[StandardCost]
                    WHEN OrderHeader.[OrderDate] >= '2013-05-30' THEN CostHistory2013.[StandardCost]
                    ELSE NULL -- All product purchased from 2012 to 2014 without a cost set within 2012 or 2013 will end up in here. If there is a product that hasnt changed price after 2012-05-30, it will be null, even if their end date for product cost is reached. This means that some of the data is not updated.
                END AS StandardUnitCost
        FROM 
            AdventureWorks2022.Sales.SalesOrderDetail s

-- Inner join SalesOrderHeader
        INNER JOIN 
        OrderHeader 
        ON 
        OrderHeader.[SalesOrderID] = s.[SalesOrderID]
-- Left join ProductCostHistory for StandardUnitCost
        LEFT JOIN 
        CostHistory2012
        ON 
        CostHistory2012.[ProductID] = s.[ProductID]
        LEFT JOIN 
        CostHistory2013
        ON 
        CostHistory2013.[ProductID] = s.[ProductID]
-- To address products with overdued cost changes, we'll just apply the most recent cost listed from tempcost. 
        LEFT JOIN
        #tempcost tc
        ON tc.[ProductID] = s.[ProductID])
        ,UpdateCost AS (SELECT *, 
                            COALESCE([StandardUnitCost], cost) AS [StandardUnitCost2] 
                            FROM OrderDetail)
-- Calculate ProfitperLine from cost and linetotal (after sales applied):
        SELECT *,
            (ROUND((UpdateCost.[LineTotal] / UpdateCost.[OrderQty]),4) - UpdateCost.[StandardUnitCost2]) * UpdateCost.[OrderQty] AS [ProfitPerLine]
        INTO #TempSales
        FROM UpdateCost;

-- Check to make sure no null in the standard cost2 
SELECT * FROM #TempSales WHERE [StandardUnitCost] IS NULL OR [StandardUnitCost2] IS NULL;

-- Remove standard cost, cost column - redundant after check
ALTER TABLE #TempSales DROP COLUMN [StandardUnitCost], [Cost];

-- table with top 10 ProductID by revenue
SELECT TOP 10 
    [ProductID], 
    sum([LineTotal]) AS RevenuePerProduct 
    FROM 
        #TempSales 
    GROUP BY [ProductID] 
    ORDER BY sum([LineTotal]) DESC;

-- table with top 10 ProductID by profit
SELECT TOP 10 
    [ProductID], 
    sum([ProfitPerLine]) AS ProfitPerProduct 
    FROM 
        #TempSales 
    GROUP BY [ProductID] 
    ORDER BY sum([ProfitPerLine]) DESC;

-- table with top 10 ProductID by volume
SELECT TOP 10 
    [ProductID], 
    sum([OrderQty]) AS QtyPerProduct 
    FROM 
        #TempSales 
    GROUP BY [ProductID] 
    ORDER BY sum([OrderQty]) DESC;

-- table with bottom 10 ProductID by revenue
SELECT TOP 10 
    [ProductID], 
    sum([LineTotal]) AS RevenuePerProduct 
    FROM 
        #TempSales 
    GROUP BY [ProductID] 
    ORDER BY sum([LineTotal]) ASC;

-- table with bottom 10 ProductID by profit
SELECT TOP 10 
    [ProductID], 
    sum([ProfitPerLine]) AS ProfitPerProduct 
    FROM 
        #TempSales 
    GROUP BY [ProductID] 
    ORDER BY sum([ProfitPerLine]) ASC;

-- table with bottom 10 ProductID by volume
SELECT TOP 10 
    [ProductID], 
    sum([OrderQty]) AS QtyPerProduct 
    FROM 
        #TempSales 
    GROUP BY [ProductID] 
    ORDER BY sum([OrderQty]) ASC;

-- Make a table for Cumulative revenue and profit:
WITH MonthlySales AS (
    SELECT
        YEAR([OrderDate]) AS [Year],
        MONTH([OrderDate]) AS [Month],
        SUM([LineTotal]) AS [TotalRevenue],
        SUM([ProfitPerLine]) AS [TotalProfit]
    FROM #TempSales
    GROUP BY
        YEAR([OrderDate]),
        MONTH([OrderDate])
                    )
    SELECT
        CONCAT([Year], '-', RIGHT('00' + CAST([Month] AS VARCHAR(2)), 2)) AS [YearMonth],
        [TotalRevenue],
        [TotalProfit],
        [Year],
        SUM([TotalRevenue]) OVER (ORDER BY [Year], [Month]) AS [CumulativeSales],
        SUM([TotalProfit]) OVER (ORDER BY [Year], [Month]) AS [CumulativeProfit],
        SUM([TotalProfit]) OVER (ORDER BY [Year]) AS [CumulativeProfitYear]
    FROM MonthlySales
    ORDER BY
        [Year] DESC, [Month] DESC;

-- Profit Net Growth:
WITH YearlySales AS (
    SELECT
        YEAR(OrderDate) AS Year,
        SUM(ProfitPerLine) AS TotalProfit,
        Count(DISTINCT(Month(OrderDate))) as Monthcount
    FROM #TempSales
    GROUP BY
        YEAR(OrderDate)
    )
    ,EstimatedSales AS (SELECT *, 
    CASE WHEN [Year] = 2014 THEN (TotalProfit / 5 * 12)
        WHEN [Year] = 2013 THEN TotalProfit
        WHEN [Year] = 2012 THEN (TotalProfit / 7 * 12)
        ELSE NULL
        END AS EstimatedProfit
        FROM YearlySales)
    SELECT 
            A.Year,
            A.EstimatedProfit AS CurrentYearProfit,
            B.EstimatedProfit AS PreviousYearProfit,
            (A.EstimatedProfit - B.EstimatedProfit)/B.EstimatedProfit AS YoYgrowth 
            FROM EstimatedSales A
            LEFT JOIN
            EstimatedSales B
            ON
            A.Year = B.Year + 1
    ORDER BY A.Year DESC;
