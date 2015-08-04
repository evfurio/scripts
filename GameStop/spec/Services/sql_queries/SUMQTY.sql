IF OBJECT_ID('tempdb..#tblSUM') IS NOT NULL
      DROP TABLE #tblSUM
Declare 
      @VariantID nvarchar(256),
      @Email nvarchar(64),
      @ProfileGuid uniqueidentifier ,
      @HashedCC nvarchar(45),
      @Billing_StreetLine1 nvarchar(80),
      @Billing_StreetLine2 nvarchar(80),
      @Billing_City nvarchar(64),
      @Billing_State nvarchar(2), 
      @Billing_Country nvarchar(3),
      @Billing_Postal nvarchar(20),
      @ShipTo_StreetLine1 nvarchar(80),
      @ShipTo_StreetLine2 nvarchar(80),
      @ShipTo_City nvarchar(64),
      @ShipTo_State nvarchar(2),
      @ShipTo_Country nvarchar(3),
      @ShipTo_Postal nvarchar(20),
      @ProductVelocityDays int

CREATE TABLE #tblSUM (AllSum INT)

      INSERT INTO #tblSUM
            SELECT SUM(QTY)
            FROM [GameStopOrderStore_oms].[dbo].[ProductVelocityByEmailAddress] EmailAddress
            WHERE
                 EmailAddress.VariantID = @VariantID AND
                 EmailAddress.Email = @Email AND
                   DATEADD([day], @ProductVelocityDays, InsertDateTime) > getdate()
        UNION ALL
            SELECT SUM(QTY)
            FROM [GameStopOrderStore_oms].[dbo].[ProductVelocityByUserProfile] UserProfile
            WHERE
                UserProfile.VariantID = @VariantID AND
                UserProfile.ProfileGuid = @ProfileGuid AND
                  DATEADD([day], @ProductVelocityDays, InsertDateTime) > getdate()
        UNION ALL
            SELECT SUM(QTY)
            FROM [GameStopOrderStore_oms].[dbo].[ProductVelocityByCreditCard] CreditCard
            WHERE
                 CreditCard.VariantID = @VariantID AND
                 CreditCard.HashedCC = @HashedCC AND
                  DATEADD([day], @ProductVelocityDays, InsertDateTime) > getdate()
        UNION ALL
            SELECT SUM(QTY)
            FROM [GameStopOrderStore_oms].[dbo].[ProductVelocityByBillingAddress] BillingAddress
            WHERE
				BillingAddress.VariantID = @VariantID AND
				BillingAddress.StreetLine1 = @Billing_StreetLine1 AND
				BillingAddress.StreetLine2 = @Billing_StreetLine2 AND
				BillingAddress.City = @Billing_City AND
				BillingAddress.State = @Billing_State AND
				BillingAddress.Country = @Billing_Country AND
				BillingAddress.Postal = @Billing_Postal AND
                DATEADD([day], @ProductVelocityDays, InsertDateTime) > getdate()
SELECT MAX(AllSum) as 'SUM' FROM #tblSUM 
Drop table #tblSUM
