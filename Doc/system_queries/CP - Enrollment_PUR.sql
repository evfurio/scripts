--enrollment check pre/post act.

DECLARE @EmailAddr NVARCHAR(100)
DECLARE @CardNumber NVARCHAR(50)

SET @EmailAddr = 'johntestcp01@gspcauto.fav.cc' 
SET @CardNumber = 3880010000356
--SET @Phone = '3875860326568'

SELECT 'Membership Info' AS 'Query_For:'
	 , m.CreatedDate, m.MembershipID, ms.Status AS MembershipStatus
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

SELECT 'Profile Info' AS 'Query_For:', * 
FROM profile.dbo.Profile p WITH(NOLOCK)
	JOIN profile.KeyMap.CustomerKey ck WITH(NOLOCK)
		ON p.ProfileID = ck.ProfileID
WHERE p.EmailAddress = @EmailAddr

--profile data
SELECT 'Personal Info' AS 'Query_For:'
	 , u.EmailAddress AS MultiPass_Email_Addr
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
WHERE u.EmailAddress = @EmailAddr
ORDER BY a.AddressTypeID, a.DateModified

--security questions and answers
SELECT TOP 100 r.*, pa.*--r.ResouceText, pa.AnswerText
FROM GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
	JOIN GenesisCorp.dbo.refResource r WITH(NOLOCK)
		ON pq.ResourceID = r.ResourceID
	JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
		ON pq.PreferenceQuestionID = pa.PreferenceQuestionID
WHERE pa.CustomerID = (SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = @EmailAddr)


