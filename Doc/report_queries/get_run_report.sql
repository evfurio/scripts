select rs.description as status,
count(rs.description) as total
from Dcon_Scenario_Runs sr
join Dcon_Run_Instances ri on sr.dcon_run_instance_id = ri.id
join Dcon_Run_States rs on sr.dcon_run_state_id = rs.id
where start_time > dateadd(hour, <%=@hours%>, getdate())
and rs.description in ('FAIL','PASS')
and ri.computer_name in (<%=@lab_machines%>)
group by rs.description