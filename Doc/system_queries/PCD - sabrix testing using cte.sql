--using CTE to dynamically query store.dbo.sfOrderDetails and adding details from sfOrders, sfCustomers, sforderstatus
WITH Orders_CTE (OrderID, TotalTax) 
AS
(
SELECT TOP 10000 od.odrdtOrderId, SUM(statetax)
FROM [Store].[dbo].[sfOrderDetails] od
GROUP BY od.odrdtOrderId
ORDER BY od.odrdtOrderId DESC
)
SELECT o.orderID, o.orderSTax, tt.TotalTax
	 , o.orderDate, o.orderAmount, o.orderPaymentMethod, o.orderIsComplete, o.orderCurrencyType
	 , os.OrderStatusName
	 , c.custFirstName, c.custLastName, c.custAddr1, c.custAddr2, c.custCity, c.custState, c.custZip
		, c.custCounty, c.custCountry, c.custEmail
FROM store.dbo.sfOrders o WITH (NOLOCK)
	INNER JOIN Orders_CTE AS tt 
		ON o.orderID = tt.OrderID
	JOIN store.dbo.sfOrderStatus os WITH (NOLOCK)
		ON o.orderStatus = os.OrderStatusID
	JOIN store.dbo.sfCustomers c WITH (NOLOCK)
		ON o.orderCustId = c.custID	
WHERE o.orderDate > '2012-04-01 00:00:00.000'
  AND c.custCountry = 'US'
  AND o.orderPaymentMethod <> 'REDEMPTION' 
  AND o.orderPaymentMethod <> 'REFUND' 
  AND c.custState NOT IN ('TX','MI','AK','AR','CA','DE','FL','GA','GU','IA','MD','MT','NV','NH','OK','OR','SC','VA')
ORDER BY o.orderID DESC