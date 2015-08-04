--wiki with banned (spam) user author
SELECT TOP 1000 'SpamUserWiki' AS 'Query For:'
  ,	wp.PageId, wp.WikiId, wp.Title, wp.IsPublished, wp.IsIndexed, wp.LastModifiedUtcDate
  , u.UserID, u.Email
  , CASE u.UserAccountStatus
      WHEN 0 THEN 'ApprovalPending'
      WHEN 1 THEN 'Approved' 
      WHEN 2 THEN 'Banned'
      WHEN 3 THEN 'Disapproved'
      ELSE NULL
    END AS UserStatus
  , u.UserName
FROM GI_CommunityServer.dbo.cs_Wiki_Pages wp (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_Users u (NOLOCK)
		ON wp.UserId = u.UserID
WHERE wp.LastModifiedUtcDate <= (GETDATE() - 7)
  AND u.UserAccountStatus = 2

--wiki marked as spam
SELECT TOP 1000 'SpamWikiTest' AS 'Query For:'
  ,	wp.PageId, wp.WikiId, wp.Title, wp.IsPublished, wp.IsIndexed, wp.LastModifiedUtcDate
  , u.UserID, u.Email, u.UserAccountStatus
  , CASE u.UserAccountStatus
      WHEN 0 THEN 'ApprovalPending'
      WHEN 1 THEN 'Approved' 
      WHEN 2 THEN 'Banned'
      WHEN 3 THEN 'Disapproved'
      ELSE NULL
    END AS UserStatus
  , u.UserName
FROM GI_CommunityServer.dbo.cs_Wiki_Pages wp (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_Users u (NOLOCK)
		ON wp.UserId = u.UserID
WHERE wp.LastModifiedUtcDate <= (GETDATE() - 7)
  AND wp.IsPublished = 0

--post with banned (spam) user author
SELECT TOP 1000 'SpamUserPost' AS 'Query For:'
  ,	p.PostID, p.ThreadID, p.[Subject], p.PostAuthor, p.IsApproved, p.PostName, p.IsIndexed, p.PostDate
  , u.UserID, u.Email
  , CASE u.UserAccountStatus
      WHEN 0 THEN 'ApprovalPending'
      WHEN 1 THEN 'Approved' 
      WHEN 2 THEN 'Banned'
      WHEN 3 THEN 'Disapproved'
      ELSE NULL
    END AS UserStatus
  , u.UserName
FROM GI_CommunityServer.dbo.cs_posts p (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_Users u (NOLOCK)
		ON p.UserId = u.UserID
WHERE p.PostDate <= (GETDATE() - 7)
  AND u.UserAccountStatus = 2

--post marked as spam
SELECT TOP 1000 'SpamPostTest' AS 'Query For:'
  ,	p.PostID, p.ThreadID, p.[Subject], p.PostAuthor, p.IsApproved, p.PostName, p.IsIndexed, p.PostDate
  , u.UserID, u.Email
  , CASE u.UserAccountStatus
      WHEN 0 THEN 'ApprovalPending'
      WHEN 1 THEN 'Approved' 
      WHEN 2 THEN 'Banned'
      WHEN 3 THEN 'Disapproved'
      ELSE NULL
    END AS UserStatus
  , u.UserName
FROM GI_CommunityServer.dbo.cs_posts p (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_Users u (NOLOCK)
		ON p.UserId = u.UserID
WHERE p.PostDate <= (GETDATE() - 7)
  AND p.IsApproved = 0