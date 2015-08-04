/*#######################################################
  #####BI Dashboard - Sales per Member: PURCC Tenders####
  #######################################################*/
  
--71090: BI Reporting: transacting members last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN membership.dbo.MembershipCard mc
		ON ts.CustLoyaltyNum = mc.CardNumber
	JOIN Membership.dbo.Membership m0
		ON mc.MembershipID = m0.MembershipID
	JOIN Membership.dbo.MembershipKey mk
		ON m0.MembershipID = mk.MembershipiD
	JOIN Membership.dbo.Membership m1
		ON mk.MembershipID = m1.MembershipID
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND m1.MembershipProgramID = 3
  AND m0.MembershipStatusID IN (1,2)
  
SELECT SUM(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 143
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

--71091: BI Reporting: transacting members last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT COUNT_BIG(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts 
	JOIN membership.dbo.MembershipCard mc
		ON ts.CustLoyaltyNum = mc.CardNumber
	JOIN Membership.dbo.Membership m0
		ON mc.MembershipID = m0.MembershipID
	JOIN Membership.dbo.MembershipKey mk
		ON m0.MembershipID = mk.MembershipiD
	JOIN Membership.dbo.Membership m1
		ON mk.MembershipID = m1.MembershipID
WHERE ts.TransBusDateId BETWEEN @StartDate AND @EndDate
  AND m1.MembershipProgramID = 3
  AND m0.MembershipStatusID IN (1,2)

--71093: BI Reporting: percent used PLCC last fiscal week


--71094: BI Reporting: percent used PLCC last 12 months


--71095: BI Reporting: average spend of first transactions last fiscal week


--71096: BI Reporting: average spend of first transactions last 12 months


--71097: BI Reporting: overall basket size in dollars last fiscal week


--71098: BI Reporting: overall basket size in dollars last 12 months


--71099: BI Reporting: average basket size in units last fiscal week


--71100: BI Reporting: average basket size in units last 12 months


--71101: BI Reporting: purchase recency last fiscal week


--71102: BI Reporting: purchase recency last 12 months


--71103: BI Reporting: purchase frequency last fiscal week


--71104: BI Reporting: purchase frequency last 12 months


--71105: BI Reporting: average pre-owned spend in dollars last fiscal week


--71106: BI Reporting: average pre-owned spend in dollars last 12 months


--71109: BI Reporting: average console spend in dollars last fiscal week


--71110: BI Reporting: average console spend in dollars last 12 months


--71111: BI Reporting: average accessories spend in dollars last fiscal week


--71112: BI Reporting: average accessories spend in dollars last 12 months


--71113: BI Reporting: average DLC & POSA spend in dollars last fiscal week


--71114: BI Reporting: average DLC & POSA spend in dollars last 12 months


--71115: BI Reporting: average games spend in dollars last fiscal week


--71116: BI Reporting: average games spend in dollars last 12 months


--71117: BI Reporting: average consumer electronics spend in dollars last fiscal week


--71118: BI Reporting: average consumer electronics spend in dollars last 12 months


