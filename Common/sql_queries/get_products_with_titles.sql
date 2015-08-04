SELECT  TOP 1 D.variantid, D.taxabilitycode, A.[DisplayName] as title ,d.EnableUpsellRecommendations
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D 
on A.#Catalog_Lang_Oid = D.oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C 
on C.Oid = A.#Catalog_Lang_Oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i 
on c.variantid = i.skuvariantid 
INNER JOIN 
(SELECT y.ProductID , count(*) 'Variant Count' 
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x 
on y.variantid= x.skuvariantid 
GROUP BY productid 
HAVING COUNT(*) = 1 )  as Z ON z.ProductID = D.ProductID 
WHERE c.isavailable = 1 and c.variantid <> '0' and c.variantid <> '' AND
 d.searchable =1 AND i.onhandquantity > '1000' AND c.condition != 'Digital' and
  c.condition != 'Download' and c.productlimit is NULL and D.variantid not in ('859996','859998')
  AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL)
ORDER BY newid()