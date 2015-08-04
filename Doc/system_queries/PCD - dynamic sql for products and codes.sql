DECLARE @SQL NVARCHAR(MAX)
--DECLARE @RetailSNTable NVARCHAR(MAX)

--SET @RetailSNTable = 'SELECT RetailSNTable FROM Stardock.dbo.tb_product WHERE ProductID = 3500'

SELECT @SQL = N'SELECT TOP 1000 * 
				FROM Stardock.dbo.tb_Product p 
					JOIN Stardock.dbo.' + '@RetailSNTable r' +  
						'ON p.
				WHERE ProductID = 3500'	

EXEC sp_executesql @SQL, N'@RetailSNTable NVARCHAR(MAX)', '@RetailSNTable'

DECLARE @SQLQuery AS NVARCHAR(MAX)
DECLARE @ParamDef AS NVARCHAR(MAX)
DECLARE @ProductID AS INT
DECLARE @RetailSNTable AS NVARCHAR(MAX)

SET @ProductID = 3500
SET @SQLQuery = N'SELECT @RetailSNTableOUT = RetailSNTable FROM Stardock.dbo.tb_Product WHERE ProductID = @ProductID'
SET @ParamDef = N'@ProductID INT, @RetailSNTableOUT NVARCHAR(MAX) OUTPUT'

EXECUTE sp_executesql @SQLQuery, @ParamDef, @ProductID, @RetailSNTableOUT = @RetailSNTable OUTPUT
SELECT @RetailSNTable

DECLARE @ProductName NVARCHAR(MAX)
DECLARE @AccountEmail NVARCHAR(MAX)

SET @ProductName = '%18%'
SET @AccountEmail = 'jonathanlafortune@gamestop.com'

SELECT TOP 1000 r.RegistrationID, r.SerialNum, r.StartDate
			  , a.AccountEmail, p.Name
FROM Stardock.dbo.tb_Registration r
	JOIN Stardock.dbo.tb_Accounts a
		ON r.CustomerID = a.CustomerID
	JOIN stardock.dbo.tb_Product p
		ON r.ProductID = p.ProductID
WHERE a.AccountEmail = @AccountEmail
  AND p.Name LIKE @ProductName
  AND 
   (
      p.RetailSNTable = 'tb_SerialNum_GalCiv2Ultimate'
   OR p.RetailSNTable = 'tb_SerialNum_SinsActivation'
   OR p.RetailSNTable = 'tb_SerialNum_SinsTrinityBox'
   OR p.RetailSNTable = 'tb_SerialNum_ElementalDigital'
   OR p.RetailSNTable = 'tb_SerialNum_Demigod'
   OR p.RetailSNTable = 'tb_SerialNum_PM2K8'
   )