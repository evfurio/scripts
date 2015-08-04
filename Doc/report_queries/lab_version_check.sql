select  top 1 ri.dcon_version, ri.finders_version, ri.scripts_version
from Dcon_Scenario_Runs sr
join Dcon_Run_Instances ri on sr.dcon_run_instance_id = ri.id
where sr.start_time > dateadd(hour, -15, getdate()) and ri.computer_name in ('DL1GSQLT03','DL1GSQLT04','DL1GSQLT05')
