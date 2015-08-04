use store
go
set nocount on
go
declare @emailaddr nvarchar(50)
set @emailaddr = 'jontestqa+1012111140@gmail.com'
set nocount off
--CCInfo.CCInfo.sfCPayments
select case paycardtype
	     when '1' then 'Amex'
	     when '2' then 'Visa'
	     when '3' then 'Disc'
	     when '4' then 'MC'
	   else paycardtype
	   end CCType,  
       p.payid
from ccinfo.ccinfo.sfcpayments p
	join store.dbo.sfcustomers c
		on p.paycustid = c.custid
where c.custemail = @emailaddr
order by payid desc
--Store.dbo.sfCustomerPurchaseReference
select cpr.*
from store.dbo.sfcustomerpurchasereference cpr
	join store.dbo.sfcustomers c
		on c.custid = cpr.custid
where c.custemail = @emailaddr
order by cpr.custpurchrefid desc
--Store.dbo.sfOrders
select o.*
from store.dbo.sforders o
	join store.dbo.sfcustomers c
		on c.custid = o.ordercustid
where c.custemail = @emailaddr
order by o.orderdate desc
--Store.dbo.sfOrdersAE
select ae.*
from store.dbo.sfordersae ae
	join store.dbo.sforders o
		on ae.orderaeid = o.orderid
	join store.dbo.sfcustomers c
		on c.custid = o.ordercustid
where c.custemail = @emailaddr
order by ae.orderaeid desc
/*select top 50 p.payid, p.paycustid
			 , c.custemail
			 , o.orderid, o.orderdate
			 , cpr.*
from CCInfo.CCInfo.sfCPayments p
	join store.dbo.sfcustomers c  with (nolock)
		on p.paycustid = c.custid
	join store.dbo.sforders o with (nolock)
		on c.custid = o.ordercustid
	join store.dbo.sfcustomerpurchasereference cpr with (nolock)
		on c.custid = cpr.custid
where c.custemail = @emailaddr
order by o.orderdate desc*/