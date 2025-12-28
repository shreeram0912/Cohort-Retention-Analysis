-- What is Cohort ?
-- A Cohort is simply a group of people with something in common characteristics such as (Age, City, etc)
-- What is Cohort Analysis ?
-- A Cohort Analysis is an analysis of several different cohorts to get a better understanding of behaviors, patterns & trends.
-- Depend on cohort group, we can do Time-Based Cohort, Size-Based Cohort, Segment-Based Cohort.


-- Time-Based Cohort Analysis
create database CohortAnalysis;
use CohortAnalysis;

-- Total Row_count == 541909
SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [CohortAnalysis].[dbo].[online_retail]

-- Check for null values = 135080
SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [CohortAnalysis].[dbo].[online_retail]
  WHERE customerid = 0

-- Check for not_null values = 406829
SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [CohortAnalysis].[dbo].[online_retail]
  WHERE customerid != 0

-- Use for further analysis
WITH online_retail AS (
SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [CohortAnalysis].[dbo].[online_retail]
  WHERE customerid != 0
)
select * from online_retail

-- For finding nulls in Quantity & UnitPrice = 397882
WITH online_retail AS (
SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [CohortAnalysis].[dbo].[online_retail]
  WHERE customerid != 0
)
select * from online_retail
where quantity > 0 and unitprice > 0

-- Finding duplicates
-- For finding nulls in Quantity & UnitPrice = 397882
WITH online_retail AS (
SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [CohortAnalysis].[dbo].[online_retail]
  WHERE customerid != 0
), quantity_unit_price as

(
select * from online_retail
where quantity > 0 and unitprice > 0
), duplicate_check as
-- Add Row_number to identify duplicate
(
select *, ROW_NUMBER() over (partition by invoiceno,stockcode, quantity order by invoicedate) duplicate_check
from quantity_unit_price
)
-- Count after removing duplicate = 392667
-- Duplicates count = 5215
select * from duplicate_check
where duplicate_check = 1

-- Creating a Temp_table for clean data for further analysis
WITH online_retail AS (
SELECT [InvoiceNo]
      ,[StockCode]
      ,[Description]
      ,[Quantity]
      ,[InvoiceDate]
      ,[UnitPrice]
      ,[CustomerID]
      ,[Country]
  FROM [CohortAnalysis].[dbo].[online_retail]
  WHERE customerid != 0
), quantity_unit_price as

(
select * from online_retail
where quantity > 0 and unitprice > 0
), duplicate_check as

(
select *, ROW_NUMBER() over (partition by invoiceno,stockcode, quantity order by invoicedate) duplicate_check
from quantity_unit_price
)

select * 
into #online_retail_main
from duplicate_check
where duplicate_check = 1

-- For ##global_temp_table & #temp_table
select * from #online_retail_main

-- Cohort Analysis start
-- Unique Identifier = customerid
-- Initial Start Date = (First Invoice Date) for first cohort group, that initiated 1st transaction on platform.
-- We did not take day, because we want to group only year & month.
-- First important point in time-based cohort analysis is to create cohort_date
select CustomerID,
        MIN(invoicedate) first_purchase_date,
        datefromparts(year(MIN(invoicedate)), month(MIN(invoicedate)), 1) Cohort_Date
into #cohortdate
from #online_retail_main
group by customerid

-- Why Cohort Analysis: To understand the behavior of customers to do business or transaction with us, To see patterns & Trends of group.
select * from #cohortdate

-- Second important point is creating cohort index: A cohort index is an integer representation of the numbers of months that has passed
-- since the customer first purchase or transaction.
-- Cohort_Index calculation formula = cohort_index = year_difference * 12 + month_difference + 1

select mmm.*,
cohort_index = year_difference * 12 + month_difference + 1
into #cohort_retention
from (
    select ym.*,
    year_difference = invoice_year - cohort_year,
    month_difference = invoice_month - cohort_month
    from (
            select m.*, c.cohort_date,
                    YEAR(m.invoicedate) invoice_year,
                    MONTH(m.invoicedate) invoice_month,
                    YEAR(c.cohort_date) cohort_year,
                    month(c.cohort_date) cohort_month
            from #online_retail_main m
            left join #cohortdate c
            on m.customerid = c.customerid
            ) ym
        ) mmm

select * from #cohort_retention

-- Identifying unique customerid returned & made transaction again 
select distinct customerid, Cohort_Date, cohort_index
from #cohort_retention
order by 1, 3

-- Creating cohort_table: Pivot data to see the cohort table

select * 
into #cohort_pivot
from (
        select distinct customerid, Cohort_Date, cohort_index
        from #cohort_retention
 ) tbl
pivot(
        count(customerid)
        for cohort_index in (
        [1],
        [2],
        [3],
        [4],
        [5],
        [6],
        [7],
        [8],
        [9],
        [10],
        [11],
        [12],
        [13]
        )
) as pivot_table

-- Creating Cohort Retention Rate
select * from #cohort_pivot order by Cohort_Date

select cohort_date, 
(1.0 * [1]/[1] * 100) as [1],
1.0 * [2]/[1] * 100 as [2],
1.0 * [3]/[1] * 100 as [3],
1.0 * [4]/[1] * 100 as [4],
1.0 * [5]/[1] * 100 as [5],
1.0 * [6]/[1] * 100 as [6],
1.0 * [7]/[1] * 100 as [7],
1.0 * [8]/[1] * 100 as [8],
1.0 * [9]/[1] * 100 as [9],
1.0 * [10]/[1] * 100 as [10],
1.0 * [11]/[1] * 100 as [11],
1.0 * [12]/[1] * 100 as [12],
1.0 * [13]/[1] * 100 as [13]
from #cohort_pivot
order by cohort_date

