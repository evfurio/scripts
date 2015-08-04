SELECT COUNT(*) as Number_of_Titles, p.prodCategoryId, c.CategoryName
FROM store.dbo.sfProducts p
	JOIN Store.dbo.store_Categories c
		ON p.prodCategoryId = c.CategoryID
WHERE p.prodCategoryId = 6 OR c.ParentCategoryID = 6
GROUP BY prodCategoryId, c.CategoryName
ORDER BY Number_of_Titles DESC

SELECT COUNT(*) AS Total, sfProducts.prodID, sfproducts.prodName, sfOrderDetails.odrdtSubTotal
	 , COUNT(*) * cast(sfOrderDetails.odrdtSubTotal AS MONEY) AS Total_Dollars

FROM sfOrders WITH (NOLOCK)
	RIGHT OUTER JOIN sfOrderDetails  WITH (NOLOCK)
		ON sfOrders.orderID = sfOrderDetails.odrdtOrderId
	LEFT OUTER JOIN sfProducts WITH (NOLOCK)
		ON sfOrderDetails.odrdtProductID = sfProducts.prodID 
		
WHERE (sfOrders.orderDate > GETDATE() - 1) 
  AND (sfOrders.orderStatus IN (1, 4, 5)) 
  AND (sfProducts.prodEnabledIsActive = 1) 
  AND (sfProducts.prodShortName <> '')
  AND sfOrders.orderPaymentMethod <> 'Redemption'
  
GROUP BY sfProducts.prodID, sfproducts.prodName, sfOrderDetails.odrdtSubTotal

ORDER BY Total_Dollars DESC