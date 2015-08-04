SELECT TOP 20000 /*p.ProjectName, pl.Name,*/ 
				 s0.Title AS MainFolder0_Title, s1.Title AS SubFolder1_Title, s2.Title AS SubFolder2_Title, w.Title AS TestCase_Title

FROM Tfs_ecom.dbo.tbl_Suite s0 WITH (NOLOCK)
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s1
		ON s0.SuiteId = s1.ParentSuiteId 
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s2 WITH (NOLOCK)
		ON s1.SuiteId = s2.ParentSuiteId
	LEFT JOIN Tfs_ecom.dbo.tbl_project p WITH (NOLOCK)
		ON s0.ProjectId = p.projectid
	LEFT JOIN Tfs_ecom.dbo.tbl_Plan pl WITH (NOLOCK)
		ON s0.ProjectId = pl.ProjectId AND s0.PlanId = pl.PlanId
	LEFT JOIN Tfs_ecom.dbo.tbl_SuiteEntry se WITH (NOLOCK)
		ON s0.SuiteId = se.SuiteId
	LEFT JOIN Tfs_ecom.dbo.WorkItemsAre w WITH (NOLOCK)
		ON se.TestCaseId = w.ID
WHERE 1=1
  AND w.State <> 'Closed'
  AND s0.planid = 42 --OR s1.PlanId = 42 OR s2.PlanId = 42 
  AND w.[Work Item Type] = 'Test Case'
  AND w.ID IS NOT NULL
ORDER BY s0.Title, s1.title, s2.Title


--
SELECT TOP 5000 i.Iteration, w.*--, .[Created Date], w.[Changed Date], w.[Work Item Type], w.Title, w.State, w.ID
FROM Tfs_ecom.dbo.tbl_Iteration i
	JOIN Tfs_ecom.dbo.WorkItemsAre w
		ON i.IterationId = w.IterationID
WHERE Iteration LIKE '%Impulse%'
ORDER BY w.ID, i.Iteration