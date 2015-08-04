SELECT  TOP 2 D.variantid,D.variantid SKU, D.taxabilitycode, d.esrbrating,i.onhandquantity OnHandQuantity FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid 
INNER JOIN (SELECT y.ProductID , count(*) 'Variant Count' FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid GROUP BY productid HAVING COUNT(*) = 1 )  as Z ON z.ProductID = D.ProductID 
WHERE c.isavailable = 1 and c.variantid <> '0' and c.variantid <> '' AND d.searchable =1 AND i.onhandquantity > '1000' AND c.condition != 'Digital' and c.condition != 'Download' AND
D.ProductLimit is NULL AND D.InternationalShippingRestrictions is not Null and D.InternationalShippingRestrictions = 'No Restriction' 
ORDER BY newid()		