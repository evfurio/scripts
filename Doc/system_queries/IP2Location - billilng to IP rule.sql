SELECT top 1000 *
FROM IP2Location.dbo.IPInfo
--WHERE ipZIPCODE = '76211'
WHERE countrySHoRT = 'US' and ipREGION = 'TEXAS' and ipCITY = 'DENTON'

SELECT *
FROM iP2Location.dbo.IPInfo
WHERE ipFROM = 68586496 or ipTO = 68586496

declare @what as int  
set @what = 2887764500
select
  @what [Input],
  convert(varchar(3), (@what/16777216) & 255) + '.'
    + convert(varchar(3), (@what/65536) & 255) + '.'
    + convert(varchar(3), (@what/256) & 255) + '.'
    + convert(varchar(3), @what & 255)
  as IP_Address
  
  select * from sys.databases
  
  exec dbo.GetIP2Location @IP=2887764499