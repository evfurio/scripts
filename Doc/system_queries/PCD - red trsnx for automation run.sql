
SELECT a.AccountEmail, a.AccountID
	 , o.CustomerID, o.OrderNumber
	 , r.SerialNum, r.ProductID, r.RegistrationID

FROM Stardock.dbo.tb_Accounts a
	JOIN stardock.dbo.tb_Order o
		ON a.CustomerID = o.CustomerID
	JOIN stardock.dbo.tb_Registration r
		ON o.CustomerID = r.CustomerID

WHERE r.SerialNum <> '[No serial number required]'
  AND a.AccountEmail IN 
(
<Insert account emails here>
)

ORDER BY a.AccountEmail

---

SELECT a.AccountEmail, a.AccountID
	 , o.CustomerID, o.OrderNumber
	 , r.SerialNum, r.ProductID, r.RegistrationID
	 , p.Name

FROM Stardock.dbo.tb_Accounts a
	JOIN stardock.dbo.tb_Order o
		ON a.CustomerID = o.CustomerID
	JOIN stardock.dbo.tb_Registration r
		ON o.CustomerID = r.CustomerID
	JOIN stardock.dbo.tb_Product p
		ON r.ProductID = p.ProductID

WHERE r.SerialNum <> '[No serial number required]'
  AND a.AccountEmail IN 
(
  'qa1023redemption25397@gspcauto.fav.cc'
, 'qa1023redemption34410@gspcauto.fav.cc'
, 'qa1023redemption6426@gspcauto.fav.cc'
)
ORDER BY a.AccountEmail