----pur only customer
--SELECT TOP 1000 *
--FROM profile.stage.Genesis_Customer c WITH(NOLOCK)
--	LEFT OUTER JOIN profile.Stage.Ecom_UserObject u WITH(NOLOCK)
--		ON c.OpenIdClaimedIdentifier = u.u_account_id
--WHERE c.EmailAddress NOT LIKE '{%'
--  AND u.u_account_id IS NULL
--  AND c.OpenIdClaimedIdentifier LIKE 'https://%'
--ORDER BY c.EmailAddress
		
----ecom only customer
--SELECT TOP 1000 *
--FROM Profile.Stage.Ecom_UserObject u WITH(NOLOCK)
--	LEFT OUTER JOIN profile.stage.Genesis_Customer c WITH(NOLOCK)
--		ON u.u_account_id = c.OpenIdClaimedIdentifier
--WHERE u.u_email_address NOT LIKE '{%'
--  AND c.OpenIdClaimedIdentifier IS NULL
--  AND u.u_account_id LIKE 'https://%'
--ORDER BY u.u_email_address

----customer lookup in stage/profile/customerkeymap
--DECLARE @EmailAddr NVARCHAR(100)

--SET @EmailAddr = '13norbe@gmail.com'

--SELECT * FROM profile.stage.Genesis_Customer WITH(NOLOCK) WHERE EmailAddress = @EmailAddr
--SELECT * FROM profile.stage.Ecom_UserObject WITH(NOLOCK) WHERE u_email_address = @EmailAddr
--SELECT * FROM profile.dbo.Profile WITH(NOLOCK) WHERE EmailAddress = @EmailAddr
--SELECT c.* 
--FROM Profile.KeyMap.CustomerKey c WITH(NOLOCK) 
--	JOIN Profile.dbo.Profile p WITH(NOLOCK) 
--		ON c.ProfileID = p.ProfileID
--WHERE p.EmailAddress = @EmailAddr 

/*### pur ###*/

--pur with multiple addresses
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
FROM Profile.Stage.Genesis_Address a WITH(NOLOCK)
	INNER JOIN MultiCustID_CTE
		ON a.CustomerID = MultiCustID_CTE.CustomerID
ORDER BY a.CustomerID, a.AddressID

--pur address consolidated
DECLARE @CustID INT
SET @CustID = 1002771487
SELECT p.ProfileID, a.[default], a.AddressID, a.AddressTypeID , a.Line1, a.Line2, a.City, a.PostalCode, a.RecipientFirstName, a.RecipientLastName
FROM profile.dbo.Profile p WITH(NOLOCK)
	JOIN profile.dbo.Address a WITH(NOLOCK)
		ON p.ProfileID = a.ProfileID
WHERE p.customerid_tmp = @CustID

--pur with multiple phone
SELECT TOP 1000 c.CustomerID, c.HomePhone, c.MobilePhone, c.WorkPhone
FROM profile.Stage.Genesis_Customer c WITH(NOLOCK)
WHERE c.MobilePhone IS NOT NULL
  AND c.HomePhone IS NOT NULL
  AND c.WorkPhone IS NOT NULL
ORDER BY c.CustomerID 

-- pur phone consolidated
DECLARE @custID INT
SET @custID = 1003885774
SELECT TOP 10 p.customerid_tmp, ph.*
FROM Profile.dbo.Profile p WITH(NOLOCK)
	JOIN Profile.dbo.Phone ph WITH(NOLOCK)
		ON p.ProfileID = ph.ProfileID
WHERE p.customerid_tmp = @custID

--pur with home store
SELECT c.CustomerID, c.EmailAddress, c.HomeStoreNumber
FROM profile.Stage.Genesis_Customer c WITH(NOLOCK)
WHERE c.HomeStoreNumber IS NOT NULL

--pur home store on new profile
DECLARE @CustID INT
SET @CustID = 1002824672
SELECT c.CustomerID, c.EmailAddress, c.HomeStoreNumber, ps.*
FROM profile.stage.Genesis_Customer c WITH(NOLOCK)
	JOIN profile.dbo.Profile p WITH(NOLOCK)
		ON c.CustomerID = p.customerid_tmp
	JOIN profile.dbo.PreferredStore ps WITH(NOLOCK)
		ON p.ProfileID = ps.ProfileID
WHERE c.CustomerID = @CustID

/*### ecom ###*/

--ecom with multiple addresses

--4 addresses per account from ecom stage
WITH 
	MultiUserID_CTE (addressIDs, parsed_addr_id1, parsed_addr_id2, parsed_addr_id3, parsed_addr_id4, parsed_addr_id5
							   , parsed_addr_id6, parsed_addr_id7, parsed_addr_id8, parsed_addr_id9, parsed_addr_id10
							   , parsed_addr_id11, parsed_addr_id12) 
	AS
	(
	SELECT TOP 100 u.u_addresses
	, SUBSTRING(u.u_addresses, 3, 38) AS First_Addr_ID
	, SUBSTRING(u.u_addresses, 42, 38) AS Second_Addr_ID
	, SUBSTRING(u.u_addresses, 81, 38) AS Third_Addr_ID
	, SUBSTRING(u.u_addresses, 120, 38) AS Fourth_Addr_ID
	, SUBSTRING(u.u_addresses, 159, 38) AS Fifth_Addr_ID
	, SUBSTRING(u.u_addresses, 198, 38) AS Sixth_Addr_ID
	, SUBSTRING(u.u_addresses, 237, 38) AS Seventh_Addr_ID
	, SUBSTRING(u.u_addresses, 276, 38) AS Eight_Addr_ID
	, SUBSTRING(u.u_addresses, 315, 38) AS Ninth_Addr_ID
	, SUBSTRING(u.u_addresses, 355, 38) AS Tenth_Addr_ID
	, SUBSTRING(u.u_addresses, 394, 38) AS Eleventh_Addr_ID
	, SUBSTRING(u.u_addresses, 433, 38) AS Twelth_Addr_ID
	FROM profile.Stage.Ecom_UserObject u WITH(NOLOCK)
	WHERE u.u_addresses LIKE '4%' 
	)
SELECT TOP 100 u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
			  , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2, MultiUserID_CTE.parsed_addr_id3, MultiUserID_CTE.parsed_addr_id4
			  , a.*
FROM profile.stage.Ecom_Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN profile.Stage.Ecom_UserObject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)

--individual address rows - address type 2 not in stage (store addr type)
DECLARE @UserID NVARCHAR(50) 
SET @UserID = '{00154bb0-3fc9-400f-ade4-5af0829851d2}'
SELECT u.i_customer_id, u.u_addresses, u.u_email_address
	 , a.u_address_id, a.u_address_line1, a.u_address_line2, a.u_address_name, a.u_city, a.u_region_code, a.u_postal_code, a.u_first_name, a.u_last_name
FROM profile.Stage.Ecom_UserObject u WITH(NOLOCK)
	JOIN profile.stage.Ecom_Addresses a
		ON SUBSTRING(u.u_addresses, 3, 38) = a.u_address_id 
		OR SUBSTRING(u.u_addresses, 42, 38) = a.u_address_id
		OR SUBSTRING(u.u_addresses, 81, 38) = a.u_address_id
		OR SUBSTRING(u.u_addresses, 120, 38) = a.u_address_id
WHERE u.u_user_id = @UserID

--if too many rows in profile address, check pur also
SELECT *
FROM profile.Stage.Genesis_Customer c WITH(NOLOCK)
	JOIN profile.stage.Genesis_Address a WITH(NOLOCK)
		ON c.CustomerID = a.CustomerID
WHERE c.EmailAddress LIKE '%alan.abrea@yahoo.com%'

--pur address consolidated
DECLARE @CustID INT
SET @CustID = 1070886861
SELECT p.ProfileID, a.[default], a.AddressID, a.AddressTypeID , a.Line1, a.Line2, a.City, a.PostalCode, a.RecipientFirstName, a.RecipientLastName
FROM profile.dbo.Profile p WITH(NOLOCK)
	JOIN profile.dbo.Address a WITH(NOLOCK)
		ON p.ProfileID = a.ProfileID
WHERE p.customerid_tmp = @CustID

--ecom with multiple phone
SELECT TOP 1000 u.i_customer_id, u.u_user_id, u.u_account_id, u.u_tel_number, u.u_tel_extension
	 , a.u_tel_extension, a.u_tel_number
FROM profile.Stage.Ecom_UserObject u WITH(NOLOCK)
	JOIN profile.Stage.Ecom_Addresses a WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 4, 38)
WHERE u.u_tel_number IS NOT NULL 
  AND a.u_tel_number IS NOT NULL
  AND a.i_address_type <> '2'

-- ecom phone consolidated on profile
DECLARE @CustID INT
SET @CustID = 1054753803
SELECT p.ProfileID, p.EmailAddress, p.customerid_tmp
	 , ph.PhoneNumber
	 , pht.PhoneTypeDesc
FROM profile.dbo.Profile p WITH(NOLOCK)
	JOIN profile.dbo.Phone ph WITH(NOLOCK)
		ON p.ProfileID = ph.ProfileID
	JOIN Profile.dbo.PhoneType pht
		ON ph.PhoneTypeID = pht.PhoneTypeID
WHERE p.customerid_tmp = @CustID

--if ph# not there, check pur stage customer table
DECLARE @CustID INT
SET @CustID = 1054753803
SELECT c.CustomerID, c.EmailAddress, c.HomePhone, c.WorkPhone, c.MobilePhone 
FROM profile.stage.Genesis_Customer c WITH(NOLOCK)
WHERE c.CustomerID = @CustID

--ecom with multiple home store
SELECT TOP 1000 u.i_customer_id, u.u_account_id, u.u_email_address, u.HomeStore
FROM Profile.stage.Ecom_UserObject u WITH(NOLOCK)
WHERE u.HomeStore IS NOT NULL
   OR u.HomeStore <> ''

--ecom home store on new profile
DECLARE @CustID INT
SET @CustID = 1109132990
SELECT TOP 1000 p.customerid_tmp, p.EmailAddress, p.ProfileID, s.IsHomeStore, s.StoreNumber
FROM profile.dbo.Profile p WITH(NOLOCK)
	JOIN profile.dbo.PreferredStore s WITH(NOLOCK)
		ON p.ProfileID = s.ProfileID 
WHERE p.customerid_tmp = @CustID

--If data doesn't match, check pur stage
DECLARE @CustID INT
SET @CustID = 1109132990
SELECT c.CustomerID, c.EmailAddress, c.HomeStoreNumber
FROM profile.Stage.Genesis_Customer c WITH(NOLOCK)
WHERE c.CustomerID = @CustID