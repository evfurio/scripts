SELECT TOP 100 u.Email, u.UserName, u.CreateDate, DATEDIFF(DAY, u.CreateDate, GETDATE()) AS AcctAgeInDays, u.IsApproved, u.UserAccountStatus, up.Points, us.*
FROM GI_CommunityServer.dbo.cs_Users u (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_UserProfile up
		ON u.UserID = up.UserID
	LEFT JOIN GISite.cir.UserSubscriber us
		ON u.MembershipID = us.UserId
WHERE u.UserName = 'jlafortudm0'
ORDER BY up.Points DESC

