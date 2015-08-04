select top 10
    SR.id,
    SR.tc_id,
    SR.tc_description,
    replace(CONVERT(varchar(19), SR.start_time, 120),'/','-') as start_time,
    replace(CONVERT(varchar(19), SR.stop_time, 120),'/','-') as stop_time,
    ((SR.duration_millisec % (1000*60*60)) % (1000*60)) / 1000 as execution_time,
    BRO.browser as browser_type,
    DRS.description as test_state,
    RI.user_name,
    CASE WHEN DRS.description != 'FAIL' THEN DRS.description ELSE EFDup.description END as failure_desc,
    SR.dcon_run_instance_id,
    RI.dcon_version,
    RI.scripts_version,
    RI.finders_version,
    RI.computer_name,
    RI.ip_address,
    RI.processor_architecture,
    RI.operating_system

from Dcon_Scenario_Runs SR
join Dcon_Run_Instances RI on RI.id = SR.dcon_run_instance_id
join Dcon_Browsers BRO on BRO.id = SR.dcon_browser_id
join Dcon_Run_States DRS on DRS.id = SR.dcon_run_state_id
left join Dcon_Failure_Details EFDup on EFDup.dcon_scenario_run_id = SR.id

where
SR.dcon_run_state_id in (2,3)
and SR.start_time > dateadd(hour, -24, getdate())
and RI.user_name = 's_tfstest'
--and computer_name in ('dl1gsqlt03','dl1gsqlt04','dl1gsqlt05')

order by  SR.start_time desc