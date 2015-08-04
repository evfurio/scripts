DECLARE @CustomerID INT = 1254157578
  -- ONLY THING YOU CHANGE
DECLARE @CampaignID INT = 789         -- Campaign Name: CP Test A-2
DECLARE @CouponCode INT = 0           -- Used to build unique coupon code
DECLARE @OfferID    VARCHAR(8) = ''   -- Unique OfferID that will be appended to CouponCode

--
--  Display CouponCodeCampaign and all coupon's for Customer / Campaign before new coupon has been added
--
SELECT *
  FROM GenesisCorp.dbo.CouponCodeCampaign CCC (NOLOCK)
WHERE CCC.CampaignID = @CampaignID

SELECT *
  FROM GenesisCorp.dbo.CouponCode CC (NOLOCK)
WHERE CC.CustomerID = @CustomerID
   AND CC.CampaignID = @CampaignID
ORDER BY CC.CouponID
--
--  Get the CouponCode
--
SET @CouponCode = (SELECT CCC.CouponCode
                     FROM GenesisCorp.dbo.CouponCodeCampaign CCC (NOLOCK)
                            WHERE CCC.CampaignID = @CampaignID
                  )
--
--  Get the Unique OfferID used to build completed OfferID
--
SET @OfferID = (SELECT TOP 1 OfferID
                     FROM GenesisCorp.dbo.OfferCodes
                    WHERE UsageCount = 0
                  )
--
--  Insert new CouponCode for CustomerID / Campaign
--
INSERT INTO GenesisCorp.dbo.CouponCode
              ( CampaignID
                     ,OfferID
                     ,CustomerID
                     ,UsageCount
                     ,LastUsageDate
                     ,POSPrintDate
                     ,PrintCount
                    )
            VALUES
                    ( @CampaignID
                     ,'EBC' + CAST( @CouponCode AS CHAR(7)) + '-' + @OfferID
                     ,@CustomerID
                     ,0
                     ,NULL
                     ,NULL
                     ,0
              )
--
--  Mark the OfferID as used
--  
UPDATE OC
   SET OC.UsageCount = OC.UsageCount + 1
  FROM GenesisCorp.dbo.OfferCodes OC
WHERE OC.OfferID = @OfferID
--
--  Display all coupon for Customer / Campaign after new coupon has been added
--
SELECT *
  FROM GenesisCorp.dbo.CouponCode CC (NOLOCK)
WHERE CC.CustomerID = @CustomerID
   AND CC.CampaignID = @CampaignID
ORDER BY CC.CouponID

