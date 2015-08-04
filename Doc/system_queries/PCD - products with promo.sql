use store
select prodID, prodName, ProductTypes, prodPrice
from Store.dbo.sfProducts
where producttypes = 9