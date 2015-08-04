SELECT TOP 1 a.[StoreID] as storeid, a.[QtyOnHand] as onhand, d.[ProductID] as productid, d.[Sku] as sku FROM [StoreInformation].[dbo].[StoreInventory] a with (NOLOCK) INNER JOIN [StoreInformation].[dbo].[Product] d on a.ProductID = d.ProductID WHERE d.Sku = '970385' and QtyOnHand > 0 ORDER BY NEWID()


