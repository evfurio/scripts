SELECT ProfileID, AddressTypeID 
FROM dbo.Address AS a
GROUP BY ProfileID, AddressTypeID
HAVING SUM(ISNULL(CAST([default] AS TINYINT),0)) = 0

SELECT TOP 100 a.ProfileID
FROM Profile.dbo.Address a
GROUP BY a.ProfileID 
HAVING SUM(ISNULL(CAST([default] AS TINYINT),0)) = 3

SELECT * FROM Profile.dbo.Address a 
	JOIN Profile.dbo.Profile p
		ON a.ProfileID = p.ProfileID
WHERE a.ProfileID = 1234856809 
ORDER BY a.AddressTypeID

select top 10 * from Profile.dbo.Profile p where p.EmailAddress like '%siriban%'