/*###############################################
  ####BI Dashboard - GME Trx Pen.: CC Tenders####
  ###############################################*/
  
--71777: BI Reporting: total transactions store and online last fiscal week
DECLARE @StartDate BIGINT
DECLARE @EndDate BIGINT

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


--71778: BI Reporting: total transactions store and online last 12 months
DECLARE @StartDate BIGINT
DECLARE @EndDate BIGINT

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


--71045: BI Reporting: total transactions store last fiscal week
DECLARE @StartDate BIGINT
DECLARE @EndDate BIGINT

SET @StartDate = '20140525'
SET @EndDate = '20140531'
  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71046: BI Reporting: total transactions store last 12 months
DECLARE @StartDate BIGINT
DECLARE @EndDate BIGINT

SET @StartDate = '20130525'
SET @EndDate = '20140531'
  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71047: BI Reporting: total transactions online last fiscal week
DECLARE @StartDate BIGINT
DECLARE @EndDate BIGINT

SET @StartDate = '20140525'
SET @EndDate = '20140531'
  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum = 480
  AND tt.TenderType IN (3,4,5,6,16,17)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71048: BI Reporting: total transactions online last 12 months
DECLARE @StartDate BIGINT
DECLARE @EndDate BIGINT

SET @StartDate = '20130525'
SET @EndDate = '20140531'
  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum = 480
  AND tt.TenderType IN (3,4,5,6,16,17)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71049: BI Reporting: total percent in-store transactions last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
  )

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType <> 18
)
SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 103
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71050: BI Reporting: total percent in-store transactions last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
  )

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType <> 18 
)
SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 103
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71051: BI Reporting: total percent online transactions last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum = 480
  AND tt.TenderType IN (3,4,5,6,16,17)
  )

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum = 480
  AND tt.TenderType <> 18
)
SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 104
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71052: BI Reporting: total percent online transactions last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum = 480
  AND tt.TenderType IN (3,4,5,6,16,17)
  )

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum = 480
  AND tt.TenderType <> 18
)
SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 104
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71053: BI Reporting: total percent CC tenders that are swiped entry last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
	JOIN GSEDW.sales.CreditCardFct cf
		ON ts.SalesTransHeaderId = cf.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
  AND cf.ScanManualFlag = 'S'
  )

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
)
SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 105
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71054: BI Reporting: total percent CC tenders that are swiped entry last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
	JOIN GSEDW.sales.CreditCardFct cf
		ON ts.SalesTransHeaderId = cf.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
  AND cf.ScanManualFlag = 'S'
  )

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
)
SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 105
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71055: BI Reporting: total percent CC tenders that are manual entry last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
	JOIN GSEDW.sales.CreditCardFct cf
		ON ts.SalesTransHeaderId = cf.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
  AND cf.ScanManualFlag = 'M'
  )

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
)
SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 108
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71056: BI Reporting: total percent CC tenders that are manual entry last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (  
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt 
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
	JOIN GSEDW.sales.CreditCardFct cf
		ON ts.SalesTransHeaderId = cf.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
  AND cf.ScanManualFlag = 'M'
  )

SELECT @b = (
SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.StoreNum <> 480
  AND tt.TenderType IN (3,4,5,6,16,17)
)
SELECT @a
SELECT @b
SELECT (@a / @b) * 100


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 108
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71057: BI Reporting: total percent pre-owned transactions last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode = 015 --used
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 113
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71058: BI Reporting: total percent pre-owned transactions last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 113
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71059: BI Reporting: total percent console transactions last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 116
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71060: BI Reporting: total percent console transactions last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 116
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71061: BI Reporting: total percent accessories transactions last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (021,025,028,319) --accessories
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 119
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71062: BI Reporting: total percent accessories transactions last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (021,025,028,319) --accessories
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 119
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71063: BI Reporting: total percent DLC & POSA transactions last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (007,009) --dlc & posa
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 122
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71064: BI Reporting: total percent DLC & POSA transactions last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (007,009) --dlc & posa
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 122
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71065: BI Reporting: total percent games transactions last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode = 004 --video games
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 125
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71066: BI Reporting: total percent games transactions last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode = 004 --video games
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 125
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71067: BI Reporting: total percent consumer electronics transactions last fiscal week
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (046, 328) --consumer electronics
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


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 128
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71068: BI Reporting: total percent consumer electronics transactions last 12 months
DECLARE @a BIGINT
DECLARE @b BIGINT
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT @a = (
SELECT COUNT_BIG(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts
	JOIN GSEDW.sales.TransLine tl
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk 
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductDescHistory ph
		ON pk.DescHistoryKey = ph.PIDescHistoryKey
	JOIN GSEDW.dbo.ProductReportingCategory prc
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt
		ON ts.SalesTransHeaderId = tt.SalesTransHeaderId
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND prc.Level2CategoryCode IN (046, 328) --consumer electronics
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



SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 128
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--divided by
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 102
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
--+
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 180
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
