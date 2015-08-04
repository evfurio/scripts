-- This query will return TestCases that Failed in the Automation Lab. 
-- Included in the result are the TestCase IDs, Description, Error Description and Trace Report

-- For GS Desktop  :	@stack_trace = '%GameStop/spec/UI%'
-- For GS Services :	@stack_trace = '%GameStop/spec/Services%'
-- For Mobile GS   :	@stack_trace = '%GameStopMobile%'
-- For WebInStore  :	@stack_trace = '%WebInStore%'

declare @user varchar(10), @browser varchar(20), @state varchar(20), @start_date varchar(8), @end_date varchar(8), @tc_id varchar(8), @stack_trace varchar(50)


set @user = 's_tfstest' 
set @state = 'fail'
set @start_date AS DATE 
set @end_date = AS DATE + ' 23:59:59.998' 
set @stack_trace = '%GameStop/spec/UI%'   -- This will filter the tests that failed only on GS Desktop.
--set @tc_id = 'TFS22711'
--set @browser = 'chrome' 

---------------------------------------------------------------------------------------------------------------------
select DSR.tc_id, DSR.tc_description, DF.description, DRP.report_line
from dbo.Dcon_Scenario_Runs DSR 
	inner join dbo.Dcon_Run_Instances DRI on DSR.dcon_run_instance_id = DRI.id
	inner join dbo.Dcon_Browsers DB on DSR.dcon_browser_id = DB.id
	inner join dbo.Dcon_Run_States DS on DSR.dcon_run_state_id = DS.id 
	inner join dbo.Dcon_Failure_Details DF on DSR.id = DF.dcon_scenario_run_id 
	inner join dbo.Dcon_Special_Reports DRP on DSR.id = DRP.dcon_scenario_run_id 
where 
	DRI.user_name = @user    
	and DS.description = @state 
	and DSR.start_time BETWEEN @start_date + ' 20:00:00.000' AND @end_date + ' 23:59:59.997' 
	and DRI.computer_name in ('DL1GSQLT03','DL1GSQLT04','DL1GSQLT05') 
	and DF.stack_trace like @stack_trace
	and DSR.tc_id is not null
order by
	DSR.tc_id 