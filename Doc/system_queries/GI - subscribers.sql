SELECT TOP 1000 sb.LastName, sb.FirstName, e.EmailAddress, sb.Phone, a.Address1, a.City, a.State, a.ZipCode, sb.SubscriberID
FROM GI_Subscription.dbo.gs_Subscriber sb (NOLOCK)
	JOIN GI_Subscription.dbo.gs_EmailAddress e (NOLOCK)
		ON sb.SubscriberID = e.SubscriberID
	JOIN GI_Subscription.dbo.gs_Address a (NOLOCK)
		ON sb.SubscriberID = a.SubscriberID
WHERE e.EmailAddress like '%@gspcauto.fav.cc'
  AND e.IsActive = 1
  AND a.IsActive = 1
ORDER BY sb.LastName, sb.FirstName, a.Address1