select
rs.description as status,
count(rs.description) as total
from Dcon_Scenario_Runs sr
join Dcon_Run_Instances ri on sr.dcon_run_instance_id = ri.id
join Dcon_Run_States rs on sr.dcon_run_state_id = rs.id
where start_time > dateadd(hour, -15, getdate()) and ri.computer_name in ('DL1GSQLT03','DL1GSQLT04','DL1GSQLT05')
group by rs.description