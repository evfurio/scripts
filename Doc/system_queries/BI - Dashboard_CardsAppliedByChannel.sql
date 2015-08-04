/*##################################################
  ######BI Dashboard - Cards Applied by Channel#####
  ##################################################*/
  
--71027: BI reporting: in-store last fiscal week
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20140525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID = 3



--71028: BI reporting: in-store last 12 months
DECLARE @StartDate INT
DECLARE @EndDate INT

SET @StartDate = '20130525'
SET @EndDate = '20140531'

SELECT COUNT(DISTINCT oe.OfferID) --there are dup offerid/offereventtypes in table in QA
FROM Profile.dbo.OfferEvent oe
WHERE oe.OfferEventTypeID = 3

--71029: BI reporting: email last fiscal week
--omniture dependent

--71030: BI reporting: email last 12 months
--omniture dependent

--71031: BI reporting: gs.com last fiscal week
--omniture dependent

--71032: BI reporting: gs.com last 12 months
--omniture dependent

--71033: BI reporting: direct url entry last fiscal week
--omniture dependent

--71034: BI reporting: direct url entry last 12 months
--omniture dependent

--71035: BI reporting: search engine/others last fiscal week
--omniture dependent

--71036: BI reporting: search engine/others last 12 months
--omniture dependent