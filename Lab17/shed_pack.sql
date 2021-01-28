CREATE OR REPLACE PACKAGE BODY shed_pack as
--------------------------------------------

  procedure s_manipulate
  as
  begin
    insert into copy_table select * from main_table where rownum <= 5 ;
    delete main_table where rownum <= 5;
    insert into journal_table(datetime, info, timeinfo)
    values (sysdate, 'GOOD', current_timestamp);
    commit;
    exception when others then 
    insert into journal_table(datetime, info, timeinfo) values (sysdate, 'ERROR', current_timestamp);
  end s_manipulate;
  
--------------------------------------------
  procedure s_start_job
  as
  begin
  DBMS_SCHEDULER.create_job (
    job_name        => 'TEST_MANIP',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN shed_pack.s_manipulate; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'freq=MINUTELY;INTERVAL=3',
    end_date        => NULL,
    enabled         => TRUE);
    commit;
    dbms_output.put_line('start job');
  exception when others then
    dbms_output.put_line(sqlerrm);
  end s_start_job;

--------------------------------------------

  function s_is_finished return boolean
  is
  temp nvarchar2(10) := 'false';
  begin
  SELECT 'true' INTO temp FROM DUAL WHERE EXISTS (SELECT * FROM all_scheduler_jobs where job_name = 'TEST_MANIP' AND RUN_COUNT>0);
      if temp = 'true' then
        return true;
      else
        return false;
      end if;
  EXCEPTION WHEN OTHERS
    THEN RETURN FALSE;
  end s_is_finished;

--------------------------------------------

  function s_is_running return boolean
  is
  temp nvarchar2(10) := 'false';
  begin
  SELECT 'true' INTO temp FROM DUAL WHERE EXISTS (SELECT * FROM all_scheduler_jobs where job_name = 'TEST_MANIP' AND ENABLED='TRUE');
      if temp = 'true' then
        return true;
      else
        return false;
      end if;
  EXCEPTION WHEN OTHERS
     THEN RETURN FALSE;
  end s_is_running;

-------------------------------------------

  procedure s_stop_job
  is
  begin
    DBMS_SCHEDULER.disable('TEST_MANIP');
    COMMIT;
  end s_stop_job;

-------------------------------------------

procedure s_delete_job
is
begin
DBMS_SCHEDULER.DROP_JOB (job_name => 'TEST_MANIP');
commit;
end s_delete_job;

-------------------------------------------
END shed_pack;




















