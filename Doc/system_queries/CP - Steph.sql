
SELECT COUNT(*) -- 1027
FROM Profile.Stage.Ecom_UserObject u

SELECT COUNT(*) -- 0
FROM Profile.Stage.Ecom_UserObject u
 JOIN Profile.KeyMap.CustomerKey ck
	ON u.u_account_id = ck.OpenIDClaimedIdentifier
	
SELECT TOP 10000 *
FROM Profile.Stage.Ecom_UserObject u
	JOIN Profile.KeyMap.CustomerKey ck
		ON u.u_account_id = ck.OpenIDClaimedIdentifier	
	JOIN Multipass.dbo.IssuedUser iu
		ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier

--ecom only with shipping address
WITH 
	MultiUserID_CTE (addressIDs, parsed_addr_id1, parsed_addr_id2, parsed_addr_id3, parsed_addr_id4, parsed_addr_id5
							   , parsed_addr_id6, parsed_addr_id7, parsed_addr_id8, parsed_addr_id9, parsed_addr_id10
							   , parsed_addr_id11, parsed_addr_id12) 
	AS
	(
	SELECT u.u_addresses
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
	)
SELECT 'Ecom only shipping address' AS 'Test Type', u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , u.u_default_bill_address, u.u_default_ship_address
	 , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2, MultiUserID_CTE.parsed_addr_id3, MultiUserID_CTE.parsed_addr_id4
	 , a.*
FROM Profile.Stage.Ecom_Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Profile.Stage.Ecom_UserObject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)
WHERE a.i_address_type = 0

--default shipping address
WITH 
	MultiUserID_CTE (addressIDs, parsed_addr_id1, parsed_addr_id2, parsed_addr_id3, parsed_addr_id4, parsed_addr_id5
							   , parsed_addr_id6, parsed_addr_id7, parsed_addr_id8, parsed_addr_id9, parsed_addr_id10
							   , parsed_addr_id11, parsed_addr_id12) 
	AS
	(
	SELECT u.u_addresses
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
	)
SELECT 'Default shipping address' AS 'Test Type', u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , u.u_default_bill_address, u.u_default_ship_address
	 , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2, MultiUserID_CTE.parsed_addr_id3, MultiUserID_CTE.parsed_addr_id4
	 , a.*
FROM Profile.Stage.Ecom_Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Profile.Stage.Ecom_UserObject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)
WHERE a.i_address_type = 0
  AND u.u_default_ship_address IS NOT NULL
  AND u.u_default_bill_address <> ''
  
--ecom only with billing address
WITH 
	MultiUserID_CTE (addressIDs, parsed_addr_id1, parsed_addr_id2, parsed_addr_id3, parsed_addr_id4, parsed_addr_id5
							   , parsed_addr_id6, parsed_addr_id7, parsed_addr_id8, parsed_addr_id9, parsed_addr_id10
							   , parsed_addr_id11, parsed_addr_id12) 
	AS
	(
	SELECT u.u_addresses
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
	)
SELECT 'Ecom only billing address' AS 'Test Type', u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , u.u_default_bill_address, u.u_default_ship_address
	 , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2, MultiUserID_CTE.parsed_addr_id3, MultiUserID_CTE.parsed_addr_id4
	 , a.*
FROM Profile.Stage.Ecom_Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Profile.Stage.Ecom_UserObject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)
WHERE a.i_address_type = 1

--ecom only with shipping and billing address up to max (highest is 4 addresses, with a default bill n ship)
WITH 
	MultiUserID_CTE (addressIDs, parsed_addr_id1, parsed_addr_id2, parsed_addr_id3, parsed_addr_id4, parsed_addr_id5
							   , parsed_addr_id6, parsed_addr_id7, parsed_addr_id8, parsed_addr_id9, parsed_addr_id10
							   , parsed_addr_id11, parsed_addr_id12) 
	AS
	(
	SELECT u.u_addresses
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
	)
SELECT 'Ecom only ship and billing address max' AS 'Test Type', u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , u.u_default_bill_address, u.u_default_ship_address
	 , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2, MultiUserID_CTE.parsed_addr_id3, MultiUserID_CTE.parsed_addr_id4
	 , a.*
FROM Profile.Stage.Ecom_Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Profile.Stage.Ecom_UserObject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)
		
--LEN(RTRIM(LTRIM(City))) = 0
--ecom only with birthday
SELECT 'Ecom only birthday' AS 'Test Type',  *
FROM Profile.stage.Ecom_UserObject u (NOLOCK)
WHERE u.u_birth_day IS NOT NULL
  AND u.u_birth_month IS NOT NULL

--ecom only with first name
SELECT 'Ecom only first name' AS 'Test Type',  *
FROM Profile.stage.Ecom_UserObject u (NOLOCK)
WHERE u.u_first_name IS NOT NULL

--ecom only with last name
SELECT 'Ecom only last name' AS 'Test Type',  *
FROM Profile.stage.Ecom_UserObject u (NOLOCK)
WHERE u.u_last_name IS NOT NULL

--ecom only with gender
SELECT 'Ecom only gender' AS 'Test Type',  *
FROM Profile.stage.Ecom_UserObject u (NOLOCK)
WHERE u.u_gender IS NOT NULL

--ecom only with display name
SELECT 'Ecom only display name' AS 'Test Type',  *
FROM Profile.stage.Ecom_UserObject u (NOLOCK)
WHERE u.u_display_name IS NOT NULL

--ecom only with home store
SELECT 'Ecom only home store' AS 'Test Type',  *
FROM Profile.stage.Ecom_UserObject u (NOLOCK)
WHERE u.HomeStore IS NOT NULL

--ecom only with max stores (only the 'preferred' home store is brought over. this is stored in the pref1 column and brought here to stage as homestore column'
--see above test

--ecom only with default store
--see above

--ecom with all the above elements
SELECT 'Ecom only most or all elements' AS 'Test Type',  *
FROM Profile.stage.Ecom_UserObject u (NOLOCK)
WHERE u.HomeStore IS NOT NULL
  AND u.u_first_name IS NOT NULL
  AND u.u_last_name IS NOT NULL
  AND u.u_gender IS NOT NULL
  AND u.u_display_name IS NOT NULL  
  AND u.u_birth_day IS NOT NULL
  AND u.u_birth_month IS NOT NULL
  
--ecom with saved cc info (cant tell with cert data)

--ecom with order history (cant tell with cert data)

--ecom with wish list (cant tell with cert data)

