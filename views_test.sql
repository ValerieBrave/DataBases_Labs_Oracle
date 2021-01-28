--1
select * from dba_views;
--2
select * from dba_tablespaces where contents like 'TEMPORARY';
--3
select * from dba_sys_privs where grantee like 'C##ROLE1';
--4
select * from user_objects;
--5
select * from dba_extents;
--6
select * from v$pdbs;
--7
select * from v$log;
--8
show parameter;
--9
select * from v_$pwfile_users;
--10
select table_name, buffer_pool from user_tables;
--11
select * from v$session;
