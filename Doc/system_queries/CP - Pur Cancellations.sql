SELECT TOP 100
	   re.EventDescription  
	 , c.EmailAddress
	 , m.CreatedDate, m.MembershipID, ms.Status AS MembershipStatus
	 , cs.[Status] AS CardStatus , mc.CardNumber

FROM Membership.dbo.Membership m WITH(NOLOCK)
	JOIN Membership.dbo.MembershipCard mc WITH(NOLOCK)
		ON m.MembershipID = mc.MembershipID
	JOIN Membership.dbo.MemberShipEventLog mel WITH(NOLOCK)
		ON m.MembershipID = mel.MembershipID 
	JOIN Membership.dbo.refEvents re WITH(NOLOCK)
		ON mel.EventID = re.EventID
	JOIN Membership.dbo.refProgram rp WITH(NOLOCK)
		ON m.MembershipProgramID = rp.ProgramID
	JOIN Membership.dbo.refMembershipStatus ms WITH(NOLOCK)
		ON m.MembershipStatusID = ms.MembershipStatusID
	JOIN Membership.dbo.refCardStatus cs WITH(NOLOCK)
		ON mc.CardStatusID = cs.CardStatusID
	JOIN GenesisCorp.dbo.RealmUser ru WITH(NOLOCK)
		ON m.MembershipID = ru.MembershipID
	JOIN GenesisCorp.dbo.Customer c WITH(NOLOCK)
		ON ru.CustomerID = c.CustomerID
WHERE re.EventID = 10

