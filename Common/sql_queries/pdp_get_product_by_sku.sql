SELECT TOP <%=@params['return_product_num']%> 
	C.Availability, 
	C.ProductID, 
	D.variantid, 
	D.taxabilitycode, 
	d.esrbrating, 
	i.onhandquantity, 
	A.DisplayName, 
	C.condition, 
	c.isavailable, 
	d.searchable,
	c.OnlineOnlyPrice,
	i.OnHandQuantity,
	i.Backorderable, 
	i.BackorderLimit,
	i.Preorderable, 
	i.PreorderLimit

FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid
INNER JOIN [Gamestop_Catalog_GSProcesses].[dbo].[vw_EndecaCatalog_US_GameStopBase] m on c.variantid = m.[variant.SKU]
--INNER JOIN (SELECT y.ProductID , count(*) 'Variant Count' FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK)
--INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid
--GROUP BY productid HAVING COUNT(*) = 1 )  as Z ON z.ProductID = D.ProductID
WHERE 
	D.variantid in ('<%=@params['sku']%>') 
ORDER BY newid()
