
/*
PERSONAL PORTFOLIO PROJECT ON SALES DATA 

BACKGROUND INFORMATION

We received an internal memo from our Sales manager to provide him and his team a robust Dashboard for internet sales analysis 
The sales Data was sourced from https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms

IMPLEMENTATION PROCEDURE
1 We created business overview table from the internal memo, consisting of Role, Request, Value and Criteria



SKILLS USED

- AS Statement (Renaming Columns)
- Combining columns
- Commenting in SQL Script
- Formatting of SQL statements
- WHERE Clause
- ORDER BY
- LEFT JOIN
- Case() Function
- IsNull() Funtion



*/

-- Task 1 - Clean, Rename and Select Appropriate coulmns for Dim_Calendar table to cover 2018 to 2021

-- Our cleansed DIM_Date Table  --

SELECT 		 [DateKey]
			,[FullDateAlternateKey] as Date
     -- 	,[DayNumberOfWeek]
			,[EnglishDayNameOfWeek] as Day
     -- 	,[SpanishDayNameOfWeek]
     -- 	,[FrenchDayNameOfWeek]
     -- 	,[DayNumberOfMonth]
     -- 	,[DayNumberOfYear]
			,[WeekNumberOfYear] as Weekly
			,[EnglishMonthName] as Month
			,LEFT([EnglishMonthName],3) as MonthShort -- This gives us The name of each month as three alphabets.
     -- 	,[SpanishMonthName]
     -- 	,[FrenchMonthName]
			,[MonthNumberOfYear] as MonthNo
			,[CalendarQuarter] as Quarter
			,[CalendarYear] as Year
     --		,[CalendarSemester]
     -- 	,[FiscalQuarter]
     -- 	,[FiscalYear]
     -- 	,[FiscalSemester]
  FROM [AdventureWorksDW2019].[dbo].[DimDate]
  WHERE CalendarYear >= 2018 
  
 -- Task 2 - Clean, Rename and Select Appropriate coulmns for Dim_Customer table and left join with Dim_Geography table
  
 -- Our Cleansed DIM_Customers Table --
SELECT 
  c.customerkey AS CustomerKey, 
  --      ,[GeographyKey]
  --      ,[CustomerAlternateKey]
  --      ,[Title]
  c.firstname AS [First Name], 
  --      ,[MiddleName]
  c.lastname AS [Last Name], 
  c.firstname + ' ' + lastname AS [Full Name], 
  -- Combined First and Last Name
  --      ,[NameStyle]
  --      ,[BirthDate]
  --      ,[MaritalStatus]
  --      ,[Suffix]
 CASE c.gender WHEN 'M' THEN 'Male' 
				WHEN 'F' THEN 'Female' END AS Gender,
  --      ,[EmailAddress]
  --      ,[YearlyIncome]
  --      ,[TotalChildren]
  --      ,[NumberChildrenAtHome]
  --      ,[EnglishEducation]
  --      ,[SpanishEducation]
  --      ,[FrenchEducation]
  --      ,[EnglishOccupation]
  --      ,[SpanishOccupation]
  --      ,[FrenchOccupation]
  --      ,[HouseOwnerFlag]
  --      ,[NumberCarsOwned]
  --      ,[AddressLine1]
  --      ,[AddressLine2]
  --      ,[Phone]
  c.datefirstpurchase AS DateFirstPurchase, 
  --      ,[CommuteDistance]
  g.city AS [Customer City] -- Joined in Customer City from Geography Table
FROM 
  [AdventureWorksDW2019].[dbo].[DimCustomer] as c
  LEFT JOIN dbo.dimgeography AS g 
  ON g.geographykey = c.geographykey 
ORDER BY 
  CustomerKey ASC -- Ordered List by CustomerKey
  
  
-- Task 3 - Clean, Rename and Select Appropriate coulmns for Dim_products table and left join with Dim_product_Subcategory and Dim_product_category
  
 -- Our Cleansed DIM_Products Table --
 
SELECT 
  p.[ProductKey], 
  p.[ProductAlternateKey] AS ProductItemCode, 
  --      ,[ProductSubcategoryKey], 
  --      ,[WeightUnitMeasureCode]
  --      ,[SizeUnitMeasureCode] 
  p.[EnglishProductName] AS [Product Name], 
  ps.EnglishProductSubcategoryName AS [Sub Category], -- Joined in from Sub Category Table
  pc.EnglishProductCategoryName AS [Product Category], -- Joined in from Category Table
  --      ,[SpanishProductName]
  --      ,[FrenchProductName]
  --      ,[StandardCost]
  --      ,[FinishedGoodsFlag] 
  p.[Color] AS [Product Color], 
  --      ,[SafetyStockLevel]
  --      ,[ReorderPoint]
  --      ,[ListPrice] 
  p.[Size] AS [Product Size], 
  --      ,[SizeRange]
  --      ,[Weight]
  --      ,[DaysToManufacture]
  p.[ProductLine] AS [Product Line], 
  --     ,[DealerPrice]
  --      ,[Class]
  --      ,[Style] 
  p.[ModelName] AS [Product Model Name], 
  --      ,[LargePhoto]
  p.[EnglishDescription] AS [Product Description], 
  --      ,[FrenchDescription]
  --      ,[ChineseDescription]
  --      ,[ArabicDescription]
  --      ,[HebrewDescription]
  --      ,[ThaiDescription]
  --      ,[GermanDescription]
  --      ,[JapaneseDescription]
  --      ,[TurkishDescription]
  --      ,[StartDate], 
  --      ,[EndDate], 
  ISNULL (p.Status, 'Outdated') AS [Product Status] 
FROM 
  [AdventureWorksDW2019].[dbo].[DimProduct] as p
  LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
  LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey 
order by 
  p.ProductKey asc
 
-- Task 4 - Clean, Rename and Select Appropriate coulmns for Fact_InternetSales table

-- Our Cleansed FACT_InternetSales Table --
SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 
  --  ,[PromotionKey]
  --  ,[CurrencyKey]
  --  ,[SalesTerritoryKey]
  [SalesOrderNumber], 
  --  [SalesOrderLineNumber], 
  --  ,[RevisionNumber]
  --  ,[OrderQuantity], 
  --  ,[UnitPrice], 
  --  ,[ExtendedAmount]
  --  ,[UnitPriceDiscountPct]
  --  ,[DiscountAmount] 
  --  ,[ProductStandardCost]
  --  ,[TotalProductCost] 
  [SalesAmount] --  ,[TaxAmt]
  --  ,[Freight]
  --  ,[CarrierTrackingNumber] 
  --  ,[CustomerPONumber] 
  --  ,[OrderDate] 
  --  ,[DueDate] 
  --  ,[ShipDate] 
FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales]
WHERE 
  LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -3 -- Ensures we always only bring three years of date from extraction.
ORDER BY
  OrderDateKey ASC
