CREATE OR REPLACE PACKAGE BODY jobs_pack as
--------------------------------------------
  procedure manipulate
  as
  begin
    insert into copy_table select * from main_table where rownum <= 5 ;
    delete main_table where rownum <= 5;
    insert into journal_table(datetime, info, timeinfo)
    values (sysdate, 'GOOD', current_timestamp);
    commit;
    exception when others then 
    insert into journal_table(datetime, info, timeinfo) values (sysdate, 'ERROR', current_timestamp);
  end manipulate;
  
---------------------------------------------

  procedure start_job
  as
  begin
    dbms_job.ISUBMIT(job => 1,
                      what => 'begin jobs_pack.manipulate; end;',
                      next_date => sysdate,
                      interval =>'sysdate+3/24*60');
    commit;
    dbms_output.put_line('start job');
    exception when others then dbms_output.put_line(sqlerrm);
  end start_job;

---------------------------------------------

  function is_finished return boolean
    is
    temp nvarchar2(10) := 'false';
    BEGIN
      SELECT 'true' INTO temp FROM DUAL WHERE EXISTS (SELECT * FROM USER_JOBS WHERE JOB=1 AND LAST_DATE IS NOT NULL);
      if temp = 'true' then
        return true;
      else
        return false;
      end if;
    EXCEPTION WHEN OTHERS
      THEN RETURN FALSE;
  end is_finished;

----------------------------------------------

  function is_running return boolean
  is
  temp nvarchar2(10) := 'false';
  begin
    SELECT 'true' INTO temp FROM DUAL WHERE EXISTS (SELECT * FROM USER_JOBS WHERE JOB=1 AND USER_JOBS.BROKEN='N');
        if temp = 'true' then
          return true;
        else
          return false;
        end if;
    EXCEPTION WHEN OTHERS
      THEN RETURN FALSE;
  end is_running;

---------------------------------------------

  procedure stop_job
  as
  begin
    DBMS_JOB.BROKEN(1, TRUE);
    COMMIT;
  end stop_job;

----------------------------------------------

  procedure set_new_date(newDate date)
  as
  begin
    DBMS_JOB.CHANGE(  job => 1,
                        what => 'begin jobs_pack.manipulate; end;',
                        next_date => newDate,
                        interval =>'sysdate+3/24*60');
    DBMS_JOB.RUN(1);
    commit;
  end set_new_date;

---------------------------------------------

  procedure delete_job
  as
  begin
    dbms_job.remove(2);
    commit;
  end delete_job;

----------------------------------------------

END jobs_pack;