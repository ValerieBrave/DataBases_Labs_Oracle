select file_name, tablespace_name from dba_data_files;
select file_name, tablespace_name from dba_temp_files;

--use c##svvcore
create tablespace svv_qdata
datafile 'D:\LERA\DB3course\Lab5\svv_qdata.dbf'
size 10 m
offline;
--drop tablespace svv_qdata INCLUDING CONTENTS;
alter tablespace svv_qdata online;

alter user C##SVVCORE quota 2 m on svv_qdata;
select username from all_users;

create table ts_tab(n number(5) primary key, l varchar2(2)) tablespace svv_qdata;
insert into ts_tab(n,l) values(1, 'A');
insert into ts_tab(n,l) values(2, 'B');
insert into ts_tab(n,l) values(3, 'C');
commit;

select tablespace_name,
        block_size,
        initial_extent,
        initial_extent/block_size,
        extent_management,
        bigfile
        from dba_tablespaces
        where tablespace_name like 'SVV_QDATA';
        
select owner, segment_name, segment_type, tablespace_name from dba_segments
where tablespace_name like 'SVV_QDATA';

----������� �������
drop table ts_tab;
----���������� ���������
select owner, segment_name, segment_type, tablespace_name from dba_segments
where tablespace_name like 'SVV_QDATA';
---���������� �������
select object_name, original_name, type, operation, ts_name from user_recyclebin;
--�������������� �������
flashback table ts_tab to before drop;
select * from ts_tab;
--��������� 10000 �������� ���� ������� ����� � ������ ������� ����������
drop table ts_tab;

begin
for k in 1..10000
loop
insert into ts_tab(n, l) values(k, 'a');
end loop;
commit;
end;
--�����
select count(*) from ts_tab;
--������� ��������
select segment_name, segment_type, tablespace_name, bytes, blocks, extents
from user_segments
where tablespace_name like 'SVV_QDATA';
--������� ��������� ������������
drop tablespace svv_qdata INCLUDING CONTENTS;

--��� ������ �������� �������
select * from v$logfile;
--������� ������
select group#, status from v$log where status like 'CURRENT';
--��� ����� ���� ��������
select * from v$log;
select * from v$archived_log;

--������������ �������� ������� - ������ ����
alter system switch logfile;
select group#, status from v$log;

--��������� ����� ������
alter database add logfile group 4 'D:\LERA\DB3course\Lab5\REDO04.LOG'
size 50m blocksize 512;
--�����
select group#, status from v$log;
--��������� ������� � ������
alter database add logfile member 'D:\LERA\DB3course\Lab5\REDO041.LOG' to group 4;
alter database add logfile member 'D:\LERA\DB3course\Lab5\REDO042.LOG' to group 4;
alter database add logfile member 'D:\LERA\DB3course\Lab5\REDO043.LOG' to group 4;
--����������
select group#, status, members, first_change# from v$log;
--����� ������������ ��������
alter system switch logfile;
select group#, status from v$log;
--������� ������ �������� ���� �� �� ������ ���� �������
alter database drop logfile member 'D:\LERA\DB3course\Lab5\REDO041.LOG';
alter database drop logfile member 'D:\LERA\DB3course\Lab5\REDO042.LOG';
alter database drop logfile member 'D:\LERA\DB3course\Lab5\REDO043.LOG';
alter database drop logfile group 4;
--����������
select group#, status, members, first_change# from v$log;

--���������� �������������
select name, log_mode from v$database;
--�������� ������������� ���� ��������� ���� ����� sql plus
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;

--������� �������������� ������� ���� ������� ��������� ������� ������ 
-- ��������� �������� ���� ��� ������������
alter system switch logfile;
select group#, status from v$log;
select * from v$archived_log;
archive log list; --sql plus - ����� � ����� �����������

--��������� ������������� ���� � SQL PLUS 
shutdown immediate;
startup mount;
alter database noarchivelog;
alter database open;
--�����
select name, log_mode from v$database;

--����������� ������� �������
select name from v$controlfile;
--����������
select type, record_size, records_total from v$controlfile_record_section;
--������������
select * from v$parameter where name like 'spfile';
--������� ����� ���� ����� SQL PLUS /as sysdba
create pfile = 'p1.ora' from spfile;
--����� ����������� 
select * from v$diag_info;
--��� ����� ������ ���������???
--C:\app\LeraOra\diag\rdbms\orcl\orcl\alert
