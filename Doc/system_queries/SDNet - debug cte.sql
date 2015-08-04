USE SDNet_Debug

SELECT DebugID
	,substring(CAST(Description AS CHAR (50)), 43, 7) as Order_ID
	,substring(CAST(Description AS CHAR (150)), 144, 5) as Fraud_Score
	,substring(CAST(Description AS CHAR (58)), 52, 6) as Accertify_Recommendation
	,CreateDate
	--,Location
	--,AssemblyName
FROM SDNet_Debug.dbo.sdnet_Debug WITH (NOLOCK)
WHERE CreateDate >= '2012-03-16 00:00:00.000'
	AND AssemblyName = 'Stardock.Store.Fraud'
ORDER BY CreateDate DESC

WITH DescCte /*Common Table Expression*/ AS (
	SELECT DebugID
		,Description = CONVERT(NVARCHAR(MAX), Description)
		,StartPos = CHARINDEX(N'Score:', CONVERT(NVARCHAR(MAX), Description))+7
		,EndPos = CHARINDEX(N'- -', CONVERT(NVARCHAR(MAX), Description), CHARINDEX(N'Score:', CONVERT(NVARCHAR(MAX), Description))+6) -1
	FROM dbo.sdnet_Debug
	WHERE Location = 'GameStopFraudService.FraudDetected()'
		 AND CreateDate >= '2012-03-08 10:00:00.000'
)
SELECT TOP 100 *
	,Length = CASE WHEN EndPos-StartPos < 1 THEN 1 ELSE EndPos-StartPos END
	,FraudScore = RTRIM(LTRIM(SUBSTRING(Description, StartPos, CASE WHEN EndPos-StartPos < 1 THEN 1 ELSE EndPos-StartPos END))) FROM DescCte ORDER BY DebugID DESC