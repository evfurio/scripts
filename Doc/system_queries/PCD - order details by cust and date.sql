Use Store
SELECT TOP 100 o.orderid, o.ordercustid, o.orderdate, o.orderamount, o.orderstatus, os.orderstatusname
			 , od.odrdtproductname, c.custfirstname, c.custlastname, c.custemail, c.custid
FROM Store.dbo.sfOrders o with (nolock)
	join store.dbo.sforderdetails od with (nolock)
		on o.orderid = od.odrdtorderid
	join store.dbo.sfcustomers c with (nolock)
		on o.ordercustid = c.custid
	join store.dbo.sforderstatus os with (nolock)
		on os.orderstatusid = o.orderstatus
where custlastname like '%watkins%'
--and orderdate > getdate() - 8
order by o.orderdate desc