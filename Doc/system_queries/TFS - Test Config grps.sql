
--SELECT TOP 1000 *
--FROM [Tfs_ecom].[dbo].[WorkItemsAre] wia (NOLOCK)
--WHERE wia.[Work Item Type] = 'Test Case' 

DECLARE @PlanID INT
DECLARE @ProjectID INT

SET @PlanID = 454
SET @ProjectID = 14

SELECT s.SuiteId
	 , se.TestCaseId
	 , sc.ConfigurationId
	 , wia.Title
	 , p.*
FROM Tfs_ecom.dbo.tbl_Suite s
	LEFT JOIN Tfs_ecom.dbo.tbl_SuiteEntry se
		on se.SuiteId = s.SuiteId
	LEFT JOIN Tfs_ecom.dbo.tbl_SuiteConfiguration sc
		on s.SuiteId = sc.SuiteId
	LEFT JOIN Tfs_ecom.dbo.WorkItemsAre wia 
		on wia.ID = se.TestCaseId and wia.[Work Item Type] = 'Test Case'
	LEFT JOIN Tfs_ecom.dbo.tbl_Plan p
		on s.PlanID = p.PlanID
WHERE s.PlanId = @PlanID 
  AND s.ProjectID = @ProjectID
  AND wia.ID IS NOT NULL
  and sc.ConfigurationId is not null
