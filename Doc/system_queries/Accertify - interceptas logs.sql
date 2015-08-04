SELECT t.ClientTransactionId AS Order_ID, t.ProcessDate 
         ,'Direction' = 
                     CASE  WHEN d.DirectionId = 1 THEN 'Initial Recommendation from Accertify'
                           WHEN d.DirectionId = 2 THEN 'Processed from Interceptas'
                           ELSE NULL
                     END
         ,ra.RecommendedAction
FROM Logging_FraudService.dbo.Transactions t
       JOIN Logging_FraudService.dbo.Clients c
              ON t.ClientId =  c.ClientId
       JOIN Logging_FraudService.dbo.Directions d
              ON t.DirectionId = d.DirectionId
       JOIN Logging_FraudService.dbo.Providers p
              ON t.ProviderId = p.ProviderId
       JOIN Logging_FraudService.dbo.RecommendedActions ra
              ON t.RecommendedActionId = ra.RecommendedActionId
WHERE t.ProcessDate >= '2013-04-23 11:00:00.000'
		AND p.ProviderId = 1
	--AND d.DirectionId = 2
    --AND t.ClientTransactionId = '2283327'
ORDER BY t.ProcessDate DESC 