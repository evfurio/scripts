SELECT TOP 5 c.availability, c.isavailable, d.searchable, D.taxabilitycode, D.variantid AS SKU,D.ProductID AS PRODUCTID, i.skuvariantid, m.[variant.SKU], A.DisplayName AS DISPLAY_NAME, D.cy_list_price AS LIST_PRICE, i.OnHandQuantity, m.[variant.Availability]
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
		AND d.searchable =1 AND c.IsDropShip = 1 AND c.condition != 'Digital' and c.condition != 'Download'
		AND i.onhandquantity >5
		AND d.esrbrating <> 'M' AND a.producttype = 'Games' 
		ORDER BY NEWID()