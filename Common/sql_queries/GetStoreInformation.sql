SELECT TOP 1000 PostalCode as zipcode, Latitude as Lat, Longitude, storenumber as StoreNum, address1 as addr1, City as city, State as state
  FROM [StoreInformation].[dbo].[Store] (NOLOCK)
  ORDER BY NEWID()