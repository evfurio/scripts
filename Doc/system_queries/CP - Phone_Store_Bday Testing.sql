--phone in profile to phone tables
SELECT TOP 10000 p.ProfileID, ph.PhoneNumber, pt.PhoneTypeDesc
FROM Profile.dbo.Profile p --1761216
	JOIN profile.dbo.Phone ph
		ON p.ProfileID = ph.ProfileID
	JOIN Profile.dbo.PhoneType pt
		ON ph.PhoneTypeID = pt.PhoneTypeID
		
--phone in genesis stage to profile phone tables
SELECT TOP 1000 * 
FROM Profile.Stage.Genesis_Customer c WITH(NOLOCK)
	JOIN profile.KeyMap.CustomerKey ck WITH(NOLOCK)
		ON c.MembershipID = ck.MembershipID
	JOIN profile.dbo.Profile p WITH(NOLOCK)
		ON ck.ProfileID = p.ProfileID
	JOIN profile.dbo.Phone ph WITH(NOLOCK)
		ON p.ProfileID = ph.ProfileID
	JOIN Profile.dbo.PhoneType pt WITH(NOLOCK)
		ON ph.PhoneTypeID = pt.PhoneTypeID				
WHERE c.HomePhone IS NOT NULL AND LEN(RTRIM(LTRIM(c.HomePhone))) <> 0 

--phone in ecom stage to profile phone tables
SELECT COUNT(*) FROM [Profile].[Stage].[Ecom_UserObject] where u_tel_number is not null and LEN(RTRIM(LTRIM(u_tel_number))) <> 0 --
SELECT COUNT(*) FROM [Profile].[Stage].[Ecom_UserObject] where u_mobile_number is not null and LEN(RTRIM(LTRIM(u_mobile_number))) <> 0 --

SELECT COUNT(*) --1672954
FROM profile.stage.Ecom_UserObject u
	JOIN profile.KeyMap.CustomerKey ck
		ON u.u_account_id = ck.OpenIDClaimedIdentifier
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
	JOIN profile.dbo.Phone ph
		ON p.ProfileID = ph.ProfileID
	JOIN Profile.dbo.PhoneType pt
		ON ph.PhoneTypeID = pt.PhoneTypeID		
WHERE u_tel_number IS NOT NULL AND LEN(RTRIM(LTRIM(u_tel_number))) <> 0

--ecom phones not existing in genesis customer stage
SELECT TOP 1000 u.u_account_id, u.u_email_address, u.u_tel_number, c.EmailAddress, c.HomePhone
FROM profile.Stage.Ecom_UserObject u
	LEFT JOIN profile.Stage.Genesis_Customer c
		ON u.u_tel_number = c.HomePhone
WHERE u.u_tel_number IS NOT NULL AND LEN(RTRIM(LTRIM(u.u_tel_number))) <> 0
  AND c.HomePhone IS NULL
  
SELECT TOP 100 p.ProfileID, ph.PhoneNumber, pt.PhoneTypeDesc
FROM Profile.dbo.Profile p 
	JOIN profile.dbo.Phone ph
		ON p.ProfileID = ph.ProfileID
	JOIN Profile.dbo.PhoneType pt
		ON ph.PhoneTypeID = pt.PhoneTypeID
WHERE p.EmailAddress = 'danimal_drw@hotmail.com' --001813117626215

SELECT * FROM Profile.stage.Genesis_Customer c WHERE c.EmailAddress = 'D3NNISV3GA@YAHOO.COM'
  
--homestore
SELECT COUNT(*) FROM profile.stage.Genesis_Customer c WHERE c.HomeStoreNumber IS NOT NULL --26210
SELECT COUNT(*) FROM Profile.dbo.PreferredStore --26815

SELECT COUNT(*)
FROM Profile.Stage.Genesis_Customer c
WHERE c.EmailAddress NOT IN (SELECT p.EmailAddress FROM Profile.dbo.Profile p JOIN profile.dbo.PreferredStore ps ON p.ProfileID = ps.ProfileID)
  AND c.HomeStoreNumber IS NOT NULL

SELECT TOP 30000 c.EmailAddress, c.HomeStoreNumber , p.ProfileID, ps.StoreNumber, st.DistrictName
FROM Profile.Stage.Genesis_Customer c --20773
	JOIN profile.KeyMap.CustomerKey ck
		ON c.MembershipID = ck.MembershipID
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
	JOIN Profile.dbo.PreferredStore ps
		ON p.ProfileID = ps.ProfileID
	JOIN Profile.Stage.Store st
		ON ps.StoreNumber = st.storenumber
WHERE c.HomeStoreNumber IS NOT NULL AND LEN(RTRIM(LTRIM(c.HomeStoreNumber))) <> 0

SELECT e.u_email_address, e.HomeStore, p.ProfileID, ps.StoreNumber, st.DistrictName
FROM Profile.Stage.Ecom_UserObject e --106
	JOIN Profile.KeyMap.CustomerKey ck
		ON e.u_account_id = ck.OpenIDClaimedIdentifier
	JOIN Profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
	JOIN Profile.dbo.PreferredStore ps
		ON p.ProfileID = ps.ProfileID
	JOIN Profile.Stage.Store st
		ON ps.StoreNumber = st.storenumber		
WHERE e.HomeStore IS NOT NULL AND LEN(RTRIM(LTRIM(e.HomeStore))) <> 0 AND e.HomeStore <> '0'

--phone
SELECT TOP 1000 ph.PhoneNumber, pt.PhoneTypeDesc FROM profile.dbo.Profile p JOIN profile.dbo.Phone ph ON p.ProfileID = ph.ProfileID JOIN Profile.dbo.PhoneType pt ON ph.PhoneTypeID = pt.PhoneTypeID
SELECT COUNT(*) FROM Profile.dbo.Phone
SELECT COUNT(*) FROM Profile.Stage.Genesis_Customer c WHERE c.HomePhone IS NOT NULL AND LEN(RTRIM(LTRIM(c.HomePhone))) <> 0
SELECT COUNT(*) FROM Profile.Stage.Genesis_Customer c WHERE LEN(RTRIM(LTRIM(c.HomePhone))) <> 0
SELECT COUNT(*) FROM Profile.Stage.Genesis_Customer c WHERE c.HomePhone <> '%000000%'

--phone in profile to phone tables
SELECT TOP 10000 COUNT(*)--p.ProfileID, ph.PhoneNumber, pt.PhoneTypeDesc
FROM Profile.dbo.Profile p --1761287
	JOIN profile.dbo.Phone ph
		ON p.ProfileID = ph.ProfileID
	JOIN Profile.dbo.PhoneType pt
		ON ph.PhoneTypeID = pt.PhoneTypeID
		
--phone in genesis stage to profile phone tables
SELECT COUNT(*) --88024
FROM Profile.Stage.Genesis_Customer c
	JOIN profile.KeyMap.CustomerKey ck
		ON c.MembershipID = ck.MembershipID
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
	JOIN profile.dbo.Phone ph
		ON p.ProfileID = ph.ProfileID
	JOIN Profile.dbo.PhoneType pt
		ON ph.PhoneTypeID = pt.PhoneTypeID				
WHERE c.HomePhone IS NOT NULL AND LEN(RTRIM(LTRIM(c.HomePhone))) <> 0 

--phone in ecom stage to profile phone tables
SELECT COUNT(*) FROM [Profile].[Stage].[Ecom_UserObject] where u_tel_number is not null and LEN(RTRIM(LTRIM(u_tel_number))) <> 0 --1711774
SELECT COUNT(*) FROM [Profile].[Stage].[Ecom_UserObject] where u_mobile_number is not null and LEN(RTRIM(LTRIM(u_mobile_number))) <> 0 --6

SELECT COUNT(*) --1711774
FROM profile.stage.Ecom_UserObject u
	JOIN profile.KeyMap.CustomerKey ck
		ON u.u_account_id = ck.OpenIDClaimedIdentifier
	JOIN profile.dbo.Profile p
		ON ck.ProfileID = p.ProfileID
	JOIN profile.dbo.Phone ph
		ON p.ProfileID = ph.ProfileID
	JOIN Profile.dbo.PhoneType pt
		ON ph.PhoneTypeID = pt.PhoneTypeID		
WHERE u_tel_number IS NOT NULL AND u_tel_number <> ''

--ecom phones not existing in genesis customer stage
SELECT TOP 1000 u.u_account_id, u.u_email_address, u.u_tel_number, c.EmailAddress, c.HomePhone
FROM profile.Stage.Ecom_UserObject u
	LEFT JOIN profile.Stage.Genesis_Customer c
		ON u.u_tel_number = c.HomePhone
WHERE u.u_tel_number IS NOT NULL AND u.u_tel_number <> ''
  AND c.HomePhone IS NULL
  
SELECT TOP 100 p.ProfileID, ph.PhoneNumber, pt.PhoneTypeDesc
FROM Profile.dbo.Profile p 
	JOIN profile.dbo.Phone ph
		ON p.ProfileID = ph.ProfileID
	JOIN Profile.dbo.PhoneType pt
		ON ph.PhoneTypeID = pt.PhoneTypeID
WHERE p.EmailAddress = 'D3NNISV3GA@YAHOO.COM'

SELECT * FROM Profile.stage.Genesis_Customer c WHERE c.EmailAddress = 'D3NNISV3GA@YAHOO.COM'

-- birthday
SELECT TOP 100000 
			 	p.ProfileID, p.EmailAddress, p.BirthDay, p.BirthMonth, p.BirthYear
			  ,	c.DOB
			  , u.u_birth_day, u.u_birth_month
FROM Profile.dbo.Profile p
	JOIN profile.stage.Genesis_Customer c
		ON p.EmailAddress = c.EmailAddress
	JOIN Profile.stage.Ecom_UserObject u
		ON p.EmailAddress = u.u_email_address
ORDER BY p.EmailAddress 

SELECT TOP 100000 
			 	p.ProfileID, p.EmailAddress, p.BirthDay, p.BirthMonth, p.BirthYear
			  ,	c.DOB
FROM Profile.dbo.Profile p
	JOIN profile.stage.Genesis_Customer c
		ON p.EmailAddress = c.EmailAddress
WHERE c.DOB IS NOT NULL
ORDER BY p.EmailAddress

SELECT TOP 100000 
			 	p.ProfileID, p.EmailAddress, p.BirthDay, p.BirthMonth, p.BirthYear
			  , u.u_birth_day, u.u_birth_month
FROM Profile.dbo.Profile p
	JOIN Profile.stage.Ecom_UserObject u
		ON p.EmailAddress = u.u_email_address
ORDER BY p.EmailAddress 