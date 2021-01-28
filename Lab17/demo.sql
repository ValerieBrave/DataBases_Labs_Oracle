-------JOBS demo

exec jobs_pack.start_job;

declare
temp boolean;
temp2 boolean;
begin
  temp := jobs_pack.is_finished;
  temp2 := jobs_pack.is_running;
  if temp = true then 
    dbms_output.put_line('done');
  else
    dbms_output.put_line('in process');
  end if;
  if temp2 = true then 
    dbms_output.put_line('not broken');
  else
    dbms_output.put_line('broken');
  end if;
end; 

begin jobs_pack.stop_job; end;
--begin jobs_pack.set_new_date('06.01.2021'); end;
begin jobs_pack.delete_job; end;

select * from user_jobs;
select * from main_table;
select * from copy_table;
select * from journal_table;
-------------------------------------------------------------
grant create job to c##svvcore;
grant SCHEDULER_ADMIN to c##svvcore;
GRANT MANAGE SCHEDULER TO c##svvcore;

exec shed_pack.s_start_job;

SELECT * FROM dba_scheduler_jobs where job_name = 'TEST_MANIP';

declare
temp boolean;
temp2 boolean;
begin
  temp := shed_pack.s_is_finished;
  temp2 := shed_pack.s_is_running;
  if temp = true then 
    dbms_output.put_line('done');
  else
    dbms_output.put_line('in process');
  end if;
  if temp2 = true then 
    dbms_output.put_line('not broken');
  else
    dbms_output.put_line('broken');
  end if;
end; 


select * from main_table;
select * from copy_table;
select * from journal_table;

begin shed_pack.s_stop_job; end;

begin shed_pack.s_delete_job; end;





