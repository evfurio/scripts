select a.orderid, b.referenceorderid, a.orderdate as original_order_date, b.orderdate as return_order_date, a.orderamount as order_amount, b.orderamount as return_amount
from store.dbo.sforders a with (nolock)
	join store.dbo.sforders b with (nolock)
		on a.orderid = b.referenceorderid
where b.orderdate > '2011-09-01 00:00:00.000'
and a.orderamount <> abs(b.orderamount)
order by a.orderdate desc