DECLARE @ProjectID INT
DECLARE @PlanID INT

--to determine projectID:
--SELECT TOP 1000 * FROM Tfs_ecom.dbo.tbl_Project
SET @ProjectID = '14'

-- to determing planID:
--SELECT TOP 1000 * 
--FROM Tfs_ecom.dbo.tbl_Project pr 
--	JOIN Tfs_ecom.dbo.tbl_Plan pl 
--		ON pr.ProjectId = pl.ProjectId 
--AND pr.ProjectId = '14' -- 14 is FrontEndScrum
--ORDER BY pl.Name
SET @PlanID = '279'

SELECT TOP 100 pr.ProjectName
	, pl.Name
	, tr.DateCompleted, tr.TestCaseId, tr.TestCaseTitle
	, TestResult = 
		CASE tr.Outcome
			WHEN '1' THEN 'None'
			WHEN '2' THEN 'Passed'	
			WHEN '3' THEN 'Failed'
			WHEN '10' THEN 'error'
			WHEN '6' THEN 'Aborted'
			ELSE 'NoResult'
		END
	, a.AreaPath
		
FROM tfs_ecom.dbo.tbl_TestResult tr WITH(NOLOCK)
	LEFT JOIN Tfs_ecom.dbo.tbl_Area a WITH(NOLOCK)
		ON tr.AreaId = a.AreaId
	LEFT JOIN Tfs_ecom.dbo.tbl_TestRun run WITH(NOLOCK)
		ON tr.TestRunId = run.TestRunId
	LEFT JOIN Tfs_ecom.dbo.tbl_Project pr WITH(NOLOCK)
		ON run.ProjectId = pr.ProjectId
	LEFT JOIN Tfs_ecom.dbo.tbl_Plan pl
		ON pr.ProjectId = pl.ProjectId
WHERE pr.IsDeleted = 0
  AND tr.AutomatedTestId <> ''
  AND run.IsAutomated = '1'
  AND pr.ProjectId = @ProjectID
  AND pl.PlanId = @PlanID



SELECT TOP 1000 *
FROM Tfs_ecom.dbo.vw_TestResult
WHERE TestCaseId = '48601'

--Outcome
	--1 = none
	--2 = passed	
	--3 = failed
	--10 = error
	--6 = aborted
	