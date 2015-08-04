
--SELECT * FROM GI_CommunityServer.dbo.GI_ProductCatalog WHERE Title LIKE '%fifa%'

--weblog
DECLARE @GIProdID NVARCHAR(10)
DECLARE @GroupID INT
SET @GIProdID = '60809'

SELECT @GroupID = g.GroupID
FROM GI_CommunityServer.dbo.GI_ProductCatalog pc
	JOIN GI_CommunityServer.dbo.cs_Sections s
		ON pc.BlogID = s.SectionID
	JOIN GI_CommunityServer.dbo.cs_Groups g
		ON s.GroupID = g.GroupID
WHERE pc.GIProductID = @GIProdID

SELECT COUNT(*) AS WEBLOG_COUNT
FROM GI_CommunityServer.dbo.cs_Sections s
WHERE s.GroupID = @GroupID
  AND s.ApplicationType = 1
  
--user reviews
SELECT @GroupID = g.GroupID
FROM GI_CommunityServer.dbo.GI_ProductCatalog pc
	JOIN GI_CommunityServer.dbo.cs_Sections s
		ON pc.BlogID = s.SectionID
	JOIN GI_CommunityServer.dbo.cs_Groups g
		ON s.GroupID = g.GroupID
WHERE pc.GIProductID = @GIProdID

SELECT COUNT(*) AS USER_REVIEW_COUNT
FROM GI_CommunityServer.dbo.cs_Sections s
	JOIN GI_CommunityServer.dbo.cs_Posts p
		ON s.SectionID = p.SectionID
		
WHERE s.GroupID = @GroupID
  AND s.Name = 'User Reviews'

--forums
SELECT @GroupID = g.GroupID
FROM GI_CommunityServer.dbo.GI_ProductCatalog pc
	JOIN GI_CommunityServer.dbo.cs_Sections s
		ON pc.BlogID = s.SectionID
	JOIN GI_CommunityServer.dbo.cs_Groups g
		ON s.GroupID = g.GroupID
WHERE pc.GIProductID = @GIProdID

SELECT COUNT(*) AS FORUM_COUNT
FROM GI_CommunityServer.dbo.cs_Sections s
	JOIN GI_CommunityServer.dbo.cs_Posts p
		ON s.SectionID = p.SectionID
	JOIN GI_CommunityServer.dbo.cs_ApplicationType at
		ON s.ApplicationType = at.ApplicationType
WHERE s.GroupID = @GroupID
  AND at.ApplicationName = 'Forum'

--media gallery
SELECT @GroupID = g.GroupID
FROM GI_CommunityServer.dbo.GI_ProductCatalog pc
	JOIN GI_CommunityServer.dbo.cs_Sections s
		ON pc.BlogID = s.SectionID
	JOIN GI_CommunityServer.dbo.cs_Groups g
		ON s.GroupID = g.GroupID
WHERE pc.GIProductID = @GIProdID

SELECT COUNT(*) AS MEDIA_GALLERY_COUNT
FROM GI_CommunityServer.dbo.cs_Sections s
	JOIN GI_CommunityServer.dbo.cs_Posts p
		ON s.SectionID = p.SectionID
	JOIN GI_CommunityServer.dbo.cs_ApplicationType at
		ON s.ApplicationType = at.ApplicationType
WHERE s.GroupID = @GroupID
  AND at.ApplicationName = 'MediaGallery'

--wiki
SELECT @GroupID = g.GroupID
FROM GI_CommunityServer.dbo.GI_ProductCatalog pc
	JOIN GI_CommunityServer.dbo.cs_Sections s
		ON pc.BlogID = s.SectionID
	JOIN GI_CommunityServer.dbo.cs_Groups g
		ON s.GroupID = g.GroupID
WHERE pc.GIProductID = @GIProdID

SELECT COUNT(*) AS WIKI_PAGES_COUNT
FROM GI_CommunityServer.dbo.cs_Wiki_Wikis ww
	JOIN GI_CommunityServer.dbo.cs_Wiki_Pages wp
		ON ww.WikiId = wp.WikiId
WHERE ww.GroupID = @GroupID

