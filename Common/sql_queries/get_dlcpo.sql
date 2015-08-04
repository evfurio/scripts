SELECT top 1 
D.variantid, d.esrbrating, C.condition, A.DisplayName as Title, C.Availability, c.cy_list_price as Price, d.EnableUpsellRecommendations,
C.ProductID,  D.taxabilitycode, i.PreorderAvailabilityDate, i.StreetDate, i.SuppressReleaseDate
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid 
--WHERE 
--c.isavailable = 1 
--AND d.searchable = 1 
--AND d.instorepickup = 1 
--AND c.availability = 'PR' 
--AND d.condition = 'Digital' 
--AND c.variantid <> '0' AND c.variantid <> '' AND D.variantid not in ('859996','859997','859998') 
----AND c.productlimit is NULL 
--ORDER BY NEWID()

where D.variantid = '101969'