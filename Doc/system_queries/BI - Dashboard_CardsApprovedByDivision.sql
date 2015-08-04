/*##################################################
  #####BI Dashboard - Approved Cards by Division####
  ##################################################*/
  
--71037: BI reporting: count of all approved PLCC accounts from Northeast last fiscal week
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET

SET @StartDate = '2014-05-25 00:00:00.0000000 +00:00'
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 1

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 1
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71532: BI reporting: count of all approved PLCC accounts from Northeast last 12 months
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET

SET @StartDate = '2013-05-25 00:00:00.0000000 +00:00'
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 1


SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 1
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)

  
--71038: BI reporting: count of all approved PLCC accounts from Central last fiscal week
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET

SET @StartDate = '2014-05-25 00:00:00.0000000 +00:00'
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 2

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 2
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71533: BI reporting: count of all approved PLCC accounts from Central last 12 months
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET

SET @StartDate = '2013-05-25 00:00:00.0000000 +00:00'
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 2

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 2
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/
  
--71039: BI reporting: count of all approved PLCC accounts from South last fiscal week
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET

SET @StartDate = '2014-05-25 00:00:00.0000000 +00:00' 
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 3

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 3
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71534: BI reporting: count of all approved PLCC accounts from South last 12 months
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET

SET @StartDate = '2013-05-25 00:00:00.0000000 +00:00' 
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 3
 
/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 3
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/
 
--71040: BI reporting: count of all approved PLCC accounts from West last fiscal week
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET

SET @StartDate = '2014-05-25 00:00:00.0000000 +00:00' 
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 4

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 4
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71535: BI reporting: count of all approved PLCC accounts from West last 12 months
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET

SET @StartDate = '2013-05-25 00:00:00.0000000 +00:00' 
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 4

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 4
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/
  
--71041: BI reporting: percentage of all approved PLCC accounts from Northeast last fiscal week
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET
DECLARE @a DECIMAL(10,5)
DECLARE @b DECIMAL(10,5)

SET @StartDate = '2014-05-25 00:00:00.0000000 +00:00' 
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT @a = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 1

SELECT @b = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID IN (1,2,3,4)

SELECT @a
SELECT @b
SELECT (@a / (@a + @b)) * 100

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 1
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
divided by
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71536: BI reporting: percentage of all approved PLCC accounts from Northeast last 12 months
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET
DECLARE @a DECIMAL(10,5)
DECLARE @b DECIMAL(10,5)

SET @StartDate = '2013-05-25 00:00:00.0000000 +00:00'
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT @a = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 1

SELECT @b = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID IN (1,2,3,4)

SELECT @a
SELECT @b
SELECT (@a / (@a + @b)) * 100

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 1
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
divided by
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71042: BI reporting: percentage of all approved PLCC accounts from Central last fiscal week
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET
DECLARE @a DECIMAL(10,5)
DECLARE @b DECIMAL(10,5)

SET @StartDate = '2014-05-25 00:00:00.0000000 +00:00'
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT @a = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 2

SELECT @b = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID IN (1,2,3,4)

SELECT @a
SELECT @b
SELECT (@a / (@a + @b)) * 100

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 2
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
divided by
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71537: BI reporting: percentage of all approved PLCC accounts from Central last 12 months
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET
DECLARE @a DECIMAL(10,5)
DECLARE @b DECIMAL(10,5)

SET @StartDate = '2013-05-25 00:00:00.0000000 +00:00' 
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT @a = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 2

SELECT @b = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID IN (1,2,3,4)

SELECT @a
SELECT @b
SELECT (@a / (@a + @b)) * 100

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 2
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
divided by
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71043: BI reporting: percentage of all approved PLCC accounts from South last fiscal week
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET
DECLARE @a DECIMAL(10,5)
DECLARE @b DECIMAL(10,5)

SET @StartDate = '2014-05-25 00:00:00.0000000 +00:00' 
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT @a = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 3

SELECT @b = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID IN (1,2,3,4)

SELECT @a
SELECT @b
SELECT (@a / (@a + @b)) * 100

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 3
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
divided by
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71538: BI reporting: percentage of all approved PLCC accounts from South last 12 months
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET
DECLARE @a DECIMAL(10,5)
DECLARE @b DECIMAL(10,5)

SET @StartDate = '2013-05-25 00:00:00.0000000 +00:00'
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT @a = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  -AND s.DivisionID = 3

SELECT @b = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID IN (1,2,3,4)

SELECT @a
SELECT @b
SELECT (@a / (@a + @b)) * 100

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 3
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
divided by
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71044: BI reporting: percentage of all approved PLCC accounts from West last fiscal week
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET
DECLARE @a DECIMAL(10,5)
DECLARE @b DECIMAL(10,5)

SET @StartDate = '2014-05-25 00:00:00.0000000 +00:00'
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT @a = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 4

SELECT @b = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID IN (1,2,3,4)

SELECT @a
SELECT @b
SELECT (@a / (@a + @b)) * 100

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 4
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
divided by
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/

--71539: BI reporting: percentage of all approved PLCC accounts from West last 12 months
DECLARE @StartDate DATETIMEOFFSET
DECLARE @EndDate DATETIMEOFFSET
DECLARE @a DECIMAL(10,5)
DECLARE @b DECIMAL(10,5)

SET @StartDate = '2013-05-25 00:00:00.0000000 +00:00'
SET @EndDate = '2014-05-31 23:59:59.9999999 +00:00'

SELECT @a = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID = 4

SELECT @b = COUNT(DISTINCT oe.OfferID)
FROM Profile.dbo.OfferEvent oe
	JOIN GSEDW.dbo.Store s
		ON oe.Source = s.StoreNumber
WHERE oe.OfferEventTypeID = 3
  AND oe.OfferEventDate BETWEEN @StartDate AND @EndDate
  AND s.DivisionID IN (1,2,3,4)

SELECT @a
SELECT @b
SELECT (@a / (@a + @b)) * 100

/*
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
	JOIN GSEDW.dbo.Store s
		ON pa.StoreID = s.StoreNumber
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 4
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
divided by
SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35
  AND pa.DateKey BETWEEN CAST(CONVERT(VARCHAR,@StartDate,112) AS INT) AND CAST(CONVERT(VARCHAR,@EndDate,112) AS INT)
*/
