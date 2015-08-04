SELECT TOP <%=return_product_num%> C.Availability, C.ProductID, D.variantid, D.taxabilitycode, d.esrbrating, i.onhandquantity, A.DisplayName as Title, C.condition, d.cy_list_price, d.[ProductKeywords], d.[TargetingKeywords]
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid
INNER JOIN [Gamestop_Catalog_GSProcesses].[dbo].[vw_EndecaCatalog_US_GameStopBase] m on c.variantid = m.[variant.SKU]
INNER JOIN (SELECT y.ProductID , count(*) 'Variant Count' FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK)
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid
GROUP BY productid HAVING COUNT(*) = 1 )  as Z ON z.ProductID = D.ProductID
WHERE c.availability in ('<%=availability%>') and c.isavailable = 1 and d.searchable =1  AND c.condition = ('<%=condition%>') and c.condition != 'Digital' and c.condition != 'Download' AND
D.ProductLimit is NULL AND i.onhandquantity > '<%=on_hand_quantity%>' and D.variantid not in ('859996','859998', '859997') and d.esrbrating in ('<%=esrb_rating%>')
ORDER BY newid()