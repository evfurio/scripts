SELECT COUNT(*)
FROM GI_CommunityServer.dbo.cs_Posts p (NOLOCK)
	JOIN GI_CommunityServer.dbo.cs_Users u (NOLOCK)
		ON p.UserID = u.UserID
WHERE u.UserName LIKE '%g_rcini%'
   OR u.UserName LIKE '%watch%vs%'
   OR u.UserName LIKE '%watch%live%'
   OR u.UserName LIKE '%watch%free%'
   OR u.UserName LIKE '%watch%tv%'
   OR u.UserName LIKE '%watch%hd%'
 
 
WITH Safe_CTE AS (
SELECT u.UserID
FROM GI_CommunityServer.dbo.cs_Users u
WHERE u.UserName IN 
(
 'giandy', 'giben', 'gibryan', 'gidan', 'gihanson', 'gijeff', 'gijeffm', 'gijoe', 'gikato', 'gikim', 'gikyle', 'laleh', 'gimatt', 'gibertz'
,'gimiller','gireiner', 'gitim', 'sopheava', 'gimike', 'giadam', 'subsaint', 'gijeffa', 'gi_5f00_jason', 'matt-akers', 'blogherding', 'liz-lanier'
,'brian albert', 'isaac perry', 'katherine seville', 'mike b trinh'
))
 
SELECT TOP 100 *
FROM GI_CommunityServer.dbo.cs_Posts p (NOLOCK)
	--JOIN Safe_CTE cte
	--	ON p.UserID = cte.UserID
WHERE p.[Subject] LIKE '%g_rc_ni%c_mb_gi%'
   OR p.[Subject] LIKE '%Watch%Live%fifa%'
   OR p.[Subject] LIKE '%Watch%Live%nfl%'
   OR p.[Subject] LIKE '%Watch%Live%nhl%'
   OR p.[Subject] LIKE '%vs%Stream%Football%' 
   OR p.[Subject] LIKE '%Watch%Live%Soccer%' 
   OR p.[Subject] LIKE '%vs%Live%Stream%online%' 
   OR p.[Subject] LIKE '%watch%episode%free%' 
   OR p.[Subject] LIKE '%search%optim%' 
   OR p.[Subject] LIKE '%@@@%'
   OR p.[Subject] LIKE '%{{{%' 
   OR p.[Subject] LIKE '%porn%live%' 
   OR p.[Subject] LIKE '%xxx%free%'
   
   
SELECT TOP 100 *
FROM GI_CommunityServer.dbo.cs_Posts p
	JOIN GI_CommunityServer.dbo.cs_Users u
		ON p.UserID = u.UserID
WHERE u.UserName IN
(
 'giandy', 'giben', 'gibryan', 'gidan', 'gihanson', 'gijeff', 'gijeffm', 'gijoe', 'gikato', 'gikim', 'gikyle', 'laleh', 'gimatt', 'gibertz'
,'gimiller','gireiner', 'gitim', 'sopheava', 'gimike', 'giadam', 'subsaint', 'gijeffa', 'gi_5f00_jason', 'matt-akers', 'blogherding', 'liz-lanier'
,'brian albert', 'isaac perry', 'katherine seville', 'mike b trinh'
)