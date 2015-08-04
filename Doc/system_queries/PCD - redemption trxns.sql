SELECT a.AccountEmail, a.AccountID
	 , o.CustomerID, SUBSTRING(o.OrderNumber, 1, 7) AS OrderID
	 , r.SerialNum, r.ProductID, r.RegistrationID
	 , p.Name, p.ActualAvailable, p.SerialsRemaining, p.AvgDailySales, p.AvgDailySalesUpdated
     , cp.LastSRID

FROM Stardock.dbo.tb_Accounts a
	JOIN stardock.dbo.tb_Order o
		ON a.CustomerID = o.CustomerID
	JOIN stardock.dbo.tb_Registration r
		ON o.CustomerID = r.CustomerID
	JOIN stardock.dbo.tb_Product p
		ON r.ProductID = p.ProductID
	JOIN Commerce.Commerce.dbo.tb_Product cp
		ON p.ProductID = cp.ProductID

WHERE a.AccountEmail = 'qa1023redemption25397@gspcauto.fav.cc'
ORDER BY a.AccountEmail

---

select store_RedemptionCodes.*, store_Sku.SkuName as Name 
from store_RedemptionCodes 
	left outer join store_Sku on store_Sku.SkuID = store_RedemptionCodes.SkuID 
where store_RedemptionCodes.Code = 'KMCZ-JJA2-FPW4' 
  --and store_RedemptionCodes.OrderDetailID is null 

update store_RedemptionCodes 
set OrderDetailID = 2267060 
where Code = 'KMCZ-JJA2-FPW4'

update store_RedemptionCodes 
set OrderDetailID = 2890779
where Code = 'KMCZ-JJA2-FPW4'