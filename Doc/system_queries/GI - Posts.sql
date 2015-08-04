DECLARE @PostTitle NVARCHAR(100)
SET @PostTitle = 'How To Get Rich Quick In Animal Crossing: New Leaf'

SELECT TOP 100 p.PostID, p.ParentID, p.ThreadID, p.PostAuthor, u.UserName, p.SortOrder, p.[Subject], p.PostDate, p.IsApproved, p.Body, p.SpamScore, p.PostStatus
  FROM GI_CommunityServer.dbo.cs_Posts p (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_Users u (NOLOCK)
		ON p.UserID = u.UserID
WHERE p.ThreadID = (SELECT TOP 1 ThreadID 
					FROM GI_CommunityServer.dbo.cs_Posts (NOLOCK)
					WHERE [Subject] LIKE @PostTitle)
  AND u.UserAccountStatus = 1
ORDER BY p.PostDate DESC

SELECT TOP 100 w.PageId, w.WikiId, us.UserName, w.Title, w.IsPublished, wc.Body
FROM GI_CommunityServer.dbo.cs_Wiki_Pages w (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_Users us (NOLOCK)
		ON w.UserId = us.UserID
	LEFT JOIN GI_CommunityServer.dbo.cs_Wiki_PageComments wc (NOLOCK)
		ON w.PageId = wc.PageId
WHERE w.PageId = (SELECT TOP 1 PageId
				  FROM GI_CommunityServer.dbo.cs_Wiki_Pages (NOLOCK)
				  WHERE Title LIKE @PostTitle)
ORDER BY w.LastModifiedUtcDate DESC