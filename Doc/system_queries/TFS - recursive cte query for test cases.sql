WITH Recursive_CTE AS 
(
--initialization
SELECT s1.Title, wia.ID, wia.Title, wia.State
FROM tbl_Suite s1
	JOIN tbl_SuiteEntry se
		ON s1.SuiteId = se.SuiteId
	JOIN WorkItemsAre wia
		ON se.TestCaseId = wia.ID
WHERE s1.ProjectId = 14 and s1.PlanId = 454
UNION ALL
--recursive execution
SELECT s1.Title, wia.ID, wia.Title, wia.State
FROM tbl_Suite s1
	JOIN tbl_SuiteEntry se
		ON s1.SuiteId = se.SuiteId
	JOIN WorkItemsAre wia
		ON se.TestCaseId = wia.ID
	INNER JOIN Recursive_CTE r ON s1.ParentSuiteId = s1.SuiteId
)
SELECT * 
FROM Recursive_CTE 
ORDER BY Recursive_CTE.Title
OPTION (MAXRECURSION 5) 