
SELECT TOP 1000 
	   gc.CustomerID, gc.EmailAddress
	 , ru.RealmUserID
	 , mi.OpenIDClaimedIdentifier, mi.EmailAddress, mi.CreatedDate

FROM GenesisCorp.dbo.Customer gc WITH(NOLOCK)
	JOIN GenesisCorp.dbo.RealmUser ru WITH(NOLOCK)
		ON gc.CustomerID = ru.CustomerID
	JOIN Multipass.dbo.IssuedUser mi WITH(NOLOCK)
		ON ru.OpenIDClaimedIdentifier = mi.OpenIDClaimedIdentifier
	