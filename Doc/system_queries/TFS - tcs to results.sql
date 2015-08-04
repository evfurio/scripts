
WITH tests_cte AS (
SELECT TOP 1000 se.TestCaseId
  FROM [Tfs_ecom].[dbo].[tbl_Suite] s 
  join Tfs_ecom.dbo.tbl_SuiteEntry se
	on s.SuiteId = se.SuiteId
	  where Title = '69368: US4430 - PCD: Price Threshold in Catalog'
  and s.ProjectId = '14'
  and s.PlanId = '522'
)
SELECT TOP 1000 wia.Title, wia.[Work Item Type], Fld10048,
  		CASE tr.Outcome
			WHEN '1' THEN 'None'
			WHEN '2' THEN 'Passed'	
			WHEN '3' THEN 'Failed'
			WHEN '10' THEN 'error'
			WHEN '6' THEN 'Aborted'
			ELSE 'NoResult'
		END
  FROM [Tfs_ecom].[dbo].[WorkItemsAre] wia
   left outer join Tfs_ecom.dbo.tbl_TestResult tr
	on wia.ID = tr.TestCaseId
	join tests_cte
		on wia.ID = tests_cte.TestCaseId



WITH SuiteIDs_cte (SuiteID, ParentSuiteID, Title)
AS
(
SELECT s0.SuiteId, s0.ParentSuiteId, s0.Title
FROM Tfs_ecom.dbo.tbl_Suite s0
WHERE s0.ProjectId = '14'
  AND s0.PlanId = '522'
  --AND s0.Title = '70114: US4238 - PLCC: Auth&Set-Implement new path and provider for 0 dollar authorization for CheckFraud operation'
UNION ALL
SELECT s1.SuiteId, s1.ParentSuiteId, s1.Title
FROM Tfs_ecom.dbo.tbl_Suite s1
	INNER JOIN SuiteIDs_cte cte
		ON s1.SuiteId = cte.ParentSuiteID

)  
SELECT * FROM SuiteIDs_cte order by Title OPTION (MAXRECURSION 5)

--