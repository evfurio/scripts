--Current PUR
SELECT TOP 1000
	 --PUR genesis_corp customer rows 
     c.CustomerID, c.FirstName, c.MiddleName, c.LastName, c.DOB, c.EmailAddress, c.GenderID
   , c.DateUpdated, c.DateCreated, c.MobilePhone, c.HomePhone, c.WorkPhone, c.PrimaryPhone, c.EmailInvalid, c.HomeStoreNumber
     --PUR genesis_corp address rows
   , a.AddressLine1, a.AddressLine2, a.City, a.StateorProvince, a.Zip, a.Country, a.CustomerID, a.AddressTypeID
   , a.FirstName, a.LastName, a.IsDefault
     --PUR genesis_corp realm user rows
   , r.CustomerID, r.OpenIDClaimedIdentifier   
FROM GenesisCorp.dbo.Customer c WITH(NOLOCK)
	JOIN GenesisCorp.dbo.[Address] a WITH(NOLOCK)
		ON c.CustomerID = a.CustomerID
	JOIN GenesisCorp.dbo.RealmUser r WITH(NOLOCK)
		ON c.CustomerID = r.CustomerID
ORDER BY c.CustomerID DESC

--customerID's with more than one addressID
WITH 
	MultiCustID_CTE (Count, CustomerID)
	AS
	(
	SELECT COUNT(*), CustomerID
	FROM GenesisCorp.dbo.Address a WITH(NOLOCK)
	WHERE a.CustomerID IS NOT NULL
	GROUP BY a.CustomerID
	HAVING COUNT(*) > 1 
	)
SELECT a.customerID, a.AddressID, a.FirstName, a.LastName, a.AddressLine1, a.AddressLine2, a.AddressLine3
	 , a.AddressLine4, a.AddressTypeID, a.City, a.StateorProvince, a.Zip, a.Country, a.IsDefault
FROM GenesisCorp.dbo.Address a
	INNER JOIN MultiCustID_CTE
		ON a.CustomerID = MultiCustID_CTE.CustomerID
	JOIN GenesisCorp.dbo.RealmUser r
		ON MultiCustID_CTE.CustomerID = r.CustomerID
ORDER BY a.CustomerID, a.AddressID

--CustomerIds with multiple phone#'s (ie. a mobile + home + work)
--SELECT COUNT(*)
SELECT TOP 100 *
FROM GenesisCorp.dbo.Customer c
	JOIN GenesisCorp.dbo.RealmUser r
		ON c.CustomerID = r.CustomerID
WHERE c.MobilePhone IS NOT NULL
  AND c.HomePhone IS NOT NULL
  AND c.WorkPhone IS NOT NULL
  
--customerids with multiple preferred stores
--looks like only one home store record per customer, address table doesn't contain stores

