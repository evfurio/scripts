SELECT TOP 3
                  D.variantid,
                  d.esrbrating,
                  C.condition,
                  A.DisplayName   AS Title,
                  C.Availability,
                  c.cy_list_price AS Price,
                  d.EnableUpsellRecommendations,
                  C.ProductID,
                  D.taxabilitycode
                FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH ( NOLOCK )
                  INNER JOIN
                  [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D ON A.#Catalog_Lang_Oid = D.oid
                  INNER JOIN
                  [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C ON C.Oid = A.#Catalog_Lang_Oid
                  INNER JOIN
                  [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i ON c.variantid = i.skuvariantid
--INNER JOIN
  --[Gamestop_Catalog_GSProcesses].[dbo].[vw_EndecaPlatforms_US_GameStopBase] m on c.variantid = m.variant.BaseCatalogSKU
                  INNER JOIN
                  (SELECT
                     y.ProductID,
                     count(*) 'Variant Count'
                   FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH ( NOLOCK )
                     INNER JOIN
                     [Gamestop_productcatalog].[dbo].[Default_InventorySkus] x ON y.variantid = x.skuvariantid
                   GROUP BY productid
                   HAVING COUNT(*) = 1
                  ) AS Z
                    ON z.ProductID = D.ProductID
                WHERE c.availability = 'PR' AND c.variantid <> '0' AND c.variantid <> '' AND c.variantid <> '' AND
                      c.variantid NOT LIKE '%[a-zA-Z]%'
                      AND d.searchable = 1 AND D.ESRBRating = 'M' AND d.instorepickup = 1
                      AND (d.EnableUpsellRecommendations = '0' OR d.EnableUpsellRecommendations IS NULL)
                      AND c.condition != 'Warranty'
                ORDER BY NEWID()