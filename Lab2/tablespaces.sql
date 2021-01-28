----tablespace for permanent data----#1
create tablespace ts_svv
datafile 'D:\LERA\DB3course\Lab2\ts_svv.dbf'
size 7 m
autoextend on next 5 m
maxsize 20 m
extent management local;

select tablespace_name, status, contents logging from sys.dba_tablespaces;

drop tablespace ts_svv;

----tablespace for temporary data----#2
create temporary tablespace ts_svv_temp
tempfile 'D:\LERA\DB3course\Lab2\ts_svv_temp.dbf'
size 5 m
autoextend on next 3 m
maxsize 30 m
extent management local;


drop tablespace ts_svv_temp;

----all tablespaces list----#3

select file_name, tablespace_name, status, maxbytes, user_bytes from dba_data_files
union
select file_name, tablespace_name, status, maxbytes, user_bytes from dba_temp_files;
