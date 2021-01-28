create tablespace svv_qdata
datafile 'D:\LERA\DB3course\Lab2\svv_qdata.dbf'
size 10 m
offline;

alter tablespace svv_qdata online;

alter user c##svvcore quota 2 m on svv_qdata;