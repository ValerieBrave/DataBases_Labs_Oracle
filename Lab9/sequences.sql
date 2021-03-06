select view_name from dba_views where view_name like '%TABLESPACE%' order by view_name;

--1   ���� ������ ����������
select * from dba_sys_privs where grantee like '%SVV%';
grant select any dictionary to svv_pdbadmin;

grant create table to svv_pdbadmin;
grant create sequence to svv_pdbadmin;
grant create cluster to svv_pdbadmin;
grant create synonym to svv_pdbadmin;
grant create public synonym to svv_pdbadmin;
grant create view to svv_pdbadmin;
grant create MATERIALIZED  view to svv_pdbadmin;

grant alter any table to svv_pdbadmin;
grant alter any sequence to svv_pdbadmin;
grant alter any cluster to svv_pdbadmin;
grant alter any synonym to svv_pdbadmin;
grant alter any MATERIALIZED view to svv_pdbadmin;

grant drop any table to svv_pdbadmin;
grant drop any sequence to svv_pdbadmin;
grant drop any cluster to svv_pdbadmin;
grant drop any synonym to svv_pdbadmin;
grant drop public synonym to svv_pdbadmin;
grant drop any view to svv_pdbadmin;
grant drop any MATERIALIZED view to svv_pdbadmin;

--2	�������� ������������������ S1 (SEQUENCE), �� ���������� ����������������: 
-- ��������� �������� 1000; ���������� 10;
-- ��� ������������ ��������; ��� ������������� ��������;
-- �� �����������; �������� �� ���������� � ������;
-- ���������� �������� �� �������������. 
-- �������� ��������� �������� ������������������. �������� ������� �������� ������������������.

create sequence S1
increment by 10
start with 1000
nomaxvalue nominvalue
nocycle nocache noorder;
--
select S1.currval from dual;
select S1.nextval from dual;

--3	�������� ������������������ S2 (SEQUENCE), �� ���������� ����������������: 
-- ��������� �������� 10; ���������� 10; ������������ �������� 100; 
-- �� �����������. �������� ��� �������� ������������������.
-- ����������� �������� ��������, ��������� �� ������������ ��������.

create sequence S2
increment by 10
start with 10
maxvalue 100
nocycle;
--drop sequence S2;
select S2.nextval from dual;  --�������� �� 10 ���

--4	�������� ������������������ S3 (SEQUENCE), �� ���������� ����������������: 
-- ��������� �������� 10; ���������� -10;
-- ����������� �������� -100; �� �����������; 
-- ������������� ���������� ��������. 
--�������� ��� �������� ������������������. 
--����������� �������� ��������, ������ ������������ ��������.

create sequence S3
increment by -10
start with 10
maxvalue 10
minvalue -100
nocycle order;

select S3.nextval from dual; --�������� ����� -100

--5	�������� ������������������ S4 (SEQUENCE), �� ���������� ����������������: 
-- ��������� �������� 1; ���������� 1; 
-- ����������� �������� 10; �����������; ������ ���� ������������!!
-- ���������� � ������ 5 ��������; ���������� �������� �� �������������. 
-- ����������������� ����������� ��������� �������� ������������������� S4.

create sequence S4
start with 1
increment by 1
maxvalue 10
cycle
cache 5
noorder;

select S4.nextval from dual;

--6 	�������� ������ ���� ������������������� � ������� ���� ������, ���������� ������� �������� ������������ XXX. 

select object_name, object_type from user_objects where object_type like 'SEQUENCE';
select * from user_sequences;

-- 7	�������� ������� T1, ������� ������� N1, N2, N3, N4, ���� NUMBER (20), 
-- ���������� � ������������� � �������� ���� KEEP. 
-- � ������� ��������� INSERT �������� 7 �����, �������� �������� ��� �������� ������ ������������� � ������� ������������������� S1, S2, S3, S4

create table T1 (
  n1 number(20),
  n2 number(20),
  n3 number(20),
  n4 number(20)
) storage(buffer_pool keep) tablespace ts_svv;
--drop table T1;
--���� �������� ��� ������������������ ���������� � ����������
drop sequence S1;
drop sequence S2;
drop sequence S3;
drop sequence S4;

begin
  for i in 1..7
    loop
    insert into T1 values(S1.nextval, S2.nextval, S3.nextval, S4.nextval);
    end loop;
end;
select * from T1;



-- 8	�������� ������� ABC, ������� hash-��� (������ 200) � ���������� 2 ����: X (NUMBER (10)), V (VARCHAR2(12)).
create cluster ABC 
(
  X number(10),
  V varchar2(12)
) hashkeys 200 tablespace ts_svv;
--drop cluster ABC;

-- 9	�������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), 
-- ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table A (
 xa number(10),
 va varchar2(12),
 za number(5)
)  cluster ABC(xa, va);
insert into A values(54321, 'hehehe', 123);
--drop table A;


-- 10	�������� ������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)),
-- ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table B (
 xb number(10),
 vb varchar2(12),
 zb char(5)
)  cluster ABC(xb, vb);
insert into B values(12345, 'hehehe', 'ha');
--drop table B;
-- 11 ����� ��, �� ��� ������

-- 12	������� ��������� ������� � ������� � �������������� ������� Oracle
select table_name, tablespace_name, cluster_name from dba_tables where tablespace_name like 'TS_SVV';

-- 13	�������� ������� ������� ��� ������� XXX.A � ����������������� ��� ����������.
create synonym syn_a for svv_pdbadmin.A;
select * from syn_a;
--drop synonym syn_a;
-- 14	�������� ��������� ������� ��� ������� XXX.B � ����������������� ��� ����������.
create public synonym syn_b for svv_pdbadmin.B;
select * from syn_b;
--drop public synonym syn_b;
-- 15	�������� ��� ������������ ������� A � B (� ��������� � ������� �������), 
-- ��������� �� �������, �������� ������������� V1, ���������� �� SELECT... FOR A inner join B. ����������������� ��� �����������������.

create table Alphabet (
  id number(2) primary key,
  letter char(1)
) tablespace ts_svv;
--drop table Alphabet;
create table Words (
  let_id number(2),
  word char(20),
  constraint fk_letters foreign key (let_id) references Alphabet(id)
) tablespace ts_svv;
--drop table Words;
insert into Alphabet values (1, 'A');
insert into Alphabet values (2, 'B');
insert into Alphabet values (3, 'C');
insert into Alphabet values (4, 'D');
insert into Alphabet values (5, 'E');
insert into Alphabet values (6, 'F');

insert into Words values (1, 'Apple');
insert into Words values (1, 'Africa');
insert into Words values (2, 'Biscuit');
insert into Words values (6, 'Fish');
insert into Words values (6, 'Forest');

create view view1 as select Alphabet.id, Alphabet.letter, Words.word 
from Alphabet inner join Words
on Alphabet.id like Words.let_id;

select * from view1;

--drop view view1;

-- 16	�� ������ ������ A � B �������� ����������������� ������������� MV, 
-- ������� ����� ������������� ���������� 2 ������. ����������������� ��� �����������������.

create materialized view MV tablespace ts_svv
build immediate
refresh complete start with (sysdate) next  (sysdate+1/1440)
as select count(*) from Alphabet inner join Words
on Alphabet.id like Words.let_id;

select * from MV;
insert into Words values (2, 'Bee');
commit;
--������� 2 �������
select * from MV;
select to_char(sysdate,'hh:mi') from dual;

--drop materialized view MV;












