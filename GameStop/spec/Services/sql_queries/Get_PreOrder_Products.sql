SELECT top 1 D.variantid AS SKU, D.taxabilitycode, D.ESRBRating AS ESRB, D.ProductID AS PRODUCTID, A.DisplayName AS DISPLAY_NAME, D.cy_list_price AS LIST_PRICE, i.OnHandQuantity, d.productlimit, D.variantid, D.esrbrating
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
		AND d.searchable =1 AND D.ESRBRating != 'M' and d.instorepickup = 1
	ORDER BY NEWID()