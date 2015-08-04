SELECT TOP 1000 p.prodName, p.prodPrice, p.prodID
FROM Store.dbo.sfProducts p
WHERE 
--change operator to "=" to find products that require email activation on a new acct before purchasing
p.FraudFlags <> 1 
--change to 'not in' to find products that are NOT subject to internal fraud rules 
and p.prodID IN (SELECT DataToCatch FROM Store.dbo.store_FraudCriteria)
ORDER BY p.prodName