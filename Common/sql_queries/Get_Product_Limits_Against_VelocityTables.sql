--SQL_SHTEMP_GetProducts
IF OBJECT_ID('tempdb..#SHTEMP') IS NOT NULL
DROP TABLE #SHTEMP
SELECT Y.ProductLimit, Y.ProductID,y.EnableUpsellRecommendations  INTO #SHTEMP
      FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] Y WITH (NOLOCK)
      INNER JOIN [GameStop_productcatalog].[dbo].[Default_InventorySkus] X ON Y.VariantID = X.SkuVariantId
   WHERE Y.ProductLimit > 0
   AND (y.EnableUpsellRecommendations = '0' OR y.EnableUpsellRecommendations is NULL)

--SQL_TTPVBA_JoinQtyToVelocity
IF OBJECT_ID('tempdb..#TTPVBA') IS NOT NULL
DROP TABLE #TTPVBA 
SELECT top 10 D.variantid AS SKU, D.ProductLimit,
      PVBA.StreetLine1 as Line1, PVBA.StreetLine2 as Line2,
      PVBA.City as City, PVBA.State as State,
      PVBA.Country as Country, PVBA.Postal as PostalCode, PVBA.Qty as Qty
      INTO #TTPVBA
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] AS D ON A.#Catalog_Lang_Oid = D.oid
INNER JOIN [GameStopOrderStore].[dbo].[ProductVelocityByBillingAddress] AS PVBA on D.VariantID = PVBA.VariantID AND D.ProductLimit < PVBA.Qty
--INNER JOIN [GameStopOrderStore].[dbo].[ProductVelocityByShippingAddress] AS PVSA on D.VariantID = PVSA.VariantID AND D.ProductLimit < PVSA.Qty
--INNER JOIN [GameStopOrderStore].[dbo].[ProductVelocityByEmailAddress] AS PVEA on D.VariantID = PVEA.VariantID AND D.ProductLimit < PVEA.Qty
--INNER JOIN [GameStopOrderStore].[dbo].[ProductVelocityByUserProfile] AS PVUP on D.VariantID = PVUP.VariantID AND D.ProductLimit < PVUP.Qty
INNER JOIN #SHTEMP AS Z ON Z.ProductID = D.ProductID
WHERE D.Availability = 'A' and D.isavailable = 1 and D.variantid <> '0' and D.variantid <> '' AND D.searchable=1 and D.productlimit > 0 and PVBA.InsertDateTime >= dateadd(day,-300,getdate())
--ORDER BY NEWID()

SELECT * FROM #TTPVBA WHERE ProductLimit > 0

Declare @D1 datetime
Set @D1 = dateadd(day,-30,getdate())
Select * From ProductVelocityByShippingAddress Where InsertDateTime <= @D1

Select * From [GameStopOrderStore].[dbo].[ProductVelocityByEmailAddress]