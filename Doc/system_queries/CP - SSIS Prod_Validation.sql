--Prod Validation

--***run before profile merge package/or against backups***

--count of PUR accts to stage 
SELECT COUNT(*)
FROM GenesisCorp.dbo.Customer c WITH(NOLOCK)
	JOIN GenesisCorp.dbo.RealmUser ru WITH(NOLOCK)
		ON c.CustomerID = ru.CustomerID
	JOIN Membership.dbo.Membership m WITH(NOLOCK)
		ON ru.MembershipID = m.MembershipID

-- count of ecom profile with openID to stage
SELECT u_account_id
FROM Gamestop_profiles.dbo.UserObject u WITH(NOLOCK)
WHERE u.u_account_id IS NOT NULL
  AND LEN(RTRIM(LTRIM(u.u_account_id))) <> 0
  
-- count of ecom addresses << type 2 (store)
SELECT COUNT(*)
FROM Gamestop_profiles.dbo.Addresses a WITH(NOLOCK)
	WHERE a.i_address_type <> 2

-- count of genesis addresses attached to PUR users
SELECT COUNT(*)
FROM GenesisCorp.dbo.Address a WITH(NOLOCK)
	JOIN GenesisCorp.dbo.Customer c WITH(NOLOCK)
		ON a.CustomerID = c.CustomerID
	JOIN GenesisCorp.dbo.RealmUser ru WITH(NOLOCK)
		ON c.CustomerID = ru.CustomerID
--*************************************

--store & zip ref tables added to profile
SELECT TOP 10 * FROM Profile.Stage.Store WITH(NOLOCK)
SELECT TOP 10 * FROM Profile.Stage.ZipCode WITH(NOLOCK)

--after records move to stage
--ecom
SELECT COUNT(*) FROM Profile.stage.Ecom_UserObject WITH(NOLOCK) --
SELECT COUNT(*) FROM profile.stage.Ecom_Addresses WITH(NOLOCK) --
--pur
SELECT COUNT(*) FROM profile.stage.Genesis_Customer WITH(NOLOCK) --
SELECT COUNT(*) FROM profile.Stage.Genesis_Address WITH(NOLOCK) --

--gencorp stage addr's with no email
SELECT COUNT(*) FROM profile.stage.Invalid_Genesis_Customer WITH(NOLOCK) WHERE EmailAddress IS NOT NULL --
SELECT COUNT(*) FROM profile.stage.Genesis_Customer WITH(NOLOCK) WHERE EmailAddress IS NULL --
SELECT COUNT(*) FROM Profile.Stage.Genesis_Customer WITH(NOLOCK) WHERE LEN(RTRIM(LTRIM(EmailAddress))) = 0 --

--genesis addresses missing city, state, zip
SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE City IS NULL --0
SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE LEN(RTRIM(LTRIM(City))) = 0 --

SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE StateorProvince IS NULL --0
SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE LEN(RTRIM(LTRIM(StateorProvince))) = 0 --

SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE Country IS NULL --0
SELECT COUNT(*) FROM Profile.stage.Genesis_Address WITH(NOLOCK) WHERE LEN(RTRIM(LTRIM(Country))) = 0 --

--multiple membership id's for a PUR customer
SELECT COUNT(*), MembershipID FROM profile.stage.Genesis_Customer WITH(NOLOCK) GROUP BY MembershipID HAVING COUNT(*) > 1 --

--***validate manually that for users with multiple membershipIDs, newest membershipID/customerID is chosen for merge***
SELECT COUNT(*), MembershipID FROM profile.stage.Invalid_Genesis_Customer WITH(NOLOCK) GROUP BY MembershipID HAVING COUNT(*) > 1

--addresses missing city, line1, zip, or state not in address table
SELECT AddressID FROM Profile.dbo.Address WITH(NOLOCK) WHERE City IS NULL
SELECT AddressID FROM Profile.dbo.Address WITH(NOLOCK) WHERE Line1 IS NULL
SELECT AddressID FROM Profile.dbo.Address WITH(NOLOCK) WHERE PostalCode IS NULL
SELECT AddressID FROM Profile.dbo.Address WITH(NOLOCK) WHERE State IS NULL

--addresses missing city, line1, zip, or state in invalid address table
SELECT AddressID FROM Profile.Stage.Invalid_Genesis_Address WITH(NOLOCK) WHERE City IS NULL
SELECT AddressID FROM Profile.Stage.Invalid_Genesis_Address WITH(NOLOCK) WHERE AddressLine1 IS NULL
SELECT AddressID FROM Profile.Stage.Invalid_Genesis_Address WITH(NOLOCK) WHERE Zip IS NULL
SELECT AddressID FROM Profile.Stage.Invalid_Genesis_Address WITH(NOLOCK) WHERE StateAbbr IS NULL

--ecom addresses with word 'delete' moved to invalid addr.
SELECT * FROM Profile.stage.Ecom_Addresses WITH(NOLOCK) WHERE u_address_line1 LIKE '%delete%' --
SELECT * FROM Profile.stage.Invalid_Ecom_Address WITH(NOLOCK) WHERE u_address_line1 LIKE '%delete%' --

--ecom addr's with country = US either no city, state, line1, or zip
SELECT COUNT(*) FROM profile.stage.Ecom_Addresses WITH (NOLOCK) WHERE u_country_code = 'US' AND u_city IS NULL --
SELECT COUNT(*) FROM profile.stage.Ecom_Addresses WITH (NOLOCK) WHERE u_country_code = 'US' AND u_region_code IS NULL --
SELECT COUNT(*) FROM Profile.Stage.Ecom_Addresses WITH(NOLOCK) WHERE u_address_line1 IS NULL
SELECT COUNT(*) FROM Profile.Stage.Ecom_Addresses WITH(NOLOCK) WHERE u_postal_code IS NULL

--addresses in profile that country <> 'US',check the results
SELECT COUNT(*) FROM Profile.dbo.Address a WHERE a.Country <> 'US'

--check normalized ecom addresses in userobject_address stage

--check customerkey for anomilies, missing data

--check phone, home store, addr once-over

--addresses by type with no default specified
SELECT ProfileID, AddressTypeID 
FROM dbo.Address AS a
--WHERE  DateCreated = '2013-08-29 17:18:30.1900000 +00:00'
GROUP BY ProfileID, AddressTypeID
HAVING SUM(ISNULL(CAST([default] AS TINYINT),0)) = 0

