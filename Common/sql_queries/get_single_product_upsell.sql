SELECT TOP 1 
D.variantid, d.esrbrating, C.condition, A.DisplayName as Title, C.Availability, c.cy_list_price as Price, d.EnableUpsellRecommendations,
C.ProductID,  D.taxabilitycode
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid 
INNER JOIN (SELECT y.ProductID , count(*) 'Variant Count' FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK)
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid
GROUP BY productid HAVING COUNT(*) = 1 )  as Z ON z.ProductID = D.ProductID
WHERE c.availability in ('A','PR') and c.isavailable = 1 and c.variantid <> '0' and c.variantid <> '' AND c.condition != 'Warranty'
AND d.searchable =1 AND D.ProductLimit is NULL AND i.onhandquantity > '1' AND d.EnableUpsellRecommendations = 1
--WHERE c.VariantID = '270207'
ORDER BY newid()
