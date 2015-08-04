
SELECT TOP (100) PERCENT c.custFirstName + ' ' + c.custLastName AS CustomerName, c.custEmail AS Email
					   , o.orderID, o.orderDate
					   , t.trnsrspCustTransNo AS TransactionNumber
					   , o.orderPaymentMethod AS PaymentMethod
						
FROM store.dbo.sfTransactionResponse t WITH (NOLOCK, INDEX (ak_sfTransactionResponse_Status_Parsed_Success)) 
	INNER JOIN store.dbo.sfOrders o WITH (NOLOCK) 
		ON o.orderID = t.trnsrspOrderId 
	INNER JOIN store.dbo.sfCustomers c WITH (NOLOCK) 
		ON c.custID = o.orderCustId
		
WHERE (o.orderIsComplete = 1) 
  AND (t.trnsrspSTATUS = 'TICKET') AND (t.trnsrspSDSParsed = 0) 
  AND (t.trnsrspSuccess = 1) AND (GETDATE() > DATEADD(N, 1, o.orderDate))
  
ORDER BY orderID

SELECT TOP (100) PERCENT c.custFirstName + ' ' + c.custLastName AS CustomerName, c.custEmail AS Email
					   , o.orderID, o.orderDate
					   , t.trnsrspCustTransNo AS TransactionNumber
					   , o.orderPaymentMethod AS PaymentMethod
						
FROM store.dbo.sfTransactionResponse t WITH (NOLOCK, INDEX (ak_sfTransactionResponse_Status_Parsed_Success)) 
	INNER JOIN store.dbo.sfOrders o WITH (NOLOCK) 
		ON o.orderID = t.trnsrspOrderId 
	INNER JOIN store.dbo.sfCustomers c WITH (NOLOCK) 
		ON c.custID = o.orderCustId
		
WHERE (o.orderIsComplete = 1) 
  AND (t.trnsrspSTATUS = 'TICKET') AND (t.trnsrspSDSParsed = 0) 
  AND (t.trnsrspSuccess = 1) AND (GETDATE() > DATEADD(N, 5, o.orderDate))
  
ORDER BY orderID