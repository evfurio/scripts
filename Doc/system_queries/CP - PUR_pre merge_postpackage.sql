--Current PUR
SELECT TOP 1000
	 --PUR genesis_corp customer rows 
     c.CustomerID, c.FirstName, c.MiddleName, c.LastName, c.DOB, c.EmailAddress, c.GenderID
   , c.DateUpdated, c.DateCreated, c.MobilePhone, c.HomePhone, c.WorkPhone, c.PrimaryPhone
   , c.EmailInvalid, c.HomeStoreNumber, c.OpenIdClaimedIdentifier
     --PUR genesis_corp address rows
   , a.AddressLine1, a.AddressLine2, a.City, a.StateorProvince, a.Zip, a.Country, a.CustomerID, a.AddressTypeID
   , a.FirstName, a.LastName, a.IsDefault
FROM Profile.Stage.Genesis_Customer c WITH(NOLOCK)
	JOIN Profile.Stage.Genesis_Address a WITH(NOLOCK)
		ON c.CustomerID = a.CustomerID
ORDER BY c.CustomerID DESC

--customerID's with more than one addressID
WITH 
	MultiCustID_CTE (Count, CustomerID)
	AS
	(
	SELECT COUNT(*), CustomerID
	FROM Profile.Stage.Genesis_Address a WITH(NOLOCK)
	WHERE a.CustomerID IS NOT NULL
	GROUP BY a.CustomerID
	HAVING COUNT(*) > 1 
	)
SELECT TOP 1000 a.customerID, a.AddressID, a.FirstName, a.LastName, a.AddressLine1, a.AddressLine2
			  , a.AddressTypeID, a.City, a.StateorProvince, a.Zip, a.Country, a.IsDefault
FROM Profile.Stage.Genesis_Address a
	INNER JOIN MultiCustID_CTE
		ON a.CustomerID = MultiCustID_CTE.CustomerID
ORDER BY a.CustomerID, a.AddressID

--CustomerIds with multiple phone#'s (ie. a mobile + home + work)
--SELECT COUNT(*)
SELECT TOP 1000 c.CustomerID, c.HomePhone, c.MobilePhone, c.WorkPhone
FROM profile.Stage.Genesis_Customer c
WHERE c.MobilePhone IS NOT NULL
  AND c.HomePhone IS NOT NULL
  AND c.WorkPhone IS NOT NULL
ORDER BY c.CustomerID 
  
--customerids with multiple preferred stores
--looks like only one home store record per customer, address table doesn't contain stores

