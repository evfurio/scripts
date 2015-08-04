/*staging data*/

--ecom
SELECT COUNT(*) FROM Profile.stage.Ecom_UserObject WITH(NOLOCK) --3634135 (matches gs_profile db users with openid)
SELECT COUNT(*) FROM profile.stage.Ecom_Addresses WITH(NOLOCK) --32942 (matches gs_addresses type <> 2)
SELECT COUNT(*) FROM profile.stage.Invalid_Ecom_Address WITH(NOLOCK) --0
--pur
SELECT COUNT(*) FROM profile.stage.Genesis_Customer WITH(NOLOCK) --88710
SELECT COUNT(*) FROM profile.Stage.Genesis_Address WITH(NOLOCK) --79683
SELECT COUNT(*) FROM profile.stage.Invalid_Genesis_Address WITH(NOLOCK) --3865
SELECT COUNT(*) FROM Profile.stage.Invalid_Genesis_Customer WITH(NOLOCK) --497
--store and zipcode moved to stage for reference

 /*data cleanup*/
 
--genesiscorp records with no email addr moved from stage to invalid_genesis_customers
SELECT COUNT(*) FROM profile.stage.Invalid_Genesis_Customer WITH(NOLOCK) WHERE EmailAddress IS NOT NULL --460
SELECT COUNT(*) FROM profile.stage.Genesis_Customer WITH(NOLOCK) WHERE EmailAddress IS NULL --0
SELECT COUNT(*) FROM Profile.Stage.Genesis_Customer WITH(NOLOCK) WHERE LEN(RTRIM(LTRIM(EmailAddress))) = 0 --0
--genesiscorp addresses with no city, state, country
SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE City IS NULL --0
SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE StateorProvince IS NULL --0
SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE Country IS NULL --0

SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE LEN(RTRIM(LTRIM(City))) = 0 --0
SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE LEN(RTRIM(LTRIM(StateorProvince))) = 0 --0
SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE LEN(RTRIM(LTRIM(Country))) = 0 --0

--multiple membership id's for a customer
SELECT COUNT(*), MembershipID 
FROM profile.stage.Genesis_Customer WITH(NOLOCK) 
GROUP BY MembershipID 
HAVING COUNT(*) > 1

--genesiscorp addresses missing either city, line1, zip or state moved to invalid_genesis_addr
WITH Inv_gen_Addr_CTE AS
	(SELECT AddressID FROM Profile.Stage.Invalid_Genesis_Address WITH(NOLOCK) WHERE City IS NULL
	 UNION ALL
	 SELECT AddressID FROM Profile.Stage.Invalid_Genesis_Address WITH(NOLOCK) WHERE AddressLine1 IS NULL
	 UNION ALL
	 SELECT AddressID FROM Profile.Stage.Invalid_Genesis_Address WITH(NOLOCK) WHERE Zip IS NULL
	 UNION ALL
	 SELECT AddressID FROM Profile.Stage.Invalid_Genesis_Address WITH(NOLOCK) WHERE StateAbbr IS NULL)
SELECT *--COUNT(*)
FROM Inv_gen_Addr_CTE inv
	JOIN profile.dbo.Address val WITH(NOLOCK) 
		on inv.AddressID = val.AddressID
		
--ecom addr's deleted with word 'delete' in line1 field
SELECT * FROM Profile.stage.Ecom_Addresses WITH(NOLOCK) WHERE u_address_line1 LIKE '%delete%' --0

--ecom addr's with country = US either no city, state
SELECT COUNT(*) FROM profile.stage.Ecom_Addresses WITH (NOLOCK) WHERE u_country_code = 'US' AND u_city IS NULL --0
SELECT * /*COUNT(*)*/ FROM profile.stage.Ecom_Addresses WITH (NOLOCK) WHERE u_country_code = 'US' AND u_region_code IS NULL --2

--ecom addresses missing either city, line1, zip or state moved to invalid_ecom_addr
WITH Inv_ecom_Addr_CTE AS
	(SELECT * FROM Profile.Stage.Ecom_Addresses WITH(NOLOCK) WHERE u_city IS NULL
	 UNION ALL
	 SELECT * FROM Profile.Stage.Ecom_Addresses WITH(NOLOCK) WHERE u_address_line1 IS NULL
	 UNION ALL
	 SELECT * FROM Profile.Stage.Ecom_Addresses WITH(NOLOCK) WHERE u_postal_code IS NULL
	 UNION ALL
	 SELECT * FROM Profile.Stage.Ecom_Addresses WITH(NOLOCK) WHERE u_region_code IS NULL)
SELECT COUNT(*)
FROM Inv_ecom_Addr_CTE inv
	JOIN profile.dbo.Address val WITH(NOLOCK)
		on inv.u_address_id = val.AddressID
		
--gencorp customer records still exist in both profile stage cust/gencorp customer
WITH GC_CTE AS
(
SELECT c.CustomerID
FROM GenesisCorp.dbo.Customer c
	JOIN GenesisCorp.dbo.RealmUser ru
		ON c.CustomerID = ru.CustomerID
WHERE c.DateCreated < '2013-08-07 00:10:00' 
  AND ru.CreatedDate < '2013-08-07 00:10:00' 
  AND c.EmailAddress IS NOT NULL
)
SELECT gc.CustomerID
FROM profile.Stage.Genesis_Customer gc
	INNER JOIN GC_CTE cte
		ON gc.CustomerID = cte.CustomerID
		
-- stage gencorp addresses attached to customers
WITH ADD_CTE AS
(
SELECT a.AddressID
FROM GenesisCorp.dbo.Customer c
	JOIN GenesisCorp.dbo.RealmUser ru
		ON c.CustomerID = ru.CustomerID
	JOIN GenesisCorp.dbo.Address a
		ON c.CustomerID = a.CustomerID
WHERE c.DateCreated < '2013-08-07 00:00:00'
  AND ru.CreatedDate < '2013-08-07 00:00:00'
) 
SELECT ga.AddressID
FROM profile.Stage.Genesis_Address ga
	INNER JOIN ADD_CTE cte
		ON ga.AddressID = cte.AddressID
		
--blank email addresses not moved from stage to invalid customer table
WITH Cust_CTE AS
(
SELECT TOP 1000 c.CustomerID, c.EmailAddress
FROM Profile.Stage.Genesis_Customer c 
	JOIN Profile.dbo.Profile p
		ON c.CustomerID = p.ProfileID
	JOIN Profile.KeyMap.CustomerKey ck
		ON p.ProfileID = ck.ProfileID
WHERE c.EmailAddress = '' 
)
SELECT *
FROM profile.Stage.Invalid_Genesis_Customer ic
	JOIN Cust_CTE cte
		ON  ic.CustomerID = cte.CustomerID

