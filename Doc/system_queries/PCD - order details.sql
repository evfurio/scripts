SELECT TOP 100 *
FROM Store.dbo.sfOrders o
	join store.dbo.sforderdetails od
		on o.orderid = od.odrdtid
	join store.dbo.sfcustomers c
		on o.ordercustid = c.custid
where custlastname like '%laftest%'
order by o.orderdate desc