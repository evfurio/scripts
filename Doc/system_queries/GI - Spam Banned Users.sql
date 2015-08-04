SELECT TOP 100 *
FROM GI_CommunityServer.dbo.cs_Users u (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_UserProfile up (NOLOCK)
		ON u.UserID = up.UserID
WHERE dbo.FetchExtendendAttributeValue('BanReason', up.PropertyNames, up.PropertyValues) = 'Spam'

SELECT TOP 100 *
FROM GI_CommunityServer.dbo.cs_Users u (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_Posts p (NOLOCK)
		ON u.UserID = p.UserID
	JOIN GI_CommunityServer.dbo.cs_UserProfile up (NOLOCK)
		ON u.UserID = up.UserID
WHERE dbo.FetchExtendendAttributeValue('BanReason', up.PropertyNames, up.PropertyValues) = 'Spam'

--level 10 + users  
SELECT TOP 1000 u.CreateDate, u.IsApproved, u.UserName, u.Email, up.Points, r.*
FROM GI_CommunityServer.dbo.cs_Users u (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_UserProfile up (NOLOCK)
		ON u.UserID = up.UserID
	JOIN GI_CommunityServer.dbo.cs_Security_UserRoles sur
		ON u.UserID = sur.UserId
	JOIN GI_CommunityServer.dbo.cs_Security_Roles r
		ON sur.RoleId = r.RoleId
WHERE dbo.FetchExtendendAttributeValue('UserStandardUserLevel', up.PropertyNames, up.PropertyValues) >= 10
  AND r.Name = 'Registered Users'
ORDER BY u.UserName

--editors and moderators
SELECT TOP 1000 u.CreateDate, u.IsApproved, u.UserName, u.Email, up.Points, r.*
FROM GI_CommunityServer.dbo.cs_Users u (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_UserProfile up (NOLOCK)
		ON u.UserID = up.UserID
	JOIN GI_CommunityServer.dbo.cs_Security_UserRoles sur
		ON u.UserID = sur.UserId
	JOIN GI_CommunityServer.dbo.cs_Security_Roles r
		ON sur.RoleId = r.RoleId
WHERE r.Name IN ('Editors', 'Moderators', 'Administrators')
ORDER BY u.UserName

