
SELECT ts.TransBusDateId, COUNT(ts.SalesTransHeaderId)
FROM GSEDW.sales.TransSummary ts (NOLOCK)
	JOIN GSEDW.sales.TransLine tl (NOLOCK)
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
	JOIN GSEDW.dbo.ProductKey pk (NOLOCK)
		ON tl.ProductId = pk.ProductId
	JOIN GSEDW.dbo.ProductReportingCategory prc (NOLOCK)
		ON pk.ReportingCategoryCode = prc.ReportingCategoryCode
	JOIN GSEDW.sales.TransTender tt (NOLOCK)
		ON ts.SalesTransHeaderId = ts.SalesTransHeaderId
WHERE ts.TransBusDateId = '<date variable>'
  AND <lvl of cat code> = <cat code>
  AND tt.TenderType IN (<tender types from Dim_TenderType>)

SELECT COUNT(*) FROM GSEDW.sales.TransSummary
SELECT COUNT(*) FROM GSEDW.sales.TransTender
SELECT COUNT(*) FROM GSEDW.sales.TransHeader
SELECT COUNT(*) FROM GSEDW.sales.TransLine
SELECT COUNT(*) FROM GSEDW.dbo.ProductKey

--113, Other CC Preowned Txns
SELECT ts.TransBusDateId, COUNT(ts.SalesTransHeaderId) AS OtherCCPreownedTxns 
FROM sales.TransSummary ts (NOLOCK)
	JOIN sales.TransLine tl (NOLOCK) 
		ON ts.SalesTransHeaderId = tl.SalesTransHeaderId
    JOIN dbo.ProductKey pk (NOLOCK) 
		ON tl.ProductId = pk.ProductId
    JOIN ProductDescHistory pd (NOlOCK) 
		ON pk.DescHistoryKey = pd.PIDescHistoryKey
    JOIN dbo.ProductReportingCategory c (NOLOCK) 
		ON pk.ReportingCategoryCode = c.ReportingCategoryCode
    JOIN sales.TransTender t (NOLOCK) 
		ON ts.SalesTransHeaderId = t.SalesTransHeaderId
WHERE ts.TransBusDateId = 20131201
AND c.Level2CategoryCode = 015 --Used
AND t.TenderType IN (3,4,5,6) --MC, Visa, AMEX, Disc
GROUP BY ts.TransBusDateId


SELECT DISTINCT prc.ReportingCategoryCode AS Console
FROM GSEDW.dbo.ProductReportingCategory prc
WHERE prc.Level5CategoryName LIKE '%Console%'
ORDER BY prc.ReportingCategoryCode

SELECT DISTINCT prc.Level3CategoryCode AS Accessories
FROM GSEDW.dbo.ProductReportingCategory prc
WHERE prc.Level3CategoryName LIKE '%Acc%'
ORDER BY prc.Level3CategoryCode

SELECT DISTINCT prc.Level2CategoryCode AS DLC
FROM GSEDW.dbo.ProductReportingCategory prc
WHERE prc.Level2CategoryName LIKE '%DLC%'
ORDER BY prc.Level2CategoryCode

SELECT DISTINCT prc.Level2CategoryCode AS POSA
FROM GSEDW.dbo.ProductReportingCategory prc
WHERE prc.Level2CategoryName LIKE '%POSA%'
ORDER BY prc.Level2CategoryCode

SELECT DISTINCT prc.Level1CategoryCode AS Video_Games
FROM GSEDW.dbo.ProductReportingCategory prc
WHERE prc.Level1CategoryName LIKE '%Video Game%'
ORDER BY prc.Level1CategoryCode

SELECT DISTINCT prc.Level4CategoryCode AS Consumer_Electronic_Accessories
FROM GSEDW.dbo.ProductReportingCategory prc
WHERE prc.Level4CategoryName LIKE '%CE Acc%'
ORDER BY prc.Level4CategoryCode

SELECT DISTINCT prc.Level2CategoryCode AS New
FROM GSEDW.dbo.ProductReportingCategory prc
WHERE prc.Level2CategoryName LIKE '%New%'
ORDER BY prc.Level2CategoryCode

SELECT DISTINCT prc.Level2CategoryCode AS Used
FROM GSEDW.dbo.ProductReportingCategory prc
WHERE prc.Level2CategoryName LIKE '%Used%'
ORDER BY prc.Level2CategoryCode

	