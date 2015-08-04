SELECT TOP 1000 *
FROM Multipass.dbo.IssuedUser
WHERE EmailAddress LIKE 'jontestqa+%' 

SELECT TOP 1000 *
FROM Multipass.dbo.IssuedUser
WHERE EmailAddress = 'jontestqa1031121240@gspctest.fav.cc'
  
SELECT TOP 1000 EmailAddress, LastLoginAttempt, LoginAttemptCount, CreatedDate, LockedForLogin 
FROM Multipass.dbo.IssuedUser
WHERE EmailAddress = 'jontestqa1031121310@gspctest.fav.cc' 