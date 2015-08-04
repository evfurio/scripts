--Current GS.com profile
SELECT TOP 1000
	 --gs.com account user_object rows
     u.u_first_name, u.u_last_name, u.u_email_address , u.u_addresses, u.u_tel_number, u.u_tel_extension
   , u.dt_date_created, u.u_default_bill_address, u.u_default_ship_address, u.u_display_name, u.u_gender
   , u.u_birth_month, u.u_birth_day, u.u_powerup_card_number, u.u_account_id
     --gs.com account address rows
   , a.i_address_type, a.u_first_name, a.u_last_name, a.u_description, a.u_address_line1, a.u_address_line2
   , a.u_city, a.u_region_code, a.u_postal_code, a.u_country_code, a.u_country_name, a.u_tel_number
   , a.u_tel_extension, a.u_store_number
   
FROM Gamestop_profiles.dbo.UserObject u WITH (NOLOCK)
	JOIN Gamestop_profiles.dbo.Addresses a WITH (NOLOCK)
		ON SUBSTRING(u.u_addresses, 3, 43) = a.u_address_id
WHERE a.i_address_type <> '2'
		
--user id's with more than one address id in address table

--users with two addresses
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
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
	WHERE u.u_addresses LIKE '2%' 
	)
SELECT u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2
	 , a.*
FROM Gamestop_profiles.dbo.Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)
WHERE a.i_address_type <> '2'

--users with three addresses
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
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
	WHERE u.u_addresses LIKE '3%' 
	)
SELECT u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2, MultiUserID_CTE.parsed_addr_id3
	 , a.*
FROM Gamestop_profiles.dbo.Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)
WHERE a.i_address_type <> '2'
		
--users with four addresses
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
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
	WHERE u.u_addresses LIKE '4%' 
	)
SELECT u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2, MultiUserID_CTE.parsed_addr_id3, MultiUserID_CTE.parsed_addr_id4
	 , a.*
FROM Gamestop_profiles.dbo.Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)
WHERE a.i_address_type <> '2'

--users with seven addresses
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
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
	WHERE u.u_addresses LIKE '7%' 
	)
SELECT u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2, MultiUserID_CTE.parsed_addr_id3, MultiUserID_CTE.parsed_addr_id4
	 , MultiUserID_CTE.parsed_addr_id5, MultiUserID_CTE.parsed_addr_id6, MultiUserID_CTE.parsed_addr_id7
	 , a.*
FROM Gamestop_profiles.dbo.Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)
WHERE a.i_address_type <> '2'

--users with ten addresses
WITH 
	MultiUserID_CTE (addressIDs, parsed_addr_id1, parsed_addr_id2, parsed_addr_id3, parsed_addr_id4, parsed_addr_id5
							   , parsed_addr_id6, parsed_addr_id7, parsed_addr_id8, parsed_addr_id9, parsed_addr_id10
							   , parsed_addr_id11, parsed_addr_id12) 
	AS
	(
	SELECT TOP 100 u.u_addresses
	, SUBSTRING(u.u_addresses, 4, 38) AS First_Addr_ID
	, SUBSTRING(u.u_addresses, 43, 38) AS Second_Addr_ID
	, SUBSTRING(u.u_addresses, 82, 38) AS Third_Addr_ID
	, SUBSTRING(u.u_addresses, 121, 38) AS Fourth_Addr_ID
	, SUBSTRING(u.u_addresses, 160, 38) AS Fifth_Addr_ID
	, SUBSTRING(u.u_addresses, 199, 38) AS Sixth_Addr_ID
	, SUBSTRING(u.u_addresses, 238, 38) AS Seventh_Addr_ID
	, SUBSTRING(u.u_addresses, 277, 38) AS Eight_Addr_ID
	, SUBSTRING(u.u_addresses, 316, 38) AS Ninth_Addr_ID
	, SUBSTRING(u.u_addresses, 355, 38) AS Tenth_Addr_ID
	, SUBSTRING(u.u_addresses, 394, 38) AS Eleventh_Addr_ID
	, SUBSTRING(u.u_addresses, 433, 38) AS Twelth_Addr_ID
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
	WHERE u.u_addresses LIKE '10%' 
	)
SELECT u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , MultiUserID_CTE.parsed_addr_id1, MultiUserID_CTE.parsed_addr_id2, MultiUserID_CTE.parsed_addr_id3, MultiUserID_CTE.parsed_addr_id4
	 , MultiUserID_CTE.parsed_addr_id5, MultiUserID_CTE.parsed_addr_id6, MultiUserID_CTE.parsed_addr_id7, MultiUserID_CTE.parsed_addr_id8
	 , MultiUserID_CTE.parsed_addr_id9, MultiUserID_CTE.parsed_addr_id10
	 , a.*
FROM Gamestop_profiles.dbo.Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 4, 38)
WHERE a.i_address_type <> '2'
		
-- user ids with multiple phone numbers
SELECT u.u_user_id, u.u_account_id, u.u_tel_number, u.u_tel_extension
	 , u.u_tel_number, u.u_tel_extension
FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
	JOIN Gamestop_profiles.dbo.Addresses a WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 4, 38)
WHERE u.u_tel_number IS NOT NULL 
  AND a.u_tel_number IS NOT NULL
  AND a.i_address_type <> '2'
  
  --OR--
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
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
	WHERE u.u_addresses LIKE '2%' --change value here for userid with multiple addr records
	)
SELECT u.u_user_id, u.u_tel_number, u.u_tel_extension, SUBSTRING(u.u_addresses, 1,2) AS Num_of_Addrs
	 , a.u_tel_number, a.u_tel_extension
FROM Gamestop_profiles.dbo.Addresses a WITH(NOLOCK)
	INNER JOIN MultiUserID_CTE
		ON a.u_address_id = MultiUserID_CTE.parsed_addr_id1
	JOIN Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38) 
WHERE u.u_tel_number IS NOT NULL
  AND a.u_tel_number IS NOT NULL  
  AND a.i_address_type <> '2'

--user ids with multiple preferred stores
SELECT TOP 1000 u.u_user_id ,u.u_email_address ,u.u_Pref1, u.u_Pref2, u.u_Pref3, u.u_Pref4, u.u_Pref5
			  , a.i_address_type, a.u_address_name, a.u_last_name
FROM Gamestop_profiles.dbo.Addresses a
	JOIN Gamestop_profiles.dbo.UserObject u
		ON a.u_email_address = u.u_email_address
WHERE a.i_address_type = '2'

--or

WITH MultiAddrID_CTE (addr_id, userid, pref1)
	AS
	(
	SELECT TOP 1000 SUBSTRING(u.u_addresses, 3, 38) AS Addr_ID1, u.u_user_id, u.u_Pref1
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		JOIN Gamestop_profiles.dbo.Addresses a
			ON SUBSTRING(u.u_addresses, 3, 38) = a.u_address_id
	WHERE a.i_address_type = '2' 
	UNION ALL
	SELECT TOP 1000 SUBSTRING(u.u_addresses, 42, 38) AS Addr_ID2, u.u_user_id, u.u_Pref1
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		JOIN Gamestop_profiles.dbo.Addresses a
			ON SUBSTRING(u.u_addresses, 42, 38) = a.u_address_id
	WHERE a.i_address_type = '2'
	UNION ALL
	SELECT TOP 1000 SUBSTRING(u.u_addresses, 81, 38) AS Addr_ID3, u.u_user_id, u.u_Pref1
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		JOIN Gamestop_profiles.dbo.Addresses a
			ON SUBSTRING(u.u_addresses, 81, 38) = a.u_address_id
	WHERE a.i_address_type = '2'
	UNION ALL
	SELECT TOP 1000 SUBSTRING(u.u_addresses, 120, 38) AS Addr_ID1, u.u_user_id, u.u_Pref1
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		JOIN Gamestop_profiles.dbo.Addresses a
			ON SUBSTRING(u.u_addresses, 120, 38) = a.u_address_id
	WHERE a.i_address_type = '2'
	UNION ALL
	SELECT TOP 1000 SUBSTRING(u.u_addresses, 120, 38) AS Addr_ID1, u.u_user_id, u.u_Pref1
	FROM Gamestop_profiles.dbo.userobject u WITH(NOLOCK)
		JOIN Gamestop_profiles.dbo.Addresses a
			ON SUBSTRING(u.u_addresses, 120, 38) = a.u_address_id
	WHERE a.i_address_type = '2' 	 	
	)
SELECT TOP 1000 MultiAddrID_CTE.*, a.u_address_id, a.i_address_type, a.u_address_name, a.u_last_name
FROM Gamestop_profiles.dbo.Addresses a WITH(NOLOCK)
	JOIN MultiAddrID_CTE
		ON MultiAddrID_CTE.addr_id = a.u_address_id
ORDER BY u_address_id
		 


--or 

SELECT TOP 1000 u.u_user_id ,u.u_email_address ,u.u_Pref1, u.u_Pref2, u.u_Pref3, u.u_Pref4, u.u_Pref5
			  , a.i_address_type, a.u_address_name, a.u_last_name
FROM Gamestop_profiles.dbo.Addresses a
	JOIN Gamestop_profiles.dbo.UserObject u
		-- ON a.u_address_id = SUBSTRING(u.u_addresses, 3, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 42, 38)
		 ON  a.u_address_id = SUBSTRING(u.u_addresses, 81, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 120, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 159, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 198, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 237, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 276, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 315, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 355, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 394, 38)
		-- ON  a.u_address_id = SUBSTRING(u.u_addresses, 433, 38)
WHERE a.i_address_type = '2'
ORDER BY u.u_email_address