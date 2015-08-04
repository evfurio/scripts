SELECT COUNT(a.CustomerID), a.AccountID, a.AccountEmail
FROM Stardock.dbo.tb_Accounts a
	JOIN Stardock.dbo.tb_Customer c
		ON a.CustomerID = c.CustomerID
GROUP BY a.AccountID, a.AccountEmail
HAVING COUNT(a.CustomerID) > 1

SELECT COUNT(c.CustomerID), c.EMail
FROM Stardock.dbo.tb_Customer c
WHERE c.EMail IS NOT NULL 
  AND c.EMail <> ''
GROUP BY c.EMail 
HAVING COUNT(c.CustomerID) > 1

SELECT * FROM Stardock.dbo.tb_Customer WHERE EMail = 'snguitest+12345NOFRAUD+082412@gmail.com'


CREATE TABLE #MultCustIDs (NumCustIDs INT, Email NVARCHAR(MAX))

INSERT INTO #MultCustIDs (NumCustIDs, Email)

	SELECT COUNT(c.CustomerID), c.EMail
	FROM Stardock.dbo.tb_Customer c
	WHERE c.EMail IS NOT NULL 
	  AND c.EMail <> ''
	GROUP BY c.EMail
	HAVING COUNT(*) > 1

SELECT * 
FROM stardock.dbo.tb_Accounts a
	JOIN #MultCustIDs m
		ON a.AccountEmail = m.Email
	JOIN Stardock.dbo.tb_Registration r
		ON a.CustomerID = r.CustomerID
ORDER BY m.Email		
		
DROP TABLE #MultCustIDs