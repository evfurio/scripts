-- stories showing up in 'the feed' on GI homepage

SET Transaction Isolation Level Read UNCOMMITTED 
declare @lrc int; 
set @lrc = 100; 
if @lrc IS NULL OR @lrc < 0 SET @lrc = 0; 
set rowcount @lrc;  

Select top 100 
 pc.Name, p.* 
from dbo.cs_Posts P 
inner join cs_Posts_InCategories pic (nolock) on p.PostId = pic.PostId
inner join cs_Post_Categories pc (nolock) on pic.CategoryId = pc.CategoryId
right join dbo.cs_Threads T 
        on (P.ThreadID = T.ThreadID) 
inner join dbo.cs_Sections S 
        on S.SettingsID = P.SettingsID 
        and S.SectionID = P.SectionID  
        and exists 
        ( 
                select 
                        1 
                from cs_vw_Security_NodeEffectiveActions NEA 
                where 
                        S.NodeId = NEA.NodeId 
                        AND NEA.ActionId = N'Read' 
                        and NEA.NodeTypeId = N'Blog' 
                        and exists 
                        ( 
                                select 
                                        1 
                                from dbo.cs_Security_UserRoles ur 
                                where 
                                        NEA.RoleId = ur.RoleId 
                                        AND ur.UserId = 2102 
                        ) 
        )  
where  
        P.SettingsID = 1000 
        and exists 
        ( 
                select 
                        1 
                from dbo.cs_GroupRoots G 
                where 
                        G.RootGroupID = 1 
                        and S.GroupID = G.GroupID 
        )  
        and S.ApplicationType = 1  
        and S.IsActive = 1  
        and P.ApplicationPostType & 1 <> 0  
        and P.PostConfiguration & 2 = 2  
        and P.PostID in 
        ( 
                select 
                        tPiC.PostID 
                from cs_Post_Categories tC 
                inner join cs_Posts_InCategories tPiC 
                        on tPiC.CategoryID = tC.CategoryID 
                inner join cs_Sections tS 
                        on tC.SectionID = tS.SectionID 
                where 
                        tC.Name in (N'News',N'Review',N'Preview',N'Feature',N'Podcast') 
                        and tC.SettingsID = 1000 
                        and tS.ApplicationType = 1  
                        and tS.IsActive = 1  
                        and tC.IsEnabled = 1 
        ) 
        and P.IsApproved = 1 
        and P.PostDate <= getdate()  
Order by P.PostDate desc
