SELECT p.ProductID, p.prodID, p.Name, pt.ProductTextLabel, pt.ProductTextData, ptt.ProductTextTypeName
FROM Stardock.dbo.tb_Product p
	JOIN Stardock.dbo.tb_ProductTexts pt
		ON p.ProductID = pt.ProductID
	JOIN Stardock.dbo.tb_ProductTextTypes ptt
		ON pt.ProductTexttype = ptt.ProductTextTypeID
WHERE ptt.ProductTextTypeID = 23 --change operator to "<>" to find products that are NOT age gated
ORDER BY p.Name