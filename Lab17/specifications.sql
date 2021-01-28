CREATE OR REPLACE PACKAGE jobs_pack as
  procedure manipulate;
  procedure start_job;
  function is_finished return boolean;
  function is_running return boolean;
  procedure stop_job;
  procedure set_new_date(newDate date);
  procedure delete_job;
END jobs_pack;

CREATE OR REPLACE PACKAGE shed_pack as
  procedure s_manipulate;
  procedure s_start_job;
  function s_is_finished return boolean;
  function s_is_running return boolean;
  procedure s_stop_job;
  procedure s_delete_job;
END shed_pack;