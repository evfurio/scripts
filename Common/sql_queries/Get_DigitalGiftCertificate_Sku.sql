Select A.[variant.BaseCatalogSKU] As sku, A.[variant.ProductClassification] as ProdType
From Gamestop_Catalog_GSProcesses.dbo.vw_EndecaCatalog_US_GameStopBase A With(NoLock)
Where
A.[variant.ProductClassification] = 'GiftCertificate'
Order By NEWID()