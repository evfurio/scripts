/*##################################################
  ########BI Dashboard - Applicants In Store########
  ##################################################*/
  
--71003: BI reporting: powerup transactions last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.CustLoyaltyNum IS NOT NULL
  AND ts.StoreNum <> 480
  

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 19
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71004: BI reporting: powerup transactions last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND ts.CustLoyaltyNum IS NOT NULL
  AND ts.StoreNum <> 480  


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 19
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--72035: BI reporting: POS offered transactions GA last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 21
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--72036: BI reporting: POS offered transactions GA last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 21
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71007: BI reporting: POS offered ignored by GA last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID IN (5, 8)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 23
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71008: BI reporting: POS offered ignored by GA last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID IN (5, 8)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 23
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71009: BI reporting: POS offered skipped by customer last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID IN (2, 10)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 25
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71010: BI reporting: POS offered skipped by customer last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID IN (2, 10)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 25
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71011: BI reporting: POS offered rejected by customer last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID IN (1, 9)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 27
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71012: BI reporting: POS offered rejected by customer last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID IN (1, 9)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 27
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71013: BI reporting: POS offered applied by customer and ADS approved last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID in (3,4)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 29
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71014: BI reporting: POS offered applied by customer and ADS approved last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID in (3,4)


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 29
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71016: BI reporting: POS offered applied by customer and ADS rejected last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID = 4


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 33
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71015: BI reporting: POS offered applied by customer and ADS rejected last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID = 4


SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 33
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

