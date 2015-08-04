--enrolled prior ssis, activate post ssis
SELECT TOP 1000 *
FROM profile.dbo.Profile p
	JOIN profile.KeyMap.CustomerKey ck
		ON p.ProfileID = ck.ProfileID
	JOIN Membership.dbo.Membership m
		ON ck.MembershipID = m.MembershipID
	JOIN Membership.dbo.MembershipCard mc
		ON m.MembershipID = mc.MembershipID
WHERE m.MembershipStatusID = '2'
  AND mc.CancellationDate IS NULL
  AND m.EndDate IS NULL
  --AND p.ProfileID = 1238150808
ORDER BY p.ProfileID DESC

