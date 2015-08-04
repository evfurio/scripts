-- address testing

DECLARE @UserID NVARCHAR(50)
SET @UserID = '{55e5b489-5a86-49b1-a30a-1e453782beae}'

SELECT TOP 100 uo.u_addresses FROM Profile.stage.Ecom_UserObject uo WHERE uo.u_user_id = @UserID
SELECT TOP 100 * FROM Profile.Stage.Ecom_UserObject u WHERE u.u_user_id = @UserID
SELECT TOP 100 eua.u_address_id FROM Profile.Stage.Ecom_UserObject_Addresses eua  WHERE u_user_id = @UserID;

--WITH 
--	MultiUserID_CTE (addressIDs, parsed_addr_id1, parsed_addr_id2, parsed_addr_id3, parsed_addr_id4) 
--	AS
--	(
--	SELECT TOP 25 su.u_addresses
--	, SUBSTRING(su.u_addresses, 3, 38) AS First_Addr_ID
--	, SUBSTRING(su.u_addresses, 42, 38) AS Second_Addr_ID
--	, SUBSTRING(su.u_addresses, 81, 38) AS Third_Addr_ID
--	, SUBSTRING(su.u_addresses, 120, 38) AS Fourth_Addr_ID
--	FROM Profile.Stage.Ecom_UserObject su WITH(NOLOCK)
--	WHERE su.u_user_id = @UserID
--	)
--SELECT uoa.u_account_id, uoa.u_user_id, mu.parsed_addr_id1, uoa.u_address_id FROM MultiUserID_CTE mu INNER JOIN profile.stage.Ecom_UserObject_Addresses uoa ON mu.parsed_addr_id1 = uoa.u_address_id WHERE mu.parsed_addr_id1 IS NOT NULL
--UNION ALL
--SELECT uoa.u_account_id, uoa.u_user_id, mu.parsed_addr_id2, uoa.u_address_id FROM MultiUserID_CTE mu INNER JOIN profile.stage.Ecom_UserObject_Addresses uoa ON mu.parsed_addr_id2 = uoa.u_address_id WHERE mu.parsed_addr_id2 IS NOT NULL
--UNION ALL
--SELECT uoa.u_account_id, uoa.u_user_id, mu.parsed_addr_id3, uoa.u_address_id FROM MultiUserID_CTE mu INNER JOIN profile.stage.Ecom_UserObject_Addresses uoa ON mu.parsed_addr_id3 = uoa.u_address_id WHERE mu.parsed_addr_id3 IS NOT NULL
--UNION ALL
--SELECT uoa.u_account_id, uoa.u_user_id, mu.parsed_addr_id4, uoa.u_address_id FROM MultiUserID_CTE mu INNER JOIN profile.stage.Ecom_UserObject_Addresses uoa ON mu.parsed_addr_id4 = uoa.u_address_id WHERE mu.parsed_addr_id4 IS NOT NULL

--addresses
SELECT TOP 1000 *
FROM Profile.Stage.Ecom_Addresses
WHERE u_address_id IN
(
'{C65ECE9F-4688-429D-A432-CF310CA10C3F}',
'{9ce45b64-9f54-4865-8a9e-ff79a2fecfed}',
'{afdd1158-4de7-499b-9bbb-dbaacc86540c}',
'{593033BB-003A-49FD-87E9-9ECC7FE0109E}'
)

--genesis addr on stage exist?
SELECT TOP 1000 * FROM Profile.Stage.Genesis_Address ga WHERE CustomerID = 1237237433

--ecom defaults from user_obj table exist?
SELECT TOP 1000 * FROM Profile.stage.Ecom_Addresses a
WHERE u_address_id IN 
(
'{aeec1137-a737-4852-b430-c78fcb33f4c0}', 
'{9ce45b64-9f54-4865-8a9e-ff79a2fecfed}'
)

--get the profileid for the user based on openid
SELECT TOP 10 ProfileID FROM Profile.KeyMap.CustomerKey WHERE OpenIDClaimedIdentifier = 'https://loginqa.gamestop.com/ID/0rvlXvEWXEav1Bc7VrYpqg'

--addr for profile on profile/addr dbs
SELECT a.* FROM Profile.dbo.Profile p JOIN Profile.dbo.Address a ON p.ProfileID = a.ProfileID WHERE p.ProfileID = 1237237433