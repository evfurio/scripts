/*#######################################################
  #####BI Dashboard - Tender per Trx: Other CC Tenders###
  #######################################################*/
  
--71071: BI Reporting: total tendering transactions last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'
  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
    

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71072: BI Reporting: total tendering transactions last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'
  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
  

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
  
--71075: BI Reporting: average basket dollar tendered last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT
DECLARE @a BIGINT
DECLARE @b BIGINT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
  )
  
SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)  

SELECT @a
SELECT @b
SELECT @a / @b


SELECT SUM(pm.AnalysisAmount) / SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 131
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71076: BI Reporting: average basket dollar tendered last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT
DECLARE @a BIGINT
DECLARE @b BIGINT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
  )
  
SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)  

SELECT @a
SELECT @b
SELECT @a / @b


SELECT SUM(pm.AnalysisAmount) / SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 131
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71077: BI Reporting: average pre-owned tender in dollars last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (012, 015) --used
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 133
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71078: BI Reporting: average pre-owned tender in dollars last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (012, 015) --used
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 133
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71080: BI Reporting: average console tender in dollars last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.ReportingCategoryCode IN (086,089,092,118,120,122,124,127,130,330,332,335,340,343,346,352,355,356) --console
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 135
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71081: BI Reporting: average console tender in dollars last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.ReportingCategoryCode IN (086,089,092,118,120,122,124,127,130,330,332,335,340,343,346,352,355,356) --console
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 135
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71082: BI Reporting: average accessories tender in dollars last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level3CategoryCode IN (021,025,028,319) --accessories
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 137
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71083: BI Reporting: average accessories tender in dollars last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level3CategoryCode IN (021,025,028,319) --accessories
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 137
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71084: BI Reporting: average DLC & POSA tender in dollars last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (007,009) --DLC & POSA
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 139
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71085: BI Reporting: average DLC & POSA tender in dollars last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (007,009) --DLC & POSA
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 139
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71086: BI Reporting: average games tender in dollars last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(CAST(tt.TenderAmt AS BIGINT)) 
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level1CategoryCode = 004 --games
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 141
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71087: BI Reporting: average games tender in dollars last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level1CategoryCode = 004 --games
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 141
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71088: BI Reporting: average consumer electronics tender in dollars last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(tt.TenderAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level4CategoryCode IN (046,328) --Consumer electronics
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 181
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71089: BI Reporting: average consumer electronics tender in dollars last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT @a = (
SELECT SUM(ts.PurchaseAmt)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level4CategoryCode IN (046,328) --Consumer electronics
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND tt.TenderType IN (3,4,5,6,16,17)
)

SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisAmount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 181
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID IN (102,180)
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

