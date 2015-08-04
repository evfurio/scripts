select SR.tc_description, SR.start_time, SR.stop_time, RS.description as run_status, F.description as failure_description, RI.computer_name, RI.dcon_version, RI.scripts_version, RI.finders_version, RI.user_name
from dbo.Dcon_Run_Instances RI
join Dcon_Scenario_Runs SR on RI.id = SR.id
join Dcon_Run_States RS on RS.id = SR.dcon_run_state_id
join Dcon_Failure_Details F on F.dcon_scenario_run_id = SR.id
where CAST(SR.start_time AS DATE) = CAST(GETDATE() AS DATE) and scripts_version = '3.0.0'

order by start_time desc





