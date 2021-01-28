----create a role----#4
create role c##rl_svvcore;
--drop role c##rl_svvcore;

grant create session to c##rl_svvcore;
grant create table,
      create view,
      create procedure to c##rl_svvcore;
grant drop any table ,
      drop any view,
      drop any procedure to c##rl_svvcore;

----show role in dictionary----#5
select * from dba_roles;
select * from dba_sys_privs where grantee like 'C##RL_SVVCORE';

----create security profile----#6
create profile c##pf_svvcore limit
password_life_time 180
sessions_per_user 3 --количество параллельных сессий для пользователя
failed_login_attempts 7
password_lock_time 1 -- дней блокировки после 7 ошибок
password_reuse_time 10  --количество дней перед тем как пароль может быть использован заново
password_grace_time default -- дней предупреждения о смене пароля
connect_time 180  --максимальная длительность сессии
idle_time 30 --время бездействия, потом сессия завершается

----#7
select * from dba_profiles; --all profiles
select * from dba_profiles where profile like 'C##PF_SVVCORE';
select * from dba_profiles where profile like 'DEFAULT';

----create a user----#8 
create user c##svvcore identified by 12345
default tablespace ts_svv quota unlimited on ts_svv
temporary tablespace ts_svv_temp
profile c##pf_svvcore
account unlock
password expire

grant c##rl_svvcore to c##svvcore;

