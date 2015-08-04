SELECT top 1000 [pkScreenshot]
      ,[fkContent]
      ,[VirtualPath]
      ,[LocalSmallPath]
      ,[LocalLargePath]
  FROM [ContentIntegration].[dbo].[Screenshots]
  where localsmallpath <> '' 
  and pkScreenshot = '207273'
  --and fkcontent = '34588'
  order by 1 desc
GO

select * from [ContentIntegration].[dbo].[ContentAssignments] a
right join [ContentIntegration].[dbo].[Screenshots] b on a.fkcontent = b.fkcontent
where localsmallpath <> '' and  localproductid != ''
order by updated desc
 
