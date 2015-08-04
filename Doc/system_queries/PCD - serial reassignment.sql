--games in the dropdown list available for serial reassignment
SELECT distinct ProductID, Name
FROM Stardock.dbo.tb_Product
WHERE available = 0 
	  AND prodVisible = 0
	  AND ActivationType = 3

--verify at least one registration is on a product 
--this check is made when "preview" is hit on web browser before reassignment
SET NOCOUNT ON
GO
DECLARE @productID INT
SET @ProductID = 3420  --insert individual productID here
SET NOCOUNT OFF
SELECT count(r.RegistrationID) AS Number_Of_Registrations, p.productID, p.Name
FROM Stardock.dbo.tb_Product p
	JOIN Stardock.dbo.tb_Registration r
		ON p.ProductID = r.ProductID
WHERE p.Available = 0 
  AND p.prodVisible = 0
  AND p.ActivationType = 3
  AND p.ProductID = @ProductID
GROUP BY p.ProductID, p.Name

--Find good candidates (Product ID's) for testing :)
SELECT COUNT(r.RegistrationID) AS Active_Reg_Count, p.ProductID, p.Name
FROM Stardock.dbo.tb_Registration r
	JOIN Stardock.dbo.tb_Product p
		ON r.ProductID = p.ProductID
WHERE p.available = 0 
  AND p.prodVisible = 0
  AND p.ActivationType = 3
  AND r.Active = 1
GROUP BY p.ProductID, p.Name
HAVING COUNT(r.RegistrationID) > 1
ORDER BY p.ProductID

--after finding a good candidate, check Commerce tier for seria # info
SELECT COUNT(*)
FROM Commerce.Commerce.dbo.tb_SerialNum_1406  --replace last 4 digit productID as needed
SELECT LastSRID
FROM Commerce.Commerce.dbo.tb_Product
WHERE ProductID = 1406 --replace alst 4 digit productID as needed

--# of Serials available must be > # of Serials already being used by customers for a product
--# of available serials is on Commerce and depends on the LastSRID from Commerce.dbo.tb_Product
SET NOCOUNT ON
GO
DECLARE @productID nvarchar(4)
DECLARE @SQL nvarchar(max)
DECLARE @count INT, @ParmDefinition NVARCHAR(255), @regcount INT
SET @ProductID = '1406'  --insert individual productID here (from tb_Product)
SET @SQL = 'select @CountOUT = (MaxID - LastSRID + 1) from COMMERCE.Commerce.dbo.tb_Product where ProductID=' + @ProductID 
SET @ParmDefinition = N'@countOUT INT OUTPUT';
SET NOCOUNT OFF
EXEC sp_executesql @SQL, @ParmDefinition, @countOUT=@count OUTPUT
PRINT @count
SELECT @regCount = COUNT(*) FROM dbo.tb_Registration tr WHERE productid = CAST(@productID AS INT)
SELECT @regCount - @count AS NumSerialsAvailable

DECLARE @productID int
SET @ProductID = 1406 --insert individual productID here (from tb_Product)
SELECT MaxID AS 'TotalNumSerials', (MaxID - LastSRID) AS 'SerialsAvailable'
FROM Commerce.Commerce.dbo.tb_Product 
WHERE ProductID = @ProductID
SELECT COUNT(*) AS Total_Num_Active_Registrations
FROM Stardock.dbo.tb_Registration
WHERE Active = 1
  AND ProductID = @ProductID