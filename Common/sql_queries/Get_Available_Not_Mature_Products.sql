SELECT top 1
D.variantid, d.esrbrating, C.condition, A.DisplayName as Title, C.Availability, c.cy_list_price as Price, d.EnableUpsellRecommendations,
C.ProductID,  D.taxabilitycode
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
	WHERE c.availability = 'A' 
	  and c.isavailable = 1 
	  and c.variantid <> '0' 
	  and c.variantid <> '' 
	  AND d.searchable = 1 
	  AND i.onhandquantity > '100' 
	  AND c.condition != 'Digital' 
      AND c.condition != 'Download' 
      AND c.condition != 'Warranty'
      AND c.productlimit is NULL 
	  AND D.esrbrating != 'M'
	  and D.variantid not in ('859996','859998', '859997')
	  AND c.condition != 'Warranty'
	   AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL) 
	  ORDER BY NEWID()
