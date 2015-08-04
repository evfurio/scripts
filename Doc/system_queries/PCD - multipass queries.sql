SELECT AccountEmail, *
FROM Stardock.dbo.tb_Accounts
WHERE AccountEmail LIKE 'jontestqa%'
  AND CreateDate <= '2012-09-15 00:00:00.000'
  AND MultipassConversionDate IS NULL
ORDER BY CreateDate DESC

SELECT a.AccountID, a.AccountEmail, a.MultipassConversionDate, p.FailedLoginAttempts, p.FirstFailedLoginAttempt, p.IsLockedOut
FROM Stardock.dbo.tb_Accounts a
	LEFT OUTER JOIN stardock.dbo.tb_AccountProperties p 
		ON a.AccountID = p.AccountID 
WHERE AccountEmail = 'jontestqa1217120835@gspctest.fav.cc'

UPDATE Stardock.dbo.tb_AccountProperties
SET tb_AccountProperties.FirstFailedLoginAttempt = '2012-12-18 04:00:00.000', IsLockedOut = '1'
WHERE AccountID = (SELECT AccountID FROM stardock.dbo.tb_Accounts WHERE AccountEmail = 'jontestqa1218120858@gspctest.fav.cc')
