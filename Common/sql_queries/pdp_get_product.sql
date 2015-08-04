SELECT TOP <%=@params['return_product_num']%> 
	C.Availability, 
	C.ProductID, 
	D.variantid, 
	D.taxabilitycode, 
	d.esrbrating, 
	i.onhandquantity, 
	A.DisplayName as Title, 
	C.condition, 
	c.isavailable, 
	d.searchable

FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid
INNER JOIN [Gamestop_Catalog_GSProcesses].[dbo].[vw_EndecaCatalog_US_GameStopBase] m on c.variantid = m.[variant.SKU]
INNER JOIN (SELECT y.ProductID , count(*) 'Variant Count' FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK)
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid
GROUP BY productid HAVING COUNT(*) = 1 )  as Z ON z.ProductID = D.ProductID

WHERE 
	c.availability in ('<%=@availability%>') AND 
	c.isavailable = 1 and d.searchable =1  AND 
	c.condition in ('<%=@conditions%>') AND 
	i.onhandquantity > '<%=@params["on_hand_quantity"]%>' AND 
	D.variantid not in ('<%=@excluded_skus%>') AND 
	d.esrbrating in ('<%=@esrb_ratings%>')
	<%=@product_limit%>
	<%=@release_date%>
	<%=@online_only_price%>
	<%=@online_only%>
	
ORDER BY newid()

