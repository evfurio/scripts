SELECT a.OathToken, a.MagicNumber, ma.MachineAuthID, ma.MachineName, ma.AuthKey, ma.IsIPT
FROM stardock.dbo.tb_Accounts a
	JOIN stardock.dbo.tb_AccountMachineAuth ma
		ON a.AccountID = ma.AccountID
WHERE a.AccountEmail = 'jlnofraud123450423130911@gspcauto.fav.cc'