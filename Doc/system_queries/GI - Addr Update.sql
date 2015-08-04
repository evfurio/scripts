CREATE TABLE ##Matching (CardId int, SubscriberId int)
CREATE NONCLUSTERED INDEX [IDX_CardId_m] ON ##Matching (CardId)

INSERT INTO ##Matching (CardId, SubscriberId)
	SELECT
		sc.CardId
		,sb.SubscriberID
	FROM dbo.gs_SubscriptionCard sc WITH(NOLOCK)
	JOIN dbo.gs_Subscriber sb WITH(NOLOCK)
		ON sc.GSCustomerNumber = sb.GSCustomerNumber
	WHERE
		   sc.StatusId = 2
		   AND -- MISSING ZIP (REQUIRED FOR BOTH PRINT AND DIGITAL)
		   (
				  Zip IS NULL
				  OR
				  ZIP = ''
		   )
		   AND CAST(TransactionDate AS DATE) >= '2014-02-20' --FIRST DATE OF IDENTIFIED PROBLEM
	GROUP BY sc.CardId, sb.SubscriberId
	HAVING COUNT(1) = 1
	

INSERT INTO ##Matching (CardId, SubscriberId)
	SELECT
		sc.CardId
		,sp.SubscriberID
	FROM dbo.gs_SubscriptionCard sc WITH(NOLOCK)
	JOIN dbo.gs_Subscription sp WITH(NOLOCK)
		ON sc.PUR = sp.CardNumber
	JOIN dbo.gs_Subscriber sb WITH(NOLOCK)
		ON sp.SubscriberID = sb.SubscriberID
		AND sc.LastName = sb.LastName
	WHERE
			sc.StatusId = 2
			AND CAST(TransactionDate AS DATE) >= '2014-02-20' --FIRST DATE OF IDENTIFIED PROBLEM
			AND sc.CardId NOT IN 
			(
				SELECT CardId FROM ##Matching
			)
		   AND -- MISSING ZIP (REQUIRED FOR BOTH PRINT AND DIGITAL)
		   (
				  Zip IS NULL
				  OR
				  ZIP = ''
		   )
	GROUP BY sc.CardId, sp.SubscriberId
	HAVING COUNT(1) = 1
	
		
INSERT INTO ##Matching (CardId, SubscriberId)
	SELECT
		sc.CardId
		,sb.SubscriberID
	FROM dbo.gs_SubscriptionCard sc WITH(NOLOCK)
	LEFT JOIN ##Matching m WITH(NOLOCK)
		ON sc.CardId = m.CardId
	JOIN dbo.gs_Subscriber sb WITH(NOLOCK)
		ON sc.LastName = sb.LastName
	JOIN dbo.gs_EmailAddress e WITH(NOLOCK)
		ON sb.SubscriberID = e.SubscriberID
		AND e.IsActive = 1
		AND sc.Email = e.EmailAddress
	WHERE
			sc.StatusId = 2
			AND m.CardId IS NULL
			AND -- MISSING ZIP (REQUIRED FOR BOTH PRINT AND DIGITAL)
			(
					Zip IS NULL
					OR
					ZIP = ''
			)
			AND CAST(TransactionDate AS DATE) >= '2014-02-20' --FIRST DATE OF IDENTIFIED PROBLEM
	GROUP BY sc.CardId, sb.SubscriberId
	HAVING COUNT(1) = 1
	


--BACKUP IN CASE OR ROLLBACK
SELECT
	sc.*
INTO dbo.SubscriptionCard_MissingAddress_Backup
FROM dbo.gs_SubscriptionCard sc (NOLOCK)
JOIN ##Matching m
	ON sc.CardId = m.CardId





UPDATE sc
SET
	sc.[Address] = a.Address1
	,sc.Address2 = a.Address2
	,sc.City = a.City
	,sc.[State] = a.[State]
	,sc.Zip = a.ZipCode
	,sc.StatusId = 9 --FOR REPROCESSING
FROM dbo.gs_SubscriptionCard sc
JOIN ##Matching m
	ON sc.CardId = m.CardId
JOIN dbo.gs_Address a
	ON m.SubscriberId = a.SubscriberID
	AND a.IsActive = 1
	AND a.Address1 IS NOT NULL
	AND a.Address1 <> ''
WHERE m.CardId IN
(
	SELECT
		m.cardId
	FROM ##Matching m
	GROUP BY m.cardid
	HAVING COUNT(1) = 1
)



DROP TABLE ##Matching


--ROLLBACK FROM TABLE BACKUP
--UPDATE sc
--SET
--	sc.[Address] = bak.[Address]
--	,sc.Address2 = bak.Address2
--	,sc.City = bak.City
--	,sc.[State] = bak.[State]
--	,sc.Zip = bak.Zip
--	,sc.StatusId = bak.StatusId
--FROM dbo.gs_SubscriptionCard sc
--JOIN SubscriptionCard_MissingAddress_Backup bak
--	ON sc.CardId = bak.CardId