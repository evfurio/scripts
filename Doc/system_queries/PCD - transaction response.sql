SELECT c.custfirstname, c.custlastname, c.custemail,
	   o.orderid, o.orderdate, o.orderamount, o.orderstatus,
	   cpr.referencenumber, cpr.isActive,
	   tr.*
FROM store.dbo.sftransactionResponse tr WITH (NOLOCK)
	join store.dbo.sforders o WITH (NOLOCK)
		ON tr.trnsrsporderid = o.orderid
	join store.dbo.sfcustomers c WITH (NOLOCK)
		ON o.ordercustid = c.custid
	join store.dbo.sfcustomerpurchasereference cpr
		ON c.custid = cpr.custid
WHERE c.custemail = 'JLNOFRAUD12345+062612@gmail.com'
	  and o.orderID = 2200759
ORDER BY o.orderdate DESC