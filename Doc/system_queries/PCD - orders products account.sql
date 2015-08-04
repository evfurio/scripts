use stardock
select p.orderid, p.unitprice, o.orderdate, pr.name, pr.proddescription
from stardock.dbo.tb_purchase p
	join stardock.dbo.tb_order o
		on p.orderid = o.orderid
	join stardock.dbo.tb_accounts a
		on o.customerid = a.customerid
	join stardock.dbo.tb_product pr
		on p.productid = pr.productid
where accountemail = '<e-mail address here>'