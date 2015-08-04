SELECT DISTINCT TOP 2000 D.variantid, A.DisplayName, OnHandQuantity, d.condition, d.ParentOID, A.ProductType, d.ProductID, d.LastModified, d.InStorePickup, d.IsAvailable, d.IsNew, d.OnlineOnly, d.PrimaryUPC, d.ProductLimit, d.Searchable, d.UPC, d.AllowInstorePickup, d.HoldUntilDate, d.IsApproved, d.IsReadyForProd, d.OnlineOnlyPrice, d.IsEmbargoed, d.IsSearchable, d.Availability, d.BrianItemNumber, d.BrianReferenceSKU, d.ESRBRating, d.FreeShipping, d.ReleaseDate, d.taxabilitycode,d.EnableUpsellRecommendations
      INTO ##VariantsToTest2
      FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK) 
      INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid 
      INNER JOIN [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
      INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid 
      INNER JOIN (
                  SELECT y.ProductID , count(*) 'VariantCount' 
                        FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK) 
                        INNER JOIN [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid = x.skuvariantid 
                  GROUP BY productid HAVING COUNT(*) = 1 
                  ) AS Z ON z.ProductID = D.ProductID 
WHERE c.isavailable = 1 
      AND c.variantid <> '0' 
      AND c.variantid <> '' 
      AND d.searchable = 1 
      AND i.onhandquantity > '1000' 
      AND d.condition != 'download'
      OR d.InStorePickup in (0,1)
      AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations is NULL)
      order by d.InStorePickup desc
      
      
 -- Compbines 3 separate query results in separate columns
-- SKU1 = Available New or Used products, SKU2 = Digital, SKU3 = Pre-Order
SELECT top 10 New, Used, Digital, PreOrder,instorepickup
FROM
(
select Distinct top 10 VariantId AS New
from ##VariantsToTest2
where condition = 'New'
) As New,
(select  top 10 VariantId AS Used
from ##VariantsToTest2
where condition = 'Used'
) AS Used,
(select  top 10 VariantId AS Digital
from ##VariantsToTest2
where condition = 'Digital'
) AS Digital,
(select  top 10 VariantId AS PreOrder
from ##VariantsToTest2
where availability = 'PR'
and InStorePickup = 0 -- InStorePickup is disabled
) AS PreOrder,
(Select top 10
CASE --WHEN InStorePickup is enabled
          WHEN InStorePickup = 1 then VariantID
END AS [InStorePickup]
From ##VariantsToTest2
GROUP BY InStorePickup,variantId
) AS InStorePickup
Order by newid()

drop table ##VariantsToTest2
