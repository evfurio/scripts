SELECT TOP 1000 o.orderID, o.orderDate, o.orderAmount, o.orderPaymentMethod, o.orderIsComplete
		, o.orderCurrencyType, o.orderSTax, od.StateTax
	, os.OrderStatusName
	, od.odrdtCategory, od.odrdtManufacturer, od.odrdtProductName, od.odrdtProductID
	, c.custFirstName, c.custLastName, c.custAddr1, c.custAddr2, c.custCity, c.custState, c.custZip
		, c.custCounty, c.custCountry, c.custEmail
	
FROM store.dbo.sfOrders o WITH (NOLOCK)
	JOIN store.dbo.sfOrderStatus os WITH (NOLOCK)
		ON o.orderStatus = os.OrderStatusID
	JOIN store.dbo.sfOrderDetails od WITH (NOLOCK)
		ON o.orderID = od.odrdtOrderId
	JOIN store.dbo.sfCustomers c WITH (NOLOCK)
		ON o.orderCustId = c.custID
		
WHERE o.orderDate > '2012-03-01 00:00:00.000' 
  AND c.custCountry = 'US'
  AND o.orderSTax = 0.00 AND od.StateTax <> 0.00
  AND od.StateTax <> 0.00
  AND o.orderPaymentMethod <> 'REDEMPTION' 
  AND o.orderPaymentMethod <> 'REFUND' 
  AND c.custState NOT IN ('TX','MI','AK','AR','CA','DE','FL','GA','GU','IA','MD','MT','NV','NH','OK','OR','SC','VA')
		
ORDER BY o.orderDate DESC, o.orderID DESC