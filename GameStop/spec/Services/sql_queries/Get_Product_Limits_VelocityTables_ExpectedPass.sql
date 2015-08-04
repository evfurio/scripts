--SQL_SHTEMP_GetProducts
IF OBJECT_ID('tempdb..#SHTEMP') IS NOT NULL
DROP TABLE #SHTEMP
SELECT Y.ProductLimit, Y.ProductID  INTO #SHTEMP
      FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] Y WITH (NOLOCK)
      INNER JOIN [GameStop_productcatalog].[dbo].[Default_InventorySkus] X ON Y.VariantID = X.SkuVariantId
   WHERE Y.ProductLimit > 0

--SQL_TTPVBA_JoinQtyToVelocity
IF OBJECT_ID('tempdb..#TTPVBA') IS NOT NULL
DROP TABLE #TTPVBA 
SELECT top 10 
      D.variantid AS SKU, D.ProductLimit,
      PVBA.StreetLine1 as BillLine1, PVBA.StreetLine2 as BillLine2,
      PVBA.City as BillCity, PVBA.State as BillState,
      PVBA.Country as BillCountry, PVBA.Postal as BillPostalCode, PVBA.Qty as Qty,
      PVSA.StreetLine1 as ShipLine1, PVSA.StreetLine2 as ShipLine2,
      PVSA.City as ShipCity, PVSA.State as ShipState,
      PVSA.Country as ShipCountry, PVSA.Postal as ShipPostalCode,
      PVEA.Email as Email,
      PVUP.ProfileGuid as ProfileId,
      PVBA.reference_order_number AS PVBA_order, PVSA.reference_order_number AS PVSA_order, 
	  PVEA.reference_order_number AS PVEA_order, PVUP.reference_order_number AS PVUP_order
      INTO #TTPVBA      
      
FROM [DL1GSQDB10SQL1\INST1].[Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
INNER JOIN [DL1GSQDB10SQL1\INST1].[Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] AS D ON A.#Catalog_Lang_Oid = D.oid
INNER JOIN [DL1GSQDB10SQL3\INST3].[GameStopOrderStore].[dbo].[ProductVelocityByBillingAddress] AS PVBA on D.VariantID = PVBA.VariantID AND D.ProductLimit > PVBA.Qty
INNER JOIN [DL1GSQDB10SQL3\INST3].[GameStopOrderStore].[dbo].[ProductVelocityByShippingAddress] AS PVSA on D.VariantID = PVSA.VariantID AND D.ProductLimit > PVSA.Qty 
	AND PVBA.reference_order_number = PVSA.reference_order_number
INNER JOIN [DL1GSQDB10SQL3\INST3].[GameStopOrderStore].[dbo].[ProductVelocityByEmailAddress] AS PVEA on D.VariantID = PVEA.VariantID AND D.ProductLimit > PVEA.Qty
	AND PVSA.reference_order_number = PVEA.reference_order_number
INNER JOIN [DL1GSQDB10SQL3\INST3].[GameStopOrderStore].[dbo].[ProductVelocityByUserProfile] AS PVUP on D.VariantID = PVUP.VariantID AND D.ProductLimit > PVUP.Qty
	AND PVEA.reference_order_number = PVUP.reference_order_number
INNER JOIN #SHTEMP AS Z ON Z.ProductID = D.ProductID
WHERE D.Availability = 'A' and D.isavailable = 1 and D.variantid <> '0' and D.variantid <> '' 
AND D.searchable=1 and D.productlimit > 0 and PVBA.InsertDateTime >= dateadd(day,-300,getdate())
ORDER BY NEWID()


SELECT * FROM #TTPVBA