SELECT top 1 C.Availability, C.ProductID, D.variantid, D.taxabilitycode, d.esrbrating, i.onhandquantity, A.DisplayName as Title, C.Condition, c.isavailable, d.searchable, i.PreorderAvailabilityDate, i.SuppressReleaseDate, i.PreorderLimit  ,d.EnableUpsellRecommendations, 
--replace(left(CONVERT(varchar(10),i.StreetDate,101),5),'0','')+RIGHT(CONVERT(varchar(10),i.StreetDate,101),5) as ReleaseDate
convert(varchar(2), month(i.StreetDate)) + '/' + convert(varchar(2), day(i.StreetDate)) + '/' + convert(varchar(4), year(i.StreetDate)) as ReleaseDate
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid
WHERE 
c.isavailable = 1 
AND i.SuppressReleaseDate = 1
AND i.StreetDate is not null
AND d.searchable = 1 
AND d.instorepickup = 1 
AND c.availability = 'PR' 
AND d.condition = 'Digital' 
AND c.variantid <> '0' AND c.variantid <> '' AND D.variantid not in ('859996','859997','859998') 
AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL)
AND i.StreetDate > GETDATE()
ORDER BY NEWID()

