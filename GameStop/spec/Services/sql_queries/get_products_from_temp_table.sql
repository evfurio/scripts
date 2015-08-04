-- Compbines 3 separate query results in separate columns
SELECT top 1 availableproduct1, availableproduct2, hopsproduct
FROM
(
select top 10 DisplayName AS availableproduct1
from ##VariantsToTest
where producttype = 'Games' -- Games
) As SKU1,
(select top 10 DisplayName AS availableproduct2
from ##VariantsToTest
where producttype = 'Games' Or producttype = 'Toys'

) AS SKU2,
(select top 10 DisplayName AS hopsproduct
from ##VariantsToTest
where AllowInStorePickup = 1 -- HOPS Enabled
) AS SKU3
ORDER BY newid()

DROP Table ##VariantsToTest
