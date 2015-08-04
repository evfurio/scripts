--pur free user
SELECT TOP 100 iu.OpenIDClaimedIdentifier, iu.EmailAddress, ck.MembershipKeyID, mk.MembershipID, m.ExpirationDate, m.MembershipProgramID
FROM Multipass.dbo.IssuedUser iu (NOLOCK)
	JOIN profile.KeyMap.CustomerKey ck (NOLOCK)
		ON iu.OpenIDClaimedIdentifier = ck.OpenIDClaimedIdentifier
	JOIN Membership.dbo.MembershipKey mk (NOLOCK)
		ON ck.MembershipKeyID = mk.MembershipKeyID
	JOIN Membership.dbo.Membership m (NOLOCK)
		ON mk.MembershipID = m.MembershipID
WHERE m.MembershipProgramID = 1
  AND m.MembershipStatusID IN (1,2)
  AND iu.EmailAddress LIKE '%jontest%'

--pur pro user
SELECT TOP 100 iu.OpenIDClaimedIdentifier, iu.EmailAddress, ck.MembershipKeyID, mk.MembershipID, m.ExpirationDate, m.MembershipProgramID
FROM Multipass.dbo.IssuedUser iu (NOLOCK)
	JOIN profile.KeyMap.CustomerKey ck (NOLOCK)
		ON iu.OpenIDClaimedIdentifier = ck.OpenIDClaimedIdentifier
	JOIN Membership.dbo.MembershipKey mk (NOLOCK)
		ON ck.MembershipKeyID = mk.MembershipKeyID
	JOIN Membership.dbo.Membership m (NOLOCK)
		ON mk.MembershipID = m.MembershipID
WHERE m.MembershipProgramID = 2
  AND m.MembershipStatusID IN (1,2)
  AND iu.EmailAddress LIKE '%jontest%'
  
--pur purcc user
SELECT TOP 100 iu.OpenIDClaimedIdentifier, iu.EmailAddress, ck.MembershipKeyID, mk.MembershipID, m.ExpirationDate, m.MembershipProgramID
FROM Multipass.dbo.IssuedUser iu (NOLOCK)
	JOIN profile.KeyMap.CustomerKey ck (NOLOCK)
		ON iu.OpenIDClaimedIdentifier = ck.OpenIDClaimedIdentifier
	JOIN Membership.dbo.MembershipKey mk (NOLOCK)
		ON ck.MembershipKeyID = mk.MembershipKeyID
	JOIN Membership.dbo.Membership m (NOLOCK)
		ON mk.MembershipID = m.MembershipID
WHERE m.MembershipProgramID = 3
  AND m.MembershipStatusID IN (1,2)
  --AND iu.EmailAddress LIKE '%jontest%'  
  
--non pur user
SELECT TOP 100 iu.OpenIDClaimedIdentifier, iu.EmailAddress, ck.MembershipKeyID
FROM Multipass.dbo.IssuedUser iu (NOLOCK)
	JOIN profile.KeyMap.CustomerKey ck (NOLOCK)
		ON iu.OpenIDClaimedIdentifier = ck.OpenIDClaimedIdentifier
WHERE ck.MembershipID IS NULL
  --AND iu.EmailAddress LIKE '%jontest%'  