select 
variantid, esrbrating, condition, Title, Availability, Price, EnableUpsellRecommendations,
ProductID, taxabilitycode
from (
SELECT TOP 1 
D.variantid, d.esrbrating, C.condition, A.DisplayName as Title, C.Availability, c.cy_list_price as Price, d.EnableUpsellRecommendations,
C.ProductID,  D.taxabilitycode
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
AND c.Availability = 'BO'
AND c.variantid <> '0' and c.variantid <> '' 
AND c.condition != 'Digital' and c.condition != 'Download' AND c.condition != 'Warranty'
AND d.searchable = 1 
AND i.onhandquantity <= '0' 
AND c.productlimit is NULL
AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL)

ORDER BY NEWID() ) BACK
UNION 
select 
variantid, esrbrating, condition, Title, Availability, Price, EnableUpsellRecommendations,
ProductID, taxabilitycode
from (
SELECT top 1 D.variantid, d.esrbrating, C.condition, A.DisplayName as Title, C.Availability, c.cy_list_price as Price, d.EnableUpsellRecommendations, C.ProductID,  D.taxabilitycode
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
	INNER JOIN 
		  [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid
	INNER JOIN 
	      [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
	INNER JOIN 
	      [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid
	INNER JOIN
		  [Gamestop_Catalog_GSProcesses].[dbo].[vw_EndecaCatalog_US_GameStopBase] m on c.variantid = m.[variant.SKU]
	INNER JOIN
(SELECT y.ProductID , count(*) 'Variant Count' 
	FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK)
		INNER JOIN 
			[Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid
		GROUP BY productid
		HAVING COUNT(*) = 1 
		)  as Z
	ON z.ProductID = D.ProductID
	WHERE c.availability = 'A' and c.isavailable = 1 and c.variantid <> '0' and c.variantid <> '' 
		AND d.searchable =1 AND i.onhandquantity > '5'  AND c.productlimit is NULL 
		AND c.condition != 'Digital' and c.condition != 'Download' AND c.condition != 'Warranty'
		AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL)

ORDER BY NEWID() ) AVAIL