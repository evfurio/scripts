SELECT TOP 1000 * 
FROM SDNet_Debug.dbo.sdnet_Debug WITH (NOLOCK)
WHERE CreateDate >= '2013-04-19 10:00:00.000'
  --AND CreateDate <= '2012-10-31 10:15:00.000'
   AND Location NOT LIKE 'dl1.impulsedriven.com%'
   AND Location NOT LIKE 'dl2.impulsedriven.com%'
   --AND Location NOT LIKE 'Stardock.Store.Taxes.CalculateCartTaxes'
   --AND Location NOT LIKE 'GameStopFraudService.FraudDetected()'
ORDER BY CreateDate DESC

SELECT TOP 1000 *
FROM SDNet_Debug.dbo.sdnet_Error WITH (NOLOCK)
WHERE ErrorDate >= '2013-04-19 08:00:00.000'
  --AND ErrorDate <= '2012-10-31 10:15:00.000'
  --AND Version = 'MachineAuthorization'
  AND Email <> 'GetEmailQueue'
  AND Email <> 'checkout.aspx.InitCreditCard'
  AND ExceptionDesc <> 'INFORMATIONAL: SVS Balance Inquiry'
ORDER BY ErrorDate DESC



