
USE MULTIPASS

DECLARE @Name Varchar(MAX)

DECLARE OpenID_Cursor CURSOR FOR
	SELECT OpenIDClaimedIdentifier 
	FROM Multipass.dbo.IssuedUser 
	WHERE EmailAddress like 'snguitest%' and OpenIDClaimedIdentifier like '%Q'
	
OPEN OpenID_Cursor

FETCH NEXT FROM OpenID_Cursor INTO @Name

WHILE @@FETCH_STATUS = 0
   BEGIN
	--SELECT CAST(N'' AS XML).value('xs:base64Binary(xs:hexBinary(sql:column("bin")))', 'VARCHAR(MAX)')
	--FROM (SELECT CAST('https://loginqa.testecom.pvt/ID/9DLvzx_YekGyWWjH7SEhVQ' AS VARBINARY(MAX)))
	SELECT CAST('https://loginqa.testecom.pvt/ID/9DLvzx_YekGyWWjH7SEhVQ' AS VARBINARY(MAX))
	FETCH NEXT FROM OpenID_Cursor INTO @Name
   END
   
CLOSE OpenID_Cursor
DEALLOCATE OpenID_Cursor

--https://loginqa.testecom.pvt/ID/9DLvzx_YekGyWWjH7SEhVQ