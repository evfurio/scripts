
--SELECT COUNT(*) --3617443
SELECT TOP 1000 
	  uo.dt_date_created, uo.i_customer_id, uo.u_email_address
	, mu.OpenIDClaimedIdentifier
FROM Gamestop_profiles.dbo.userobject uo WITH(NOLOCK)
	JOIN Gamestop_profiles.dbo.stage_MultipassUsers mu WITH(NOLOCK)
		ON uo.u_email_address = mu.UserName