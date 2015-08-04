;WITH CTE_GameStop
AS
(
SELECT DISTINCT TOP 2000 D.variantid
        , A.DisplayName
        , OnHandQuantity
        , d.condition
        , d.ParentOID
        , A.ProductType
        , d.ProductID
        , d.LastModified
        , d.InStorePickup
        , d.IsAvailable
        , d.IsNew
        , d.OnlineOnly
        , d.PrimaryUPC
        , d.ProductLimit
        , d.Searchable
        , d.UPC
        , d.AllowInstorePickup
        , d.HoldUntilDate
        , d.IsApproved
        , d.IsReadyForProd
        , d.OnlineOnlyPrice
        , d.IsEmbargoed
        , d.IsSearchable
        , d.Availability
        , d.BrianItemNumber
        , d.BrianReferenceSKU
        , d.ESRBRating
        , d.FreeShipping
        , d.ReleaseDate
        , d.TaxabilityCode
        , d.EnableUpsellRecommendations
		,c.cy_list_price as Price
		,A.DisplayName as Title
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D ON A.#Catalog_Lang_Oid = D.oid
INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C ON C.Oid = A.#Catalog_Lang_Oid
INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i ON c.variantid = i.skuvariantid
INNER JOIN (SELECT y.ProductID , count(*) 'VariantCount'

            FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK)
            INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x ON y.variantid = x.skuvariantid

            GROUP BY productid 
            HAVING COUNT(*) = 1
           ) AS Z ON z.ProductID = D.ProductID
WHERE c.isavailable = 1
      AND c.variantid <> '0'
      AND c.variantid <> ''
      AND d.searchable = 1
      and d.ProductLimit is NULL
      AND ((C.Availability = 'A' and i.onhandquantity > '1000') OR (C.Availability = 'PR'))
      AND c.condition != 'Warranty'
      --AND d.condition = 'New'
      --AND c.availability IN ('PR','A')
      --OR d.InStorePickup in (0,1)
      --order by d.InStorePickup desc
)
-- Compbines 3 separate query results in separate columns
-- SKU1 = Available New or Used products, SKU2 = Digital, SKU3 = Pre-Order
--SELECT top 1 New, PreOrder
--FROM
(select Distinct top 1 variantid, esrbrating, condition, Title, Availability, Price, EnableUpsellRecommendations,
ProductID,  taxabilitycode
--from CTE_GameStop where Availability = 'A'and condition = 'Digital')-- New
from CTE_GameStop where variantid = '600142') --Digital
UNION ALL
(select Distinct top 1 variantid, esrbrating, condition, Title, Availability, Price, EnableUpsellRecommendations,
ProductID,  taxabilitycode
from CTE_GameStop where Availability = 'PR'and condition = 'New') --PreOrder

