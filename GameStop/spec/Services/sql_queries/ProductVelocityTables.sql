SELECT [Email],[VariantID],[Qty]
  FROM [GameStopOrderStore].[dbo].[ProductVelocityByEmailAddress] (NOLOCK)
  --Where VariantID = ''

SELECT StreetLine1, StreetLine2, City, State, Country, Postal, VariantID, Qty
  FROM dbo.ProductVelocityByBillingAddress

SELECT HashedCC, VariantID, Qty
  FROM dbo.ProductVelocityByCreditCard
  
SELECT StreetLine1, StreetLine2, City, State, Country, Postal, VariantID, Qty
  FROM dbo.ProductVelocityByShippingAddress
  
SELECT ProfileGuid, VariantID, Qty
  FROM dbo.ProductVelocityByUserProfile