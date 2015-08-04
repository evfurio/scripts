
DECLARE @ManufacturerName NVARCHAR(55)
DECLARE @FamilyName NVARCHAR(55)
DECLARE @ProductCondition TINYINT
DECLARE @ProductName NVARCHAR(55)
DECLARE @ProductModel NVARCHAR(55)
DECLARE @ProductOptionValue NVARCHAR(55)

SET @ManufacturerName = 'Samsung'
SET @FamilyName = 'Samsung Phone'
SET @ProductCondition = 1 /*1	A - Like New, 2	B - Good, 3	C - Poor, 4	D - Broken*/
SET @ProductName = 'Galaxy S 3'
SET @ProductModel = 'SGH-i747'
SET @ProductOptionValue = 'AT&T'

SELECT TOP 1000 rmf.ManufacturerName
			  , rpf.FamilyName
			  , rpd.ProductID, rpd.ProductName  
			  , rpg.GroupDescription, rpg.ProductGroupID
			  , rmd.ModelID, rmd.ModelName
			  , rprf.ProductFeatureID
			  , rpo.OptionName
			  , rpov.ProductOptionValue
			  , rpgc.*
			  , tpi.*
FROM Gismo.dbo.RecomManufacturer rmf WITH(NOLOCK)
	JOIN Gismo.dbo.RecomProductFamily rpf WITH(NOLOCK)
		ON rmf.ManufacturerID = rpf.ManufacturerID
	JOIN Gismo.dbo.RecomProduct rpd WITH(NOLOCK)
		ON rpf.FamilyID = rpd.FamilyID
	JOIN Gismo.dbo.RecomProductGroup rpg WITH(NOLOCK)
		ON rpd.ProductID = rpg.ProductID
	JOIN Gismo.dbo.RecomModel rmd WITH(NOLOCK)
		ON rpg.ModelID = rmd.ModelID
	JOIN Gismo.dbo.RecomProductFeature rprf WITH(NOLOCK)
		ON rpg.ProductID = rprf.ProductID AND rpd.ProductID = rprf.ProductID
	JOIN Gismo.dbo.RecomProductOption rpo WITH(NOLOCK)
		ON rprf.ProductOptionID = rpo.ProductOptionID
	JOIN Gismo.dbo.RecomProductOptionValue rpov WITH(NOLOCK)
		ON rprf.ProductOptionValueID = rpov.ProductOptionValueID
	JOIN Gismo.dbo.RecomProductGroupCondition rpgc WITH(NOLOCK)
		ON rpg.ProductGroupID = rpgc.ProductGroupID
	JOIN Gismo.dbo.TIPProductInformation tpi WITH(NOLOCK)
		ON rpgc.SKU = tpi.SKU
WHERE rmf.ManufacturerName = @ManufacturerName
  AND rpf.FamilyName = @FamilyName
  AND rpgc.ConditionID = @ProductCondition
  AND rpd.ProductName = @ProductName
  AND rmd.ModelName = @ProductModel
  AND rpov.ProductOptionValue = @ProductOptionValue
ORDER BY rmf.ManufacturerName, rpd.ProductName, rmd.ModelID, rpo.OptionName, rpov.ProductOptionValue

--SELECT top 1000 *
--FROM Gismo.dbo.TIPTradeInPricingResult tpr
--	JOIN Gismo.dbo.TIPPricingModelOutput pmo 
--		ON pmo.FileID = tpr.FileID
--	JOIN Gismo.dbo.TIPProductInformation tpi
--		ON tpr.ProdID = tpi.ProdID
--WHERE pmo.PricingModelOutputStatusID = 2 
--  AND tpr.TradeInPriceStatusID = 1
--  AND tpi.IsDeleted = 0
  
WITH LatestPrice(Price, DateSubmitted, StoreGroupID, ProdID, RowNumber) AS 
(
	SELECT	tpr.SuggestedTradeInPrice, 
			pmo.DateSubmitted, 
			tpr.StoreGroupID, 
			tpr.ProdID,
			ROW_NUMBER() OVER (PARTITION BY StoreGroupID, tpr.ProdID ORDER BY DateSubmitted DESC) AS RowNumber
	FROM Gismo.dbo.TIPTradeInPricingResult AS tpr
		JOIN dbo.TIPPricingModelOutput AS pmo 
			ON 	pmo.FileID = tpr.FileID
		JOIN Gismo.dbo.TIPProductInformation tpi
			ON tpr.ProdID = tpi.ProdID
	WHERE pmo.PricingModelOutputStatusID = 2 
	  AND tpr.TradeInPriceStatusID = 1
	  AND tpi.IsDeleted = 0
),
	TopRecords(Price, DateSubmitted, StoreGroupID, ProdID) AS
(
	SELECT  Price,
			DateSubmitted,
			StoreGroupID,
			ProdID
	FROM	LatestPrice
	WHERE	RowNumber = 1
)	

SELECT	pnfo.SKU, 
		CASE pnfo.DefaultOverridden 
			WHEN 0 THEN COALESCE(lp.Price, pnfo.PurchasePrice)
			ELSE pnfo.PurchasePrice 
		END AS Price, 
		StoreGroupID AS GroupID,
		CASE pnfo.DefaultOverridden 
			WHEN 0 THEN COALESCE(lp.DateSubmitted, pnfo.UpdateStamp)
			ELSE pnfo.UpdateStamp 
		END AS ChangeDate, 
		pnfo.DefaultOverridden AS Override
FROM Gismo.dbo.TIPProductInformation pnfo WITH (NOLOCK)
	LEFT JOIN TopRecords lp
		ON	pnfo.ProdID = lp.ProdID
WHERE	IsDeleted = 0

UNION

SELECT DISTINCT 
			SKU, 
			PurchasePrice AS Price, 
			NULL AS GroupID, 
			UpdateStamp AS ChangeDate, 
			DefaultOverridden AS Override
FROM	dbo.TIPProductInformation AS pnfo WITH (NOLOCK)
WHERE	IsDeleted = 0 order by SKU

--975764
