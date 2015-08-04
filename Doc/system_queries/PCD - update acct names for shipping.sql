UPDATE store.dbo.sfCustomers
SET custFirstName = 'Johnny', custLastName = 'Newberry'
WHERE custID = 1322324
GO
UPDATE store.dbo.sfCShipAddresses
SET cshpaddrShipFirstName = 'Johnny', cshpaddrShipLastName = 'Newberry'
WHERE sfCShipAddresses.cshpaddrID = 1299090 
GO
UPDATE store.dbo.sfCustomers
SET custFirstName = 'Ed', custLastName = 'Roth'
WHERE custID = 1322330
GO
UPDATE store.dbo.sfCShipAddresses
SET cshpaddrShipFirstName = 'Ed', cshpaddrShipLastName = 'Roth'
WHERE sfCShipAddresses.cshpaddrID = 1299096 
GO
UPDATE store.dbo.sfCustomers
SET custFirstName = 'Aubrey', custLastName = 'Brown'
WHERE custID = 1322332
GO
UPDATE store.dbo.sfCShipAddresses
SET cshpaddrShipFirstName = 'Aubrey', cshpaddrShipLastName = 'Brown'
WHERE sfCShipAddresses.cshpaddrID = 1299099 
GO
UPDATE store.dbo.sfCustomers
SET custFirstName = 'Missy', custLastName = 'Nelson'
WHERE custID = 1322338
GO
UPDATE store.dbo.sfCShipAddresses
SET cshpaddrShipFirstName = 'Missy', cshpaddrShipLastName = 'Nelson'
WHERE sfCShipAddresses.cshpaddrID = 1299106 
GO
UPDATE store.dbo.sfCustomers
SET custFirstName = 'Macy', custLastName = 'Pitt'
WHERE custID = 1322340
GO
UPDATE store.dbo.sfCShipAddresses
SET cshpaddrShipFirstName = 'Macy', cshpaddrShipLastName = 'Pitt'
WHERE sfCShipAddresses.cshpaddrID = 1299109 
GO
SELECT c.custID AS Customer_ID, c.custFirstName, c.custLastName, C.custEmail
         ,o.orderID
         ,s.cshpaddrID AS Shipping_ID, s.cshpaddrShipFirstName, s.cshpaddrShipLastName
FROM store.dbo.sfCustomers c
       JOIN store.dbo.sfOrders o
              ON c.custID = o.orderCustId
       JOIN store.dbo.sfCShipAddresses s
              ON o.orderAddrId = s.cshpaddrID
WHERE o.orderID in (2198671, 2198677, 2198680, 2198688, 2198691)