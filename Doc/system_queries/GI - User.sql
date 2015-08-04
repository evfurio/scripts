SELECT TOP 1000 *
FROM GI_CommunityServer.dbo.aspnet_Membership m (NOLOCK)
	JOIN GI_CommunityServer.dbo.aspnet_Users u (NOLOCK)
		ON m.UserId = u.UserId
	JOIN GI_CommunityServer.dbo.aspnet_Profile p (NOLOCK)
		ON u.UserId = p.UserId
	JOIN GI_CommunityServer.dbo.aspnet_Roles r
		ON m.ApplicationId = r.ApplicationId
WHERE m.Email = 'jontestqa1@gspcauto.fav.cc'