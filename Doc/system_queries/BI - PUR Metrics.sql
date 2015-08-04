
DECLARE @ProfileID INT
DECLARE @BeginDate0 DATETIME
DECLARE @BeginDate1 DATETIME
DECLARE @EndDate DATETIME

SET @ProfileID = '1253887946'
SET @BeginDate0 = GETDATE() - 365
SET @BeginDate1 = GETDATE() - 7
SET @EndDate = GETDATE()

/*##################################################
  #######Apply & Acquire: Apply: PUR Metrics########
  ##################################################*/

--70699: BI: Apply and Acquire - store number customer accepted/declined/deferred plcc offer
SELECT oe.Source AS Store_Number
FROM profile.dbo.Offer o (NOLOCK)
	JOIN profile.dbo.OfferEvent oe (NOLOCK)
		ON o.OfferID = oe.OfferID
WHERE o.ProfileID = @ProfileID
  AND oe.OfferEventTypeID = 3
  
--70700: BI: Apply and Acquire - account number assigned to customer after accepting plcc offer
/*will depend on new ads tables?*/
  
--70701: BI: Apply and Acquire - card issue date when card is approved and plcc account created  
/*will depend on new ads tables?*/

--70702: BI: Apply and Acquire - approved credit limit for account by ADS
SELECT o.CreditLimit AS Credit_Limit_Amount
FROM profile.dbo.Offer o (NOLOCK)
WHERE o.ProfileID = @ProfileID

--70703: BI: Apply and Acquire - pur member prescreened for plcc offer
SELECT TOP 1 pe.ProfileID as 'Pre-Screen_Profile_ID'
FROM Profile.dbo.ProfileEvent pe (NOLOCK)
WHERE pe.ProfileID = @ProfileID
  AND pe.EventTypeID = 1

--70704: BI: Apply and Acquire - pur member not prescreened for plcc offer
SELECT pe.ProfileID AS 'Profile_ID_Not_Pre-Screened'
FROM Profile.dbo.ProfileEvent pe (NOLOCK)
WHERE pe.ProfileID = @ProfileID
  AND pe.EventTypeID <> 1
  
--70705: BI: Apply and Acquire - customer accepts pre-screen plcc offer - ADS declines
SELECT o.ProfileID AS 'Pre_Screened_ProfileID_Declined_By_ADS'
FROM Profile.dbo.Offer o
	JOIN Profile.dbo.OfferEvent oe
		ON o.OfferID = oe.OfferID
WHERE ProfileID = @ProfileID
  AND oe.OfferEventTypeID = 4

--70706: BI: Apply and Acquire - pur member prescreened for plcc offer declines offer
SELECT o.ProfileID AS 'Pre_Screened_ProfileID_Accepted_By_ADS'
FROM Profile.dbo.Offer o
	JOIN Profile.dbo.OfferEvent oe
		ON o.OfferID = oe.OfferID
WHERE ProfileID = @ProfileID
  AND oe.OfferEventTypeID = 3

--70707: BI: Apply and Acquire - pur member prescreened for plcc offer defers offer
SELECT o.ProfileID AS 'Pre_Screened_ProfileID_Defers_Offer'
FROM Profile.dbo.Offer o
	JOIN Profile.dbo.OfferEvent oe
		ON o.OfferID = oe.OfferID
WHERE ProfileID = @ProfileID
  AND oe.OfferEventTypeID IN (2, 10)

--70710: BI: Apply and Acquire - plcc offer days customer had left to accept offer
SELECT DATEDIFF(DAY, GETDATE(), o.ExpirationDate) AS ProfileID_Daye_Left_To_Accept_Offer
FROM profile.dbo.Offer o (NOLOCK)
WHERE o.ProfileID = @ProfileID

--71150: BI: Apply and Acquire - pur member first PLCC trx amount
/*see GSEDW.sales.TransSummary*/

--71152: BI: Apply and Acquire - pur member plcc available credit
--need ADS file