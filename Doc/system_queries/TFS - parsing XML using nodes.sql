select top 1000 *--words
from tfs_ecom.dbo.WorkItemLongTexts
where AddedDate > '2012-01-01 00:00:00.000' 
	and FldID = 10040
	
create table dbo.temp (id int identity(1,1), words XML)
create table dbo.temp1 (id int identity(1,1), step varchar(100), description varchar(500))

insert into temp (words)

SELECT TOP 1000 w.Words
FROM [Tfs_ecom].[dbo].[WorkItemLongTexts] w
where w.AddedDate > '2012-01-01 00:00:00.000'
  and FldID = 10040 --for xml auto


declare @ctr int
declare @max int
declare @xml xml

set @ctr = 1
select @max = MAX(id) from temp

while @ctr <= @max
begin

select @xml = words from temp where id = @ctr

insert into temp1 (step)
SELECT
   stepid.value('.','varchar(100)') AS stepid
FROM @xml.nodes('/steps/step') Steps(stepid)

set @ctr = @ctr + 1
end


select *
from temp1