SELECT *
FROM GSEDW.dbo.Dim_PurccAnalysisType pat
	LEFT JOIN GSEDW.dbo.AnalysisTypeGroup atg
		ON pat.AnalysisTypeGroupID = atg.AnalysisTypeGroupID
--WHERE pat.AnalysisTypeGroupID = 6
ORDER BY pat.AnalysisTypeGroupID
		
--applicants
SELECT TOP 1 *
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35 
ORDER BY pa.DateKey DESC

SELECT SUM(pa.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Applicants pa
WHERE pa.AnalysisTypeID = 35
  AND s.DivisionID = 1
  AND pa.DateKey BETWEEN @StartDate AND @EndDate

--members
SELECT COUNT(pm.AnalysisCount)
FROM GSEDW.dbo.Fct_PURCC_Members pm
WHERE pm.AnalysisTypeID = 19
  AND pm.DateKey BETWEEN @StartDate AND @EndDate

  
--tenders
SELECT *
FROM GSEDW.dbo.Fct_PURCC_Tenders pt
WHERE pt.AnalysisTypeID = 100
  AND pt.DateKey BETWEEN @StartDate AND @EndDate