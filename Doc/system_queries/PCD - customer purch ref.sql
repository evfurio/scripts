select 	 cpr.custpurchrefid, c.custid, cpr.referencenumber, 
		 'status' = 
			case 
				when cpr.isactive = 1 then 'ACTIVE' 
				else 'INACTIVE' 
			end,		 
		 c.custfirstname, c.custlastname, c.custemail
from	 Store.dbo.sfCustomerPurchaseReference cpr
		 join Store.dbo.sfCustomers c
			 on cpr.custid = c.custid
where	 --c.custemail like 'jontestqa%' or c.custemail like '%jon_laf%'
		 c.custemail = 'bmnofraud1234501042013a@gspctest.fav.cc'
order by cpr.custpurchrefid desc

select * from store.dbo.sforders where sfOrders.orderID = 2280336

update store.dbo.sfOrders
set orderStatus = '5'
where orderID = 2280336
