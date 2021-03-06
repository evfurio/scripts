SELECT DISTINCT TOP 1 D.variantid, D.esrbrating
--INTO ##VariantsToTest2
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid 
INNER JOIN (
SELECT y.ProductID , count(*) 'VariantCount' 
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid = x.skuvariantid 
GROUP BY productid HAVING COUNT(*) = 1 
) AS Z ON z.ProductID = D.ProductID 
WHERE c.isavailable = 1 
AND c.variantid <> '0' 
And c.variantid like '61%' 
AND c.variantid <> '' 
AND d.searchable = 1 
AND i.onhandquantity > '1000' 
AND d.condition = 'Digital'
AND c.productlimit is NULL
AND D.esrbrating = 'M'
AND D.variantid not in ('610507')
  UNION
SELECT DISTINCT TOP 1 D.variantid, D.esrbrating
--INTO ##VariantsToTest2
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid 
INNER JOIN (
SELECT y.ProductID , count(*) 'VariantCount' 
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid = x.skuvariantid 
GROUP BY productid HAVING COUNT(*) = 1 
) AS Z ON z.ProductID = D.ProductID 
WHERE c.isavailable = 1 
AND c.variantid <> '0' 
And c.variantid like '61%' 
AND c.variantid <> '' 
AND d.searchable = 1 
AND i.onhandquantity > '1000' 
AND d.condition = 'Digital'
AND c.productlimit is NULL
AND D.esrbrating != 'M'
AND D.variantid not in ('610507')