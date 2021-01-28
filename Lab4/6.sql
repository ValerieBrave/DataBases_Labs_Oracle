create tablespace ts_svvpdb
datafile 'D:\LERA\DB3course\Lab4\ts_svvpdb.dbf'
size 7 m
autoextend on next 5 m
maxsize 20 m
extent management local;


--drop tablespace ts_svv;

create temporary tablespace ts_svvpdb_temp
tempfile 'D:\LERA\DB3course\Lab4\ts_svvpdb_temp.dbf'
size 5 m
autoextend on next 3 m
maxsize 30 m
extent management local;


create role rl_svvpdb;
--drop role c##rl_svvcore;
grant create session to rl_svvpdb;
grant connect to rl_svvpdb;
grant create table,
      create view,
      create procedure to rl_svvpdb;
grant drop any table ,
      drop any view,
      drop any procedure to rl_svvpdb;
      
drop role rl_svvpdb;
drop user u1_svv_pdb;
      
create profile pf_svvpdb limit
password_life_time 180
sessions_per_user 3 --количество параллельных сессий для пользователя
failed_login_attempts 7
password_lock_time 1 -- дней блокировки после 7 ошибок
password_reuse_time 10  --количество дней перед тем как пароль может быть использован заново
password_grace_time default -- дней предупреждения о смене пароля
connect_time 180  --максимальная длительность сессии
idle_time 30 

-- create a user!!
create user u1_svv_pdb identified by 12345
default tablespace ts_svvpdb quota unlimited on ts_svvpdb
temporary tablespace ts_svvpdb_temp
profile pf_svvpdb
account unlock
password expire

grant rl_svvpdb to u1_svv_pdb;
select * from dba_sys_privs where grantee like 'RL_SVVPDB';

--8
select username from ALL_USERS;
select tablespace_name from DBA_TABLESPACES;
select * from DBA_DATA_FILES;
select * from DBA_TEMP_FILES;
select * from DBA_ROLES;
select GRANTEE, PRIVILEGE from DBA_SYS_PRIVS;
select * from DBA_PROFILES;


