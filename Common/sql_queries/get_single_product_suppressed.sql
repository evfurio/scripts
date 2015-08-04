SELECT top 1 C.Availability, C.ProductID, D.variantid, D.taxabilitycode, d.esrbrating, i.onhandquantity, A.DisplayName as Title, C.Condition, c.isavailable, d.searchable, i.PreorderAvailabilityDate, replace(left(CONVERT(varchar(10),i.StreetDate,101),5),'0','')+RIGHT(CONVERT(varchar(10),i.StreetDate,101),5) as ReleaseDate, i.SuppressReleaseDate, i.PreorderLimit  ,d.EnableUpsellRecommendations
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid 
INNER JOIN (SELECT y.ProductID , count(*) 'Variant Count' FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK) 
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid 
GROUP BY productid HAVING COUNT(*) = 1 )  as Z ON z.ProductID = D.ProductID 
WHERE 
c.availability = 'PR' and 
d.instorepickup = 1 and
i.SuppressReleaseDate = 1 and
c.isavailable = 1 and 
d.searchable =1  and
c.condition not in ('Digital', 'Download', 'Warranty') and
c.variantid <> '0' and c.variantid <> '' and D.variantid not in ('859996','859998', '859997') and
(d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL)

ORDER BY newid()

--select distinct condition from [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts]