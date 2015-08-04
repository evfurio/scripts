select
variantid, esrbrating, condition, Title, Availability, Price, EnableUpsellRecommendations,
ProductID,  taxabilitycode, PreorderAvailabilityDate, StreetDate, SuppressReleaseDate
from (
SELECT TOP 1
D.variantid, d.esrbrating, C.condition, A.DisplayName as Title, C.Availability, c.cy_list_price as Price, d.EnableUpsellRecommendations,
C.ProductID,  D.taxabilitycode, i.PreorderAvailabilityDate, i.StreetDate, i.SuppressReleaseDate
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
--WHERE c.isavailable = 1
--AND c.variantid <> '0'
--AND c.variantid <> ''
--AND d.searchable = 1
--AND i.onhandquantity > '1000'
--AND d.condition = 'Digital'
--AND c.productlimit is NULL
--AND D.variantid not in ('859996','859998')
--AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL)
where D.variantid = '101969'
ORDER BY NEWID() ) DGTL
UNION
select
variantid, esrbrating, condition, Title, Availability, Price, EnableUpsellRecommendations,
ProductID,  taxabilitycode, PreorderAvailabilityDate, StreetDate, SuppressReleaseDate
from (
SELECT top 1
D.variantid, d.esrbrating, C.condition, A.DisplayName as Title, C.Availability, c.cy_list_price as Price, d.EnableUpsellRecommendations,
C.ProductID,  D.taxabilitycode, i.PreorderAvailabilityDate, i.StreetDate, i.SuppressReleaseDate
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
	WHERE c.availability = 'PR' and c.isavailable = 1 and c.variantid <> '0' and c.variantid <> ''
		AND d.searchable =1 AND i.onhandquantity > '5'  AND c.productlimit is NULL AND d.condition <> 'Digital'
		AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL)

ORDER BY NEWID() ) AVAIL
UNION
select
variantid, esrbrating, condition, Title, Availability, Price, EnableUpsellRecommendations,
ProductID,  taxabilitycode, PreorderAvailabilityDate, StreetDate, SuppressReleaseDate
from (
SELECT top 1
D.variantid, d.esrbrating, C.condition, A.DisplayName as Title, C.Availability, c.cy_list_price as Price, d.EnableUpsellRecommendations,
C.ProductID,  D.taxabilitycode, i.PreorderAvailabilityDate, i.StreetDate, i.SuppressReleaseDate
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
	INNER JOIN
		  [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid
	INNER JOIN
	      [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid
	INNER JOIN
	      [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid
	INNER JOIN
	--	  [Gamestop_Catalog_GSProcesses].[dbo].[vw_EndecaPlatforms_US_GameStopBase] m on c.variantid = m.variant.BaseCatalogSKU
	-- INNER JOIN
(SELECT y.ProductID , count(*) 'Variant Count'
	FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK)
		INNER JOIN
			[Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid
		GROUP BY productid
		HAVING COUNT(*) = 1
		)  as Z
	ON z.ProductID = D.ProductID
	WHERE c.availability = 'PR' and c.variantid <> '0' and c.variantid <> ''
		AND d.searchable =1 and d.instorepickup = 1	 AND c.productlimit is NULL
		AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL)

ORDER BY NEWID() ) PRE

-- *******USED When DLC/Digital products were severely out of sync on inventory.
-- SELECT top 2
-- D.variantid, d.esrbrating, C.condition, A.DisplayName as Title, C.Availability, c.cy_list_price as Price, d.EnableUpsellRecommendations,
-- C.ProductID,  D.taxabilitycode, i.PreorderAvailabilityDate, i.StreetDate, i.SuppressReleaseDate
-- FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
-- 	INNER JOIN
-- 		  [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid
-- 	INNER JOIN
-- 	      [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid
-- 	INNER JOIN
-- 	      [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid
-- WHERE d.VariantID in ('101969', '103057')