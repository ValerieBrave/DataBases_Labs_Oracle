--#1 all pdbs of the instance
select name, open_mode from v$pdbs;

--#2 all instances
SELECT * FROM V$INSTANCE;

--#3 all components
select
   name ,
   detected_usages ,
   first_usage_date ,
   currently_used 
from
   dba_feature_usage_statistics
   where
   first_usage_date is not null;
   
   select name from v$database;
   select global_name from global_name;
   -- connect system/manager@localhost:1521/svv_pdb.docker.internal as sysdba;
