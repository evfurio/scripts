CREATE TABLE #MyTempTable (acctID INT NOT NULL, AcctEmail NVARCHAR(65))

DROP TABLE #MyTempTable 

WITH TestAcct_CTE (AcctEmail) AS 
(
SELECT AcctEmail	
FROM #MyTempTable
WHERE AcctEmail NOT LIKE '%thebryanmills%'
  AND  AcctEmail NOT LIKE '%shadowkat%'
  AND  AcctEmail NOT LIKE '%snguitest%'
  AND  AcctEmail NOT LIKE '%ryan.champ%'
  AND  AcctEmail NOT LIKE '%blakeclark%'
  AND  AcctEmail NOT LIKE '%BMNOFRAUD12345%'      
  AND  AcctEmail NOT LIKE '%jlnofraud12345%'  
  AND  AcctEmail NOT LIKE '%jonatestqa%'
  AND  AcctEmail NOT LIKE '%jontestqa%'  
  AND  AcctEmail NOT LIKE '%chelsealovas%'  
  AND  AcctEmail NOT LIKE '%woolley.dean%'  
  AND  AcctEmail NOT LIKE '%chuantang%'  
  AND  AcctEmail NOT LIKE '%clovasgs%'  
  AND  AcctEmail NOT LIKE '%davidbritton.ballard%'
  AND  AcctEmail NOT LIKE '%Dominic.Galasso%'
  AND  AcctEmail NOT LIKE '%kwilas%'
  AND  AcctEmail NOT LIKE '%kwindisc%'
  AND  AcctEmail NOT LIKE '%ottomatin%'
  AND  AcctEmail NOT LIKE '%gs.testinguse%'
  AND  AcctEmail NOT LIKE '%phaedrus%'
  AND  AcctEmail NOT LIKE '%ianmaginary%'
  AND  AcctEmail NOT LIKE '%impulseloadtest%'
  AND  AcctEmail NOT LIKE '%impulsework%'
  AND  AcctEmail NOT LIKE '%mikepennington%'
  AND  AcctEmail NOT LIKE '%impulse%'
  AND  AcctEmail NOT LIKE '%stardock%'
  AND  AcctEmail NOT LIKE '%gamestop%'    
)
SELECT *
FROM TestAcct_CTE
WHERE AcctEmail LIKE '%+%gmail%'
ORDER BY 1