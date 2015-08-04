SELECT p.ProductID ,p.SKU, p.AllSparkID,COUNT(*) as TokenCount 
  FROM  [ProductCatalog].[dbo].[Products] p inner join  AllSpark_NA.dbo.[Token] T 
  on p.AllSparkID=T.AllSparkID  
  Group by p.ProductID ,p.SKU, p.AllSparkID
Having COUNT(*) = 1

