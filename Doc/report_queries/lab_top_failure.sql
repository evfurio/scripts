select top 20
fd.description as failure_description, count(fd.description) as total
from Dcon_Scenario_Runs sr
join Dcon_Run_Instances ri on sr.dcon_run_instance_id = ri.id
join Dcon_Run_States rs on sr.dcon_run_state_id = rs.id
join Dcon_Failure_Details fd on sr.id = fd.dcon_scenario_run_id
where start_time > dateadd(hour, -24, getdate()) and ri.computer_name in ('DL1GSQLT03','DL1GSQLT04','DL1GSQLT05') and rs.description = 'FAIL'
group by fd.description
order by total desc
