SELECT TOP 10 p.ProfileID, p.EmailAddress
			, ck.MembershipID, ck.OpenIDClaimedIdentifier
			, m.CreatedDate
			, mc.CardNumber
FROM profile.dbo.Profile p WITH(NOLOCK)
	JOIN Profile.KeyMap.CustomerKey ck WITH(NOLOCK)
		ON p.ProfileID = ck.ProfileID
	JOIN Membership.dbo.Membership m
		ON ck.MembershipID = m.MembershipID
	JOIN Membership.dbo.MembershipCard mc
		ON m.MembershipID = mc.MembershipID
	JOIN Multipass.dbo.IssuedUser iu
		ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
WHERE p.EmailAddress LIKE 'email%'
  AND p.EmailAddress NOT LIKE '%@test.com'
  AND ck.MutliPassAccountCreated = 1
ORDER BY p.ProfileID DESC
