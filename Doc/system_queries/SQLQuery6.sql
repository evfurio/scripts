DECLARE @EmailAddr NVARCHAR(100)
DECLARE @CardNumber NVARCHAR(50)
--DECLARE @Phone NVARCHAR(20)

SET @EmailAddr = 'email6936316172@gamestop.com'
SET @CardNumber = 3875379696851
--SET @Phone = '3875860326568'

SELECT m.CreatedDate, m.MembershipID, ms.Status AS MembershipStatus
	 , cs.Status AS CardStatus , mc.CardNumber
	 , ck.OpenIDClaimedIdentifier KeyMapOpenID
	 , p.ProfileID , p.EmailAddress, p.FirstName, p.LastName
	 , ph.PhoneNumber
FROM Membership.dbo.Membership m WITH(NOLOCK)
	JOIN Membership.dbo.MembershipCard mc WITH(NOLOCK)
		ON m.MembershipID = mc.MembershipID
	JOIN Membership.dbo.refMembershipStatus ms WITH(NOLOCK)
		ON m.MembershipStatusID = ms.MembershipStatusID
	JOIN Membership.dbo.refCardStatus cs WITH(NOLOCK)
		ON mc.CardStatusID = cs.CardStatusID
	JOIN profile.KeyMap.CustomerKey ck WITH(NOLOCK)
		ON m.MembershipID = ck.MembershipID
	JOIN profile.dbo.Profile p WITH(NOLOCK)
		ON ck.ProfileID = p.ProfileID
	JOIN profile.dbo.Phone ph WITH(NOLOCK)
		ON p.ProfileID = ph.ProfileID
WHERE mc.CardNumber = @CardNumber

SELECT * FROM profile.dbo.Profile p 
	JOIN profile.KeyMap.CustomerKey ck
		ON p.ProfileID = ck.ProfileID
WHERE p.EmailAddress = @EmailAddr

--should be null with new enrollment for CP
--SELECT * FROM GenesisCorp.dbo.Customer WHERE Customer.EmailAddress = @EmailAddr


SELECT u.EmailAddress AS MultiPass_Email_Addr
	 , c.ProfileID, c.OpenIDClaimedIdentifier
	 , p.EmailAddress AS Profile_Email_Addr, p.FirstName, p.MiddleName, p.LastName, p.DisplayName, p.BirthDay, p.BirthMonth, p.BirthYear, ph.PhoneNumber AS Profile_Main_Nbr
	 , g.GenderDesc AS Gender
	 , CASE a.[Default]
		WHEN '1' THEN 'Yes'
		ELSE 'No'
	   END AS "Address_Is_Default?"
	 , a.DateModified AS Last_Mod_Addr_Date  
	 , at.AddressTypeDesc AS Addr_Type
	 , a.RecipientFirstName AS Addr_F_Name, a.RecipientLastName AS Addr_L_Name, a.Line1, a.Line2, a.City, a.State, a.PostalCode, a.RecipientPhoneNumber AS Addr_Phone_Num
FROM Multipass.dbo.IssuedUser u WITH(NOLOCK)
	JOIN profile.KeyMap.CustomerKey c WITH(NOLOCK)
		ON u.OpenIDClaimedIdentifier = c.OpenIDClaimedIdentifier
	JOIN profile.dbo.Profile p WITH(NOLOCK)
		ON c.ProfileID = p.ProfileID
	LEFT JOIN profile.dbo.Address a WITH(NOLOCK)
		ON p.ProfileID = a.ProfileID
	LEFT JOIN profile.dbo.AddressType at WITH(NOLOCK)
		ON a.AddressTypeID = at.AddressTypeID
	LEFT JOIN profile.dbo.Phone ph WITH(NOLOCK)
		ON p.ProfileID = ph.ProfileID
	LEFT JOIN profile.dbo.Gender g WITH(NOLOCK)
		ON p.GenderID = g.GenderID
WHERE u.EmailAddress = 'email5659194849@gamestop.com'
ORDER BY a.AddressTypeID, a.DateModified


