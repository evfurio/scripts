SET NOCOUNT ON
GO
DECLARE @OrderID INT
SET @OrderID = 2198651
SET NOCOUNT OFF

SELECT SUBSTRING(CONVERT(NVARCHAR(MAX), BodyPlainText), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9%]%', CONVERT(NVARCHAR(MAX), BodyPlainText)), 7) AS OrderID
         ,EmailID, ToEmail, ToName, Subject
FROM Email.dbo.tb_OutgoingEmailQueue
WHERE PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9%]%', CONVERT(NVARCHAR(MAX), BodyPlainText)) > 0
  AND CONVERT(NVARCHAR(MAX), BodyPlainText) LIKE '%[ ][0-9][0-9][0-9][0-9][0-9][0-9][0-9%][ ]%'
  AND SUBSTRING(CONVERT(NVARCHAR(MAX), BodyPlainText), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9%]%', CONVERT(NVARCHAR(MAX), BodyPlainText)), 7) = @OrderID
ORDER BY CreateDate DESC