/*##################################################
  ########BI Dashboard - Member Card  Holders#######
  ##################################################*/
  
--70984: BI Reporting: total powerup members
SELECT COUNT(membershipid)
FROM Membership.dbo.Membership

SELECT MAX(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 2 

--70985: BI Reporting: total PURCC pre-approved prospects
SELECT COUNT(*)
FROM profile.dbo.ProfileEvent pe
WHERE pe.EventTypeID = 2

SELECT MAX(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 60 

--70986: BI Reporting: total active PURCC members count
SELECT COUNT(m.MembershipID)
FROM Membership.dbo.Membership m
WHERE m.MembershipStatusID IN (1,2)
  AND m.MembershipProgramID = 3

SELECT MAX(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4

--70987: BI Reporting: total active PLCC members percentage
SELECT
CONVERT(DECIMAL(10,2),(
ROUND(
(CAST((SELECT COUNT(m.MembershipID)
FROM Membership.dbo.Membership m
WHERE m.MembershipStatusID IN (1,2)
  AND m.MembershipProgramID = 3)AS DECIMAL))
/
CAST((SELECT COUNT(membershipid)
FROM Membership.dbo.Membership)AS DECIMAL)
*
100, 2)))

SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 2
ORDER BY pm.DateKey DESC


--70988: BI Reporting: total are pro members count
WITH PURCC_CTE AS (
		SELECT 
			mk.MembershipKeyID
			,m.MembershipID
			,m.MembershipProgramID
			,m.MembershipStatusID
		FROM membership.dbo.MembershipKey mk
			JOIN Membership.dbo.Membership m
				ON mk.MembershipID = m.MembershipID AND m.MembershipStatusID IN (1,2)
		WHERE m.MembershipProgramID = 2
	UNION ALL
		SELECT 
			mk1.MembershipKeyID
			,m1.MembershipID
			,m1.MembershipProgramID
			,m1.MembershipStatusID
		FROM PURCC_CTE cte
			JOIN Membership.dbo.MembershipKey mk1
				ON cte.MembershipKeyID = mk1.MembershipKeyID
			JOIN Membership.dbo.Membership m1
				ON mk1.MembershipID = m1.MembershipID AND m1.MembershipProgramID = 3 and m1.MembershipStatusID IN (1,2)
		WHERE cte.MembershipProgramID = 2 
)
SELECT COUNT(DISTINCT MembershipKeyID) FROM PURCC_CTE WHERE MembershipProgramID = 3

SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 6
ORDER BY pm.DateKey DESC


--70889: BI Reporting: total pro members percentage
DECLARE @a DECIMAL(10,5)
DECLARE @b DECIMAL(10,5)

;WITH PURCC_CTE AS (
		SELECT 
			mk.MembershipKeyID
			,m.MembershipID
			,m.MembershipProgramID
			,m.MembershipStatusID
		FROM membership.dbo.MembershipKey mk
			JOIN Membership.dbo.Membership m
				ON mk.MembershipID = m.MembershipID AND m.MembershipStatusID IN (1,2)
		WHERE m.MembershipProgramID = 2
	UNION ALL
		SELECT 
			mk1.MembershipKeyID
			,m1.MembershipID
			,m1.MembershipProgramID
			,m1.MembershipStatusID
		FROM PURCC_CTE cte
			JOIN Membership.dbo.MembershipKey mk1
				ON cte.MembershipKeyID = mk1.MembershipKeyID
			JOIN Membership.dbo.Membership m1
				ON mk1.MembershipID = m1.MembershipID AND m1.MembershipProgramID = 3 and m1.MembershipStatusID IN (1,2)
		WHERE cte.MembershipProgramID = 2 
)
SELECT @a = COUNT(DISTINCT MembershipKeyID) FROM PURCC_CTE WHERE MembershipProgramID = 3

;WITH PURCC_CTE AS (
		SELECT 
			mk.MembershipKeyID
			,m.MembershipID
			,m.MembershipProgramID
		FROM membership.dbo.MembershipKey mk
			JOIN Membership.dbo.Membership m
				ON mk.MembershipID = m.MembershipID
		WHERE m.MembershipProgramID = 1
	UNION ALL
		SELECT 
			mk1.MembershipKeyID
			,m1.MembershipID
			,m1.MembershipProgramID
		FROM PURCC_CTE c
			JOIN Membership.dbo.MembershipKey mk1
				ON c.MembershipKeyID = mk1.MembershipKeyID
			JOIN Membership.dbo.Membership m1
				ON mk1.MembershipID = m1.MembershipID
				AND m1.MembershipProgramID = 3
			WHERE
				c.MembershipProgramID = 1
)
SELECT @b = COUNT(DISTINCT MembershipKeyID) FROM PURCC_CTE WHERE MembershipProgramID = 3
SELECT @a
SELECT @b
SELECT (@a / (@a + @b)) * 100


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 6
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC


--70990: BI Reporting: total credit granted
--also may be dependent on ADS monthly file
SELECT SUM(o.CreditLimit)
FROM Profile.dbo.Offer o
WHERE o.CreditLimit IS NOT NULL


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 8
ORDER BY pm.DateKey DESC


--70991: BI Reporting: total credit granted per member
--also may be dependent on ADS monthly file
SELECT
CAST((SELECT SUM(o.CreditLimit)
FROM Profile.dbo.Offer o
WHERE o.CreditLimit IS NOT NULL)AS DECIMAL)
/
CAST((SELECT COUNT(*)
FROM profile.dbo.ProfileEvent pe
WHERE pe.EventTypeID = 3)AS DECIMAL)


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 8
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC


--70992: BI Reporting: total credit open to buy
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 12
ORDER BY pm.DateKey DESC


--70993: BI Reporting: total credit open to buy percentage
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 12
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 8
ORDER BY pm.DateKey DESC


--70994: BI Reporting: total credit open to buy per member
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 12
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC


--70995: BI Reporting: total credit open to buy percentage per member
--dependent on ADS monthly file


(SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 12
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC)
--divided by
(SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 8
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC)


--70996: BI Reporting: total credit used/spent
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 8
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 12
ORDER BY pm.DateKey DESC


--70997: BI Reporting: total credit used/spent percentage
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 10
ORDER BY pm.DateKey DESC


--70998: BI Reporting: total credit used/spent per member
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 10
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC


--70999: BI Reporting: total credit used/spent percentage per member
--dependent on ADS monthly file


(SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 10
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC)
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 8
ORDER BY pm.DateKey DESC


--70100: BI Reporting: number of cards at greater than or equal to 75 percent of open credit
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 14
ORDER BY pm.DateKey DESC


--72019: BI Reporting: number of cards at greater than or equal to 75 percent of open credit
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 14
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC


--70101: BI Reporting: number of cards at  26 to 74 percent of open credit
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 16
ORDER BY pm.DateKey DESC


--72020: BI Reporting: percentage of cards at 26 to 74 percent of open credit
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 16
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC


--70102: Reporting: number of cards less than or equal to 25 percent of open credit
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 18
ORDER BY pm.DateKey DESC


--72021: Reporting: percentage of cards less than or equal to 25 percent of open credit
--dependent on ADS monthly file


SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 18
ORDER BY pm.DateKey DESC
--divided by
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 4
ORDER BY pm.DateKey DESC
