
SELECT TOP 1000 u.CreateDate, u.Email, u.UserName, ur.UserId, sr.Name, sr.Description
FROM GI_CommunityServer.dbo.cs_Users u
	JOIN GI_CommunityServer.dbo.cs_Security_UserRoles ur
		ON u.UserID = ur.UserId
	JOIN GI_CommunityServer.dbo.cs_Security_Roles sr
		ON ur.RoleId = sr.RoleId
WHERE u.UserName LIKE '%jlafortu%'