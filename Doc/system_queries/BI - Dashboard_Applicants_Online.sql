/*##################################################
  ########BI Dashboard - Applicants Online##########
  ##################################################*/
  
--71775: BI reporting: total online unique visits by pur members last fiscal week
/*
--vertica
SELECT COUNT(CNT) FROM (
SELECT DISTINCT(VISID_HIGH||VISID_LOW||VISIT_NUM) as CNT
FROM OM.OmnitureNew WHERE DATE(DATE_TIME) BETWEEN '05/25/2014' AND '05/31/2014' AND POST_EVAR30 IS NOT NULL
UNION DISTINCT
SELECT DISTINCT(VISID_HIGH||VISID_LOW||VISIT_NUM) as CNT
FROM OM.OmnitureMobileNew 
WHERE DATE(DATE_TIME) BETWEEN '05/25/2014' AND '05/31/2014' AND POST_EVAR30 IS NOT NULL ) T1
*/

DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 53
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71776: BI reporting: total online unique visits by pur members last 12 months
/*
--vertica
SELECT COUNT(CNT) FROM (
SELECT DISTINCT(VISID_HIGH||VISID_LOW||VISIT_NUM) as CNT
FROM OM.OmnitureNew WHERE DATE(DATE_TIME) BETWEEN '05/31/2013' AND '05/31/2014' AND POST_EVAR30 IS NOT NULL
UNION DISTINCT
SELECT DISTINCT(VISID_HIGH||VISID_LOW||VISIT_NUM) as CNT
FROM OM.OmnitureMobileNew 
WHERE DATE(DATE_TIME) BETWEEN '05/31/2013' AND '05/31/2014' AND POST_EVAR30 IS NOT NULL ) T1
*/

DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 53
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71017: BI reporting: total online applications last fiscal week
/*
--vertica
 SELECT COUNT(CNT) FROM (
        SELECT count(DISTINCT(POST_EVAR30)) as CNT 
        FROM OM.OmnitureNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/25/2014' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation short form approve','purcc: confirmation short form defer')
        UNION DISTINCT
        SELECT count(DISTINCT(POST_EVAR30)) as CNT
        FROM OM.OmnitureMobileNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/25/2014' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation short form approve','purcc: confirmation short form defer')
        ) T1
        +
        SELECT COUNT(CNT) FROM (
        SELECT count(DISTINCT(POST_EVAR30)) as CNT 
        FROM OM.OmnitureNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/25/2014' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation long form defer')
        UNION DISTINCT
        SELECT count(DISTINCT(POST_EVAR30)) as CNT
        FROM OM.OmnitureMobileNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/25/2014' AND '05/31/2014'   
        and PAGENAME in ('purcc: confirmation long form defer')
        ) T1
*/
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 54
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71018: BI reporting: total online applications last 12 months
/*
--vertica
 SELECT COUNT(CNT) FROM (
        SELECT count(DISTINCT(POST_EVAR30)) as CNT 
        FROM OM.OmnitureNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/31/2013' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation short form approve','purcc: confirmation short form defer')
        UNION DISTINCT
        SELECT count(DISTINCT(POST_EVAR30)) as CNT
        FROM OM.OmnitureMobileNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/31/2013' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation short form approve','purcc: confirmation short form defer')
        ) T1
        +
        SELECT COUNT(CNT) FROM (
        SELECT count(DISTINCT(POST_EVAR30)) as CNT 
        FROM OM.OmnitureNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/31/2013' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation long form defer')
        UNION DISTINCT
        SELECT count(DISTINCT(POST_EVAR30)) as CNT
        FROM OM.OmnitureMobileNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/31/2013' AND '05/31/2014'   
        and PAGENAME in ('purcc: confirmation long form defer')
        ) T1
*/

DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 54
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71019: BI reporting: total pre-approved members last fiscal week
/*
--vertica
SELECT COUNT(CNT) FROM (
        SELECT count(DISTINCT(POST_EVAR30)) as CNT 
        FROM OM.OmnitureNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/25/2014' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation short form approve','purcc: confirmation short form defer','purcc: confirmation long form defer')
        UNION DISTINCT
        SELECT count(DISTINCT(POST_EVAR30)) as CNT
        FROM OM.OmnitureMobileNew 
        WHERE   DATE(DATE_TIME)  BETWEEN '05/25/2014' AND '05/31/2014' 
        and PAGENAME in ('purcc: confirmation short form approve','purcc: confirmation short form defer','purcc: confirmation long form defer')
        ) T1
*/

DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 55
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71020: BI reporting: total preapproved members last 12 months
/*
--vertica
SELECT COUNT(CNT) FROM (
        SELECT count(DISTINCT(POST_EVAR30)) as CNT 
        FROM OM.OmnitureNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/31/2013' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation short form approve','purcc: confirmation short form defer','purcc: confirmation long form defer')
        UNION DISTINCT
        SELECT count(DISTINCT(POST_EVAR30)) as CNT
        FROM OM.OmnitureMobileNew 
        WHERE   DATE(DATE_TIME)  BETWEEN '05/31/2013' AND '05/31/2014' 
        and PAGENAME in ('purcc: confirmation short form approve','purcc: confirmation short form defer','purcc: confirmation long form defer')
        ) T1
*/

DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 55
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71021: BI reporting: total non-pre-approved members last fiscal week
/*
--vertica
SELECT COUNT(CNT) FROM (
        SELECT count(DISTINCT(POST_EVAR30)) as CNT 
        FROM OM.OmnitureNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/25/2014' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation long form defer')
        UNION DISTINCT
        SELECT count(DISTINCT(POST_EVAR30)) as CNT
        FROM OM.OmnitureMobileNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/25/2014' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation long form defer')
        ) T1
*/

DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 56
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71022: BI reporting: total non-pre-approved members last 12 months
/*
--vertica
SELECT COUNT(CNT) FROM (
        SELECT count(DISTINCT(POST_EVAR30)) as CNT 
        FROM OM.OmnitureNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/31/2013' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation long form defer')
        UNION DISTINCT
        SELECT count(DISTINCT(POST_EVAR30)) as CNT
        FROM OM.OmnitureMobileNew 
        WHERE   DATE(DATE_TIME) BETWEEN '05/31/2013' AND '05/31/2014'  
        and PAGENAME in ('purcc: confirmation long form defer')
        ) T1
*/

DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 56
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71023: BI reporting: total approved by ADS last fiscal week
/*
--vertica

*/


DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 57
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71024: BI reporting: total approved by ADS last 12 months
/*
--vertica

*/


DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 57
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71025: BI reporting: total declined by ADS last fiscal week
/*
--vertica

*/


DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 58
  AND pm.DateKey BETWEEN @StartDate AND @EndDate


--71026: BI reporting: total declined by ADS last 12 months
/*
--vertica

*/


DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130531'
SET @EndDate = '20140531'

SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 58
  AND pm.DateKey BETWEEN @StartDate AND @EndDate
