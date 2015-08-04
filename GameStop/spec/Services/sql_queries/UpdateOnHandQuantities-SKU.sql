SELECT A.DisplayName AS DISPLAY_NAME, D.variantid AS SKU, D.ProductID AS PRODUCTID
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A INNER JOIN
     [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid
WHERE #Catalog_Lang_Oid IN (
SELECT distinct (oid)
  FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] c inner join 
  [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid= i.skuvariantid
  where c.esrbrating = 'E' and c.isavailable = 1 and c.variantid <> '0' and c.variantid <> ''
  AND OnHandQuantity > '10000')
  ORDER BY   D.variantid ASC
