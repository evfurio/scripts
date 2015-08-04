SELECT TOP 1000 ur.*, u2.Email AS Reporter_Email, u.Email AS Post_Author, u.IsApproved  AS User_Approved, p.IsApproved AS Post_Approved, p.PostAuthor, p.ThreadID
FROM GI_CommunityServer.etl.UserReportedSpamPost ur (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_Posts p (NOLOCK)
		ON ur.PostId = p.PostID
	JOIN GI_CommunityServer.dbo.cs_Users u (NOLOCK)
		ON p.UserID = u.UserID
	JOIN GI_CommunityServer.dbo.cs_Users u2 (NOLOCK)
		ON ur.UserId = u2.UserID
ORDER BY ur.Created DESC
		
SELECT TOP 1000 *
FROM GI_CommunityServer.dbo.cs_Posts 
WHERE ThreadID = 880549
ORDER BY PostDate DESC