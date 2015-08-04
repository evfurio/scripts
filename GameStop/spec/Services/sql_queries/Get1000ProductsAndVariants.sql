SELECT Top 1000 
ProductId, SkuVariantId, Status, OnHandQuantity, Availability, ESRBRating, Condition
  FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] c inner join 
  [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on variantid= i.skuvariantid
  where condition != 'Digital' and 
		condition != 'Download' and 
		esrbrating != 'M' and 
		esrbrating != 'None' and
		esrbrating != 'RP' and
		isavailable = 1 and 
		availability = 'A' and 
		variantid <> '0' and 
		variantid <> ''
ORDER BY variantid ASC


