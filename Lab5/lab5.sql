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

----сдюкъел рюакхжс
drop table ts_tab;
----опнбепнвйю яецлемрнб
select owner, segment_name, segment_type, tablespace_name from dba_segments
where tablespace_name like 'SVV_QDATA';
---опнбепнвйю йнпгхмш
select object_name, original_name, type, operation, ts_name from user_recyclebin;
--бняярюмнбкемхе рюакхжш
flashback table ts_tab to before drop;
select * from ts_tab;
--гюонкмъел 10000 ярпнйюлх кепю ямювюкю сдюкх х янгдюи рюакхжс ОНФЮКСИЯРЮ
drop table ts_tab;

begin
for k in 1..10000
loop
insert into ts_tab(n, l) values(k, 'a');
end loop;
commit;
end;
--опстш
select count(*) from ts_tab;
--ялнрпхл яецлемрш
select segment_name, segment_type, tablespace_name, bytes, blocks, extents
from user_segments
where tablespace_name like 'SVV_QDATA';
--сдюкъел рюакхвмне опнярпюмярбн
drop tablespace svv_qdata INCLUDING CONTENTS;

--бяе цпсоош фспмюкнб онбрнпю
select * from v$logfile;
--рейсыюъ цпсоою
select group#, status from v$log where status like 'CURRENT';
--бяе тюикш бяеу фспмюкнб
select * from v$log;
select * from v$archived_log;

--оепейкчвемхе фспмюкнб онбрнпю - ОНКМШИ ЙПСЦ
alter system switch logfile;
select group#, status from v$log;

--днаюбкъел мнбсч цпсоос
alter database add logfile group 4 'D:\LERA\DB3course\Lab5\REDO04.LOG'
size 50m blocksize 512;
--опстш
select group#, status from v$log;
--днаюбкъел тюикхйх б цпсоос
alter database add logfile member 'D:\LERA\DB3course\Lab5\REDO041.LOG' to group 4;
alter database add logfile member 'D:\LERA\DB3course\Lab5\REDO042.LOG' to group 4;
alter database add logfile member 'D:\LERA\DB3course\Lab5\REDO043.LOG' to group 4;
--ОПНБЕПНВЙЮ
select group#, status, members, first_change# from v$log;
--НОЪРЭ ОЕПЕЙКЧВЕМХЕ ФСПМЮКНБ
alter system switch logfile;
select group#, status from v$log;
--сдюкъел цпсоос фспмюкнб кепю нм ме днкфем ашрэ рейсыхл
alter database drop logfile member 'D:\LERA\DB3course\Lab5\REDO041.LOG';
alter database drop logfile member 'D:\LERA\DB3course\Lab5\REDO042.LOG';
alter database drop logfile member 'D:\LERA\DB3course\Lab5\REDO043.LOG';
alter database drop logfile group 4;
--ОПНБЕПНВЙЮ
select group#, status, members, first_change# from v$log;

--опнбепнвйю юпухбхпнбюмхъ
select name, log_mode from v$database;
--бйкчвюел юпухбхпнбюмхе кепю юййспюрмн акхм ВЕПЕГ sql plus
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;

--ялнрпхл юпухбхпнбюммше фспмюкш кепю ямювюкю оепейкчвх рейсыхи фспмюк 
-- янгдю╗ряъ юпухбмши тюик опх оепейкчвемхх
alter system switch logfile;
select group#, status from v$log;
select * from v$archived_log;
archive log list; --sql plus - ЛЕЯРН Я ЛНХЛХ ЮПУХБВХЙЮЛХ

--нрйкчвюел юпухбхпнбюмхе кепю б SQL PLUS 
shutdown immediate;
startup mount;
alter database noarchivelog;
alter database open;
--ОПСТШ
select name, log_mode from v$database;

--сопюбкъчыхе тюикхйх ялнрпхл
select name from v$controlfile;
--яндепфхлне
select type, record_size, records_total from v$controlfile_record_section;
--пюяонкнфемхе
select * from v$parameter where name like 'spfile';
--янгдюел отюик кепю вепег SQL PLUS /as sysdba
create pfile = 'p1.ora' from spfile;
--ТЮИКШ ДХЮЦМНЯРХЙХ 
select * from v$diag_info;
--цде оюойх тюикнб яннаыемхи???
--C:\app\LeraOra\diag\rdbms\orcl\orcl\alert
