-- DROP TABLE IF EXISTS #TempProduct;
-- DROP TABLE IF EXISTS #TempSales;
-- Select SalesTerritory:
SELECT 
    [TerritoryID], 
    [Name], 
    [CountryRegionCode], 
    [Group]
FROM 
    [AdventureWorks2022].[Sales].[SalesTerritory];

-- Select ProductInventory:
SELECT 
    [ProductID], 
    [Quantity]
FROM 
    [AdventureWorks2022].[Production].[ProductInventory];

-- Create cte to house Product that are Salable Products: FinishedGoodsFlag = 1
WITH cte1 AS (
        SELECT 
            [ProductID], 
            [Name], 
            [StandardCost], 
            [ListPrice], 
            ([ListPrice] - [StandardCost]) as StandardProfit, 
            [ProductSubcategoryID], 
            [ProductLine], 
            [Class], 
            [Style], 
            [Size], 
            [SafetyStockLevel], 
            [Color], 
            [MakeFlag]
        FROM 
            [AdventureWorks2022].[Production].[Product] tp
        WHERE 
            FinishedGoodsFlag = 1
            )

-- Add productcategoryname + productsubcategoryname and create a temp table to house Product info:
SELECT 
    cte1.* , 
    ps.[Name] AS SubCatName, 
    ps.[ProductCategoryID], 
    pc.[Name] AS CatName 
INTO #TempProduct 
FROM 
    cte1
LEFT JOIN 
    [AdventureWorks2022].[Production].[ProductSubcategory] AS ps
ON 
    cte1.[ProductSubcategoryID] = ps.[ProductSubcategoryID]
LEFT JOIN 
    [AdventureWorks2022].[Production].[ProductCategory] AS pc
ON 
    ps.[ProductCategoryID] = pc.[ProductCategoryID];

-- Drop CategoryID column:
ALTER TABLE #TempProduct 
    DROP COLUMN [ProductSubCategoryID];

-- Check temporary Product table:
SELECT * FROM #TempProduct

-- Create temp table to house SalesOrderDetail:
WITH cte2 AS (
            SELECT 
                [SalesOrderID], 
                [OrderDate], 
                [TerritoryID] 
            FROM 
                [AdventureWorks2022].[Sales].[SalesOrderHeader]
            WHERE 
                [OrderDate] BETWEEN '2012-05-30' AND '2014-05-30'
            )
SELECT 
    cte2.*, 
    s.[ProductID], 
    s.[OrderQty], 
    s.[SpecialOfferID], 
    s.[UnitPrice], 
    s.[LineTotal], 
    tp.[StandardCost] AS CostPerUnit,
    (ROUND((s.[LineTotal] / s.[OrderQty]),4) - tp.[StandardCost]) * s.[OrderQty] AS ProfitPerLine
    INTO #TempSales
    FROM 
        [AdventureWorks2022].[Sales].[SalesOrderDetail] s

-- Inner join SalesOrderHeader
INNER JOIN 
    cte2 
ON 
    cte2.[SalesOrderID] = s.[SalesOrderID]
-- Left join TempProduct for LineTotal
LEFT JOIN
    #TempProduct AS tp 
ON 
    tp.[ProductID] = s.[ProductID];
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
        YEAR([OrderDate]) AS Year,
        MONTH([OrderDate]) AS Month,
        SUM([LineTotal]) AS TotalRevenue,
        SUM([ProfitPerLine]) AS TotalProfit
    FROM #TempSales
    GROUP BY
        YEAR([OrderDate]),
        MONTH([OrderDate])
)

SELECT
    CONCAT(Year, '-', RIGHT('00' + CAST(Month AS VARCHAR(2)), 2)) AS YearMonth,
    [TotalRevenue],
    [TotalProfit],
    SUM([TotalRevenue]) OVER (ORDER BY Year, Month) AS CumulativeSales,
    SUM([TotalProfit]) OVER (ORDER BY Year, Month) AS CumulativeProfit
FROM MonthlySales
ORDER BY
    [Year] DESC, [Month] DESC;
