
--ecom customers with no pur acct
SELECT TOP 1000 *
FROM Profile.Stage.Ecom_UserObject u WITH(NOLOCK)
	LEFT OUTER JOIN profile.stage.Genesis_Customer c WITH(NOLOCK)
		ON u.u_account_id = c.OpenIdClaimedIdentifier
WHERE u.u_email_address NOT LIKE '{%'
  AND c.OpenIdClaimedIdentifier IS NULL
  AND u.u_account_id NOT LIKE 'https://%'
ORDER BY u.u_email_address

