SELECT TOP 100 fo.*, fct.*, o.orderdate, c.custfirstname, c.custlastname, c.custid
FROM store.dbo.store_fraudorders fo
	left outer join store.dbo.store_fraudcriteriatypes fct
		on fct.criteriatype = fo.fraudcriteria
	join store.dbo.sforders o
		on fo.orderid = o.orderid
	join store.dbo.sfcustomers c
		on o.ordercustid = c.custid
--where custlastname = 'laftest'
order by fo.orderid desc