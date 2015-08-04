--parse email address for domain - all characters after the @ sign but before the last '.'
select top 100 AccountEmail, substring(accountemail, charindex('@', accountemail)+1, (len(accountemail) - charindex('.', reverse(accountemail))) - charindex('@', accountemail))
from stardock.dbo.tb_Accounts with (nolock)
where AccountEmail is not null
  and AccountEmail <> ''
  and AccountEmail <> '-'
  and AccountEmail <> '.'  
  and AccountEmail not like '%.com'
  and AccountEmail not like '%.net'
  and AccountEmail not like '%.edu'
  and AccountEmail not like '%.mil'  
  and AccountEmail not like '%.de'
  and AccountEmail not like '%.uk'  
  and AccountEmail not like '%.ca'

/*select count(*)
from stardock.dbo.tb_accounts
select count(*)
from stardock.dbo.tb_accounts
where AccountEmail like '%+%'*/