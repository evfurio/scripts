
/*
UPDATE AllSpark_NA.dbo.Token 
SET IsUsed = 0
WHERE AllSparkID IN (31970, 22675, 33120)
*/
--522111/560001/520355 

SELECT COUNT(*), AllSparkID, IsUsed
FROM AllSpark_NA.dbo.Token t (NOLOCK)
WHERE AllSparkID IN (31970, 22675, 33120)
GROUP BY AllSparkID, IsUsed

SELECT COUNT(*), t.AllSparkID, p.IsUsed
FROM AllSpark_NA.dbo.Token t (NOLOCK)
	JOIN ProductCatalog.dbo.Products p (NOLOCK)
		ON t.AllSparkID = p.AllSparkID
WHERE p.SKU IN ('522111', '560001', '520355')
GROUP BY t.AllSparkID, p.IsUsed





