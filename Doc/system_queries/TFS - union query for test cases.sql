DECLARE @PlanID INT
DECLARE @ProjectID INT
--DECLARE @T_C_Title NVARCHAR(55)

SET @PlanID = 457
SET @ProjectID = 14
--SET @T_C_Title = '%create%'

SELECT p1.Name
	 , s1.Title AS Folder1, s2.Title AS Folder2, s3.Title AS Folder3, s4.Title AS Folder4, s5.Title AS Folder5, s6.Title AS Folder6
	 , wia.ID AS TC_ID_Nbr, wia.Title AS TC_Title, wia.State
FROM Tfs_ecom.dbo.tbl_Suite s1
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s2 
		on s1.SuiteId = s2.parentsuiteid
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s3 
		on s2.SuiteId = s3.ParentSuiteId
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s4 
		on s3.SuiteId = s4.ParentSuiteId
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s5 
		on s4.SuiteId = s5.ParentSuiteId
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s6 
		on s5.SuiteId = s6.ParentSuiteId		
	LEFT JOIN Tfs_ecom.dbo.tbl_SuiteEntry se 
		on se.SuiteId = s6.SuiteId
	LEFT JOIN Tfs_ecom.dbo.WorkItemsAre wia 
		on wia.ID = se.TestCaseId and wia.[Work Item Type] = 'Test Case'
	LEFT JOIN Tfs_ecom.dbo.tbl_Plan p1
		on s1.PlanID = p1.PlanID
WHERE 1=1 
  AND s1.PlanId = @PlanID 
  AND s1.ProjectID = @ProjectID
  AND wia.ID IS NOT NULL
  AND s1.Title = '<root>'
  --AND  wia.Title LIKE @T_C_Title
  
UNION
  
SELECT p2.Name
	 , s11.Title AS Folder1, s12.Title  AS Folder2, s13.Title AS Folder3, s14.Title AS Folder4, s15.Title AS Folder5, s16.Title AS Folder6
	 , wia1.ID AS TC_ID_Nbr, wia1.Title AS TC_Title, wia1.State
FROM Tfs_ecom.dbo.tbl_Suite s11
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s12 
		on s11.SuiteId = NULL
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s13 
		on s12.SuiteId = NULL
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s14 
		on s13.SuiteId = NULL
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s15 
		on s14.SuiteId = NULL	
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s16 
		on s15.SuiteId = NULL			
	LEFT JOIN Tfs_ecom.dbo.tbl_SuiteEntry se1
		on se1.SuiteId = s11.SuiteId
	LEFT JOIN Tfs_ecom.dbo.WorkItemsAre wia1 
		on wia1.ID = se1.TestCaseId and wia1.[Work Item Type] = 'Test Case'	
	LEFT JOIN Tfs_ecom.dbo.tbl_Plan p2
		on s11.PlanID = p2.PlanID		
WHERE 1=1
AND s11.PlanId = @PlanID
AND s11.ProjectID = @ProjectID
AND wia1.ID IS NOT NULL
AND s11.Title = '<root>' 
--AND wia1.Title LIKE @T_C_Title

UNION

SELECT p3.Name
	 , s21.Title AS Folder1, s22.Title  AS Folder2, s23.Title AS Folder3, s24.Title AS Folder4, s25.Title AS Folder5, s26.Title AS Folder6
	 , wia2.ID AS TC_ID_Nbr, wia2.Title AS TC_Title, wia2.State
FROM Tfs_ecom.dbo.tbl_Suite s21
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s22 
		on s21.SuiteId = s22.parentsuiteid
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s23 
		on s22.SuiteId = NULL
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s24 
		on s23.SuiteId = NULL
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s25 
		on s24.SuiteId = NULL		
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s26 
		on s25.SuiteId = NULL			
	LEFT JOIN Tfs_ecom.dbo.tbl_SuiteEntry se2 
		on se2.SuiteId = s22.SuiteId
	LEFT JOIN Tfs_ecom.dbo.WorkItemsAre wia2 
		on wia2.ID = se2.TestCaseId and wia2.[Work Item Type] = 'Test Case'
	LEFT JOIN Tfs_ecom.dbo.tbl_Plan p3
		on s21.PlanID = p3.PlanID	
WHERE 1=1
AND s21.PlanId = @PlanID
AND s21.ProjectID = @ProjectID
AND wia2.ID IS NOT NULL
AND s21.Title = '<root>'
--AND wia2.Title LIKE @T_C_Title

UNION

SELECT p4.Name
	 , s31.Title AS Folder1, s32.Title AS Folder2, s33.Title AS Folder3, s34.Title AS Folder4, s35.Title AS Folder5, s36.Title AS Folder6
	 , wia3.ID AS TC_ID_Nbr, wia3.Title AS TC_Title, wia3.State
FROM Tfs_ecom.dbo.tbl_Suite s31
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s32 
		on s31.SuiteId = s32.parentsuiteid
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s33 
		on s32.SuiteId = s33.parentsuiteid
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s34 
		on s33.SuiteId = NULL
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s35 
		on s34.SuiteId = NULL	
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s36 
		on s35.SuiteId = NULL			
	LEFT JOIN Tfs_ecom.dbo.tbl_SuiteEntry se3 
		on se3.SuiteId = s33.SuiteId
	LEFT JOIN Tfs_ecom.dbo.WorkItemsAre wia3 
		on wia3.ID = se3.TestCaseId and wia3.[Work Item Type] = 'Test Case'
	LEFT JOIN Tfs_ecom.dbo.tbl_Plan p4
		on s31.PlanID = p4.PlanID		
WHERE 1=1
AND s31.PlanId = @PlanID
AND s31.ProjectID = @ProjectID
AND wia3.ID IS NOT NULL
AND s31.Title = '<root>'
--AND wia3.Title LIKE @T_C_Title

UNION

SELECT p5.Name
	 , s41.Title AS Folder1, s42.Title AS Folder2, s43.Title AS Folder3, s44.Title AS Folder4, s45.Title AS Folder5, s46.Title AS Folder6
	 , wia4.ID AS TC_ID_Nbr, wia4.Title AS TC_Title, wia4.State
FROM Tfs_ecom.dbo.tbl_Suite s41
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s42 
		on s41.SuiteId = s42.parentsuiteid
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s43 
		on s42.SuiteId = s43.parentsuiteid
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s44 
		on s43.SuiteId = s44.ParentSuiteId
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s45 
		on s44.SuiteId = NULL	
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s46 
		on s45.SuiteId = NULL			
	LEFT JOIN Tfs_ecom.dbo.tbl_SuiteEntry se4 
		on se4.SuiteId = s44.SuiteId
	LEFT JOIN Tfs_ecom.dbo.WorkItemsAre wia4 
		on wia4.ID = se4.TestCaseId and wia4.[Work Item Type] = 'Test Case'
	LEFT JOIN Tfs_ecom.dbo.tbl_Plan p5
		on s41.PlanID = p5.PlanID
WHERE 1=1
AND s41.PlanId = @PlanID
AND s41.ProjectID = @ProjectID
AND wia4.ID IS NOT NULL
AND s41.Title = '<root>'
--AND wia4.Title LIKE @T_C_Title

UNION

SELECT p6.Name
	 , s51.Title AS Folder1, s52.Title AS Folder2, s53.Title AS Folder3, s54.Title AS Folder4, s55.Title AS Folder5, s56.Title AS Folder6
	 , wia5.ID AS TC_ID_Nbr, wia5.Title AS TC_Title, wia5.State
FROM Tfs_ecom.dbo.tbl_Suite s51
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s52 
		on s51.SuiteId = s52.parentsuiteid
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s53 
		on s52.SuiteId = s53.parentsuiteid
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s54 
		on s53.SuiteId = s54.ParentSuiteId
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s55 
		on s54.SuiteId = s55.ParentSuiteId
	LEFT JOIN Tfs_ecom.dbo.tbl_Suite s56 
		on s55.SuiteId = NULL					
	LEFT JOIN Tfs_ecom.dbo.tbl_SuiteEntry se5 
		on se5.SuiteId = s55.SuiteId
	LEFT JOIN Tfs_ecom.dbo.WorkItemsAre wia5 
		on wia5.ID = se5.TestCaseId and wia5.[Work Item Type] = 'Test Case'
	LEFT JOIN Tfs_ecom.dbo.tbl_Plan p6
		on s51.PlanID = p6.PlanID		
WHERE 1=1
AND s51.PlanId = @PlanID
AND s51.ProjectID = @ProjectID
AND wia5.ID IS NOT NULL
AND s51.Title = '<root>'
--AND wia5.Title LIKE @T_C_Title

ORDER BY 1, 2, 3, 4, 5, 6