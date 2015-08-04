
--all profile tables overview for an email address
DECLARE @EmailAddr NVARCHAR(100)
SET @EmailAddr = '%purge%'

SELECT TOP 10 *
FROM profile.dbo.Profile p WITH(NOLOCK)
	JOIN profile.dbo.Address a WITH(NOLOCK)
		ON p.ProfileID = a.ProfileID
	JOIN profile.dbo.Phone ph WITH(NOLOCK)
		ON p.ProfileID = ph.ProfileID
	JOIN profile.dbo.Gender g WITH(NOLOCK)
		ON p.GenderID = g.GenderID
	JOIN profile.dbo.AddressType at WITH(NOLOCK)
		ON a.AddressTypeID = at.AddressTypeID
	JOIN profile.dbo.PreferredStore ps WITH(NOLOCK)
		ON p.ProfileID = ps.ProfileID
WHERE p.EmailAddress LIKE @EmailAddr

--profile to keymap, openID		
SELECT TOP 100 *
FROM profile.dbo.Profile p WITH(NOLOCK)
	JOIN profile.KeyMap.CustomerKey ck WITH(NOLOCK)
		ON p.ProfileID = ck.ProfileID
WHERE ck.OpenIDClaimedIdentifier IS NOT NULL

--security questions from gencorp
SELECT TOP 1000 r.ResouceText, pa.AnswerText, c.CustomerID, c.EmailAddress
FROM GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
	JOIN GenesisCorp.dbo.refResource r WITH(NOLOCK)
		ON pq.ResourceID = r.ResourceID
	JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
		ON pq.PreferenceQuestionID = pa.PreferenceQuestionID
	JOIN GenesisCorp.dbo.Customer c WITH(NOLOCK)
		ON pa.CustomerID = c.CustomerID
WHERE pq.QuestionTypeID = 1
  AND c.CustomerID = 1238551526
ORDER BY c.CustomerID DESC


--pur card on gencorp
DECLARE @CardNum NVARCHAR(50)
SET @CardNum = '3875001000647'
SELECT TOP 10 m.MembershipID, m.OpenIDClaimedIdentifier, m.CreatedDate, mc.CardNumber
			, CASE mc.CardStatusID
				WHEN 0 THEN 'Unknown'
				WHEN 1 THEN 'Active'
				WHEN 2 THEN 'Inactive'
				WHEN 3 THEN 'Terminated'
				WHEN 4 THEN 'Deactivated'
				WHEN 5 THEN 'Cancelled'
				WHEN 6 THEN 'MergeCancelled'
				ELSE NULL
			  END AS CardStatus
FROM membership.dbo.Membership m WITH(NOLOCK)
	JOIN Membership.dbo.MembershipCard mc WITH(NOLOCK)
		ON m.MembershipID = mc.MembershipID
	JOIN genesiscorp.dbo.RealmUser r
		ON m.MembershipID = r.MembershipID
	JOIN GenesisCorp.dbo.Customer c
		ON r.CustomerID = c.CustomerID
WHERE mc.CardNumber = @CardNum


-- GenCorp enrolled but unactivated pur cards where user has no multipass account
WITH MemCard_CTE AS (
SELECT TOP 10000 m.MembershipID, mc.CardNumber
			, CASE mc.CardStatusID
				WHEN 0 THEN 'Unknown'
				WHEN 1 THEN 'Active'
				WHEN 2 THEN 'Inactive'
				WHEN 3 THEN 'Terminated'
				WHEN 4 THEN 'Deactivated'
				WHEN 5 THEN 'Cancelled'
				WHEN 6 THEN 'MergeCancelled'
				ELSE NULL
			  END AS CardStatus
 FROM membership.dbo.Membership m WITH(NOLOCK)
	JOIN Membership.dbo.MembershipCard mc WITH(NOLOCK)
		ON m.MembershipID = mc.MembershipID
)
SELECT TOP 100 MemCard_CTE.MembershipID, MemCard_CTE.CardStatus, MemCard_CTE.CardNumber
			, m.CreatedDate, m.ExpirationDate
			, r.CustomerID, r.OpenIDClaimedIdentifier
			, c.CustomerID, c.EmailAddress, c.HomePhone
			,	CASE c.ProfileStatusID
					WHEN 1 THEN 'Active'
					WHEN 2 THEN 'NonActivated'
					ELSE NULL
				END AS ProfileStatus
FROM MemCard_CTE WITH(NOLOCK)
	JOIN Membership.dbo.Membership m WITH(NOLOCK)
		ON MemCard_CTE.MembershipID = m.MembershipID
	JOIN genesiscorp.dbo.RealmUser r WITH(NOLOCK)
		ON m.MembershipID = r.MembershipID
	JOIN GenesisCorp.dbo.Customer c WITH(NOLOCK)
		ON r.CustomerID = c.CustomerID
WHERE MemCard_CTE.CardStatus = 'Inactive'
  AND c.ProfileStatusID = 2
  
--ConPro customers with enrolled pur card with no multipass acct
WITH MemCard_CTE AS (
SELECT TOP 10000 m.MembershipID, mc.CardNumber

FROM membership.dbo.Membership m WITH(NOLOCK)
	JOIN Membership.dbo.MembershipCard mc WITH(NOLOCK)
		ON m.MembershipID = mc.MembershipID
WHERE mc.CardStatusID = '2'
  AND m.MembershipStatusID = '2'
)
SELECT TOP 100 MemCard_CTE.MembershipID, MemCard_CTE.CardNumber
			, m.CreatedDate, m.ExpirationDate
			, r.CustomerID, r.OpenIDClaimedIdentifier
			, c.CustomerID, c.EmailAddress, c.HomePhone
			,	CASE c.ProfileStatusID
					WHEN 1 THEN 'Active'
					WHEN 2 THEN 'NonActivated'
					ELSE NULL
				END AS ProfileStatus
FROM MemCard_CTE WITH(NOLOCK)
	JOIN Membership.dbo.Membership m WITH(NOLOCK)
		ON MemCard_CTE.MembershipID = m.MembershipID
	JOIN genesiscorp.dbo.RealmUser r WITH(NOLOCK)
		ON m.MembershipID = r.MembershipID
	JOIN GenesisCorp.dbo.Customer c WITH(NOLOCK)
		ON r.CustomerID = c.CustomerID
WHERE c.ProfileStatusID = 2
