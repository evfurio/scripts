
DECLARE @EmailAddr NVARCHAR(255)
SET @EmailAddr = 'jontestqa0821130757@gspcauto.fav.cc' 

SELECT TOP 1000 * FROM [Profile].[Stage].[Genesis_Customer] WHERE EmailAddress = @EmailAddr
SELECT TOP 100 * FROM Profile.dbo.Profile p JOIN Profile.KeyMap.CustomerKey ck ON p.ProfileID = ck.ProfileID WHERE p.EmailAddress = @EmailAddr 
SELECT TOP 100 * FROM membership.dbo.MemberShip mem
	JOIN Membership.dbo.MembershipCard mc
		ON mem.MembershipID = mc.MembershipID 
	WHERE mem.MembershipID = 
	(SELECT m.MembershipID 
	 FROM membership.dbo.Membership m 
		JOIN profile.KeyMap.CustomerKey ck 
			ON m.MembershipID = ck.MembershipID
		JOIN profile.dbo.Profile p
			ON ck.ProfileID = p.ProfileID
	WHERE p.EmailAddress = @EmailAddr)
SELECT TOP 1000 * FROM [Profile].[Stage].[Ecom_UserObject] WHERE u_email_address = @EmailAddr
SELECT TOP 100 * FROM Multipass.dbo.IssuedUser mp WHERE mp.EmailAddress = @EmailAddr

 

