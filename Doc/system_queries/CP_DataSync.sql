DECLARE @Email NVARCHAR(55)
SET @Email = 'johntestcp01@gspcauto.fav.cc'

SELECT TOP 1000 p.ProfileID, p.FirstName, p.LastName, p.DisplayName, p.BirthDay, p.BirthMonth, p.BirthYear
			  , CASE p.GenderID WHEN 1 THEN 'MALE' WHEN 2 THEN 'FEMALE' ELSE 'UNKNOWN' END AS Gender
			  , ck.OpenIDClaimedIdentifier
FROM Profile.dbo.Profile p 
	JOIN Profile.KeyMap.CustomerKey ck
		ON p.ProfileID = ck.ProfileID
WHERE p.EmailAddress = @Email

SELECT TOP 1000 ps.* 
FROM Profile.dbo.PreferredStore ps 
WHERE ps.ProfileID = (SELECT p.ProfileID FROM profile.dbo.Profile p WHERE p.EmailAddress = @Email)

SELECT TOP 1000 * FROM [Profile].[Stage].[BatchProfileStage]
SELECT TOP 1000 * FROM [Profile].[Stage].[BatchAddressStage]

--SELECT p.ProfileID FROM profile.dbo.Profile p WHERE p.EmailAddress = 'johntestcp01@gspcauto.fav.cc'

--Commerce server
SELECT TOP 100 u.u_user_id, u.u_email_address, u.u_first_name, u.u_last_name, u.u_display_name, u.u_birth_day, u.u_birth_month, u.u_gender, u_Pref1, u.u_account_id, u.dt_date_created, u.dt_date_last_changed
FROM Gamestop_profiles.dbo.UserObject u 
WHERE u_email_address = 'johntestcp01@gspcauto.fav.cc'