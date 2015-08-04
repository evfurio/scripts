use stardock
update tb_accountproperties
set islockedout = 0, firstfailedloginattempt = NULL, failedloginattempts = 0
where accountid = '4418424' 
use stardock
SELECT *
FROM [Stardock].[dbo].[tb_AccountProperties]
where accountid = '4551283'
use stardock
SELECT TOP 1000 *
FROM [Stardock].[dbo].[tb_Accounts] a
	join [stardock].[dbo].[tb_accountproperties] ap
		on a.accountid = ap.accountid
where accountemail = 'bryanmills@gamestop.com'