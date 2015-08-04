SELECT  TOP 1 D.variantid AS variantid,A.displayname AS TITLE, D.cy_list_price AS PRICE,D.TaxabilityCode as taxabilitycode
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A 
WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid 
INNER JOIN (SELECT y.ProductID , 
count(*) 'Variant Count' 
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid 
GROUP BY productid HAVING COUNT(*) = 1 )  as Z 
ON z.ProductID = D.ProductID 
WHERE c.isavailable = 1 and c.variantid <> '' AND d.searchable = 1 AND i.onhandquantity > '10' AND A.displayname like '%iPad%' AND D.cy_list_price > '200.00'
ORDER BY newid()
