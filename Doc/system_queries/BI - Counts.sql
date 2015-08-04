-- base queries
SELECT TOP 50000 p.ProfileID, p.FirstName, p.LastName, p.EmailAddress
			   , pe.EventDate
			   , et.EventTypeDescription
			   , eg.EventTypeGroupDescription
			   , ct.ChannelTypeDescription
FROM Profile.dbo.Profile p (NOLOCK)
	JOIN profile.dbo.ProfileEvent pe (NOLOCK)
		ON p.ProfileID = pe.ProfileID
	JOIN Profile.dbo.EventType et (NOLOCK)
		ON pe.EventTypeID = et.EventTypeID
	JOIN Profile.dbo.EventTypeGroup eg (NOLOCK)
		ON et.EventTypeGroupID = eg.EventTypeGroupID
	JOIN profile.dbo.ChannelType ct (NOLOCK)
		ON pe.ChannelTypeID = ct.ChannelTypeID
--WHERE et.EventTypeDescription = 'Prescreen Candidate'

WITH PUR_cte AS (
SELECT m.MembershipID
	FROM Membership.dbo.Membership m (NOLOCK)
		JOIN Membership.dbo.MembershipCard mc (NOLOCK)
			ON m.MembershipID = mc.MembershipID
WHERE m.MembershipStatusID = 1
  AND mc.CardStatusID = 1
)
SELECT TOP 1000 ck.ProfileID, ck.MembershipID
			  , o.OfferID
			  , oet.OfferEventTypeDescription
FROM Profile.KeyMap.CustomerKey ck (NOLOCK)
	JOIN PUR_cte cte
		ON cte.MembershipID = ck.MembershipID
	JOIN Profile.dbo.Offer o (NOLOCK)
		ON ck.ProfileID = o.ProfileID
	JOIN profile.dbo.OfferEvent oe
		ON o.OfferID = oe.OfferID
	JOIN profile.dbo.OfferEventType oet
		ON oe.OfferEventTypeID = oet.OfferEventTypeID
ORDER BY ck.ProfileID DESC

SELECT TOP 100 *
FROM Profile.KeyMap.CustomerKey ck (NOLOCK)
	JOIN Multipass.dbo.IssuedUser iu (NOLOCK)
		ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
	JOIN Membership.dbo.Membership m (NOLOCK)
		ON ck.MembershipID = m.MembershipID
	JOIN Membership.dbo.MembershipCard mc (NOLOCK)
		ON m.MembershipID = mc.MembershipID
WHERE m.MembershipStatusID = 1
  AND mc.CardStatusID = 1
  AND ck.MutliPassAccountCreated = 1
ORDER BY ck.ProfileID DESC

SELECT TOP 2000 *
FROM Profile.dbo.Offer o (NOLOCK)
	JOIN profile.dbo.OfferEvent oe (NOLOCK)
		ON o.OfferID = oe.OfferID
	JOIN profile.dbo.OfferEventType oet (NOLOCK)
		ON oe.OfferEventTypeID = oet.OfferEventTypeID
	JOIN profile.KeyMap.CustomerKey ck
		ON o.ProfileID = ck.ProfileID
WHERE ck.MembershipID IS NOT NULL
  AND ck.MembershipID <> ''
ORDER BY o.OfferID

--total PUR members (active and non-active)
SELECT COUNT(MembershipID)
FROM Membership.dbo.Membership m (NOLOCK)

--total active PUR members
/*where active = activated membership/activated card*/
SELECT COUNT(m.MembershipID)
	FROM Membership.dbo.Membership m(NOLOCK)
		JOIN Membership.dbo.MembershipCard mc (NOLOCK)
			ON m.MembershipID = mc.MembershipID
WHERE m.MembershipStatusID = 1
  AND mc.CardStatusID = 1
  
--total PUR pro members
SELECT COUNT(MembershipID)
FROM Membership.dbo.Membership m(NOLOCK)
WHERE m.MembershipProgramID = 2

--total PUR free members
SELECT COUNT(MembershipID)
FROM Membership.dbo.Membership m(NOLOCK)
WHERE m.MembershipProgramID = 1



