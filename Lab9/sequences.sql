select view_name from dba_views where view_name like '%TABLESPACE%' order by view_name;

--1   дать нужные привилегии
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

--2	Создайте последовательность S1 (SEQUENCE), со следующими характеристиками: 
-- начальное значение 1000; приращение 10;
-- нет минимального значения; нет максимального значения;
-- не циклическая; значения не кэшируются в памяти;
-- хронология значений не гарантируется. 
-- Получите несколько значений последовательности. Получите текущее значение последовательности.

create sequence S1
increment by 10
start with 1000
nomaxvalue nominvalue
nocycle nocache noorder;
--
select S1.currval from dual;
select S1.nextval from dual;

--3	Создайте последовательность S2 (SEQUENCE), со следующими характеристиками: 
-- начальное значение 10; приращение 10; максимальное значение 100; 
-- не циклическую. Получите все значения последовательности.
-- Попытайтесь получить значение, выходящее за максимальное значение.

create sequence S2
increment by 10
start with 10
maxvalue 100
nocycle;
--drop sequence S2;
select S2.nextval from dual;  --ошибочка на 10 раз

--4	Создайте последовательность S3 (SEQUENCE), со следующими характеристиками: 
-- начальное значение 10; приращение -10;
-- минимальное значение -100; не циклическую; 
-- гарантирующую хронологию значений. 
--Получите все значения последовательности. 
--Попытайтесь получить значение, меньше минимального значения.

create sequence S3
increment by -10
start with 10
maxvalue 10
minvalue -100
nocycle order;

select S3.nextval from dual; --ошибочка после -100

--5	Создайте последовательность S4 (SEQUENCE), со следующими характеристиками: 
-- начальное значение 1; приращение 1; 
-- минимальное значение 10; циклическая; должно быть максимальное!!
-- кэшируется в памяти 5 значений; хронология значений не гарантируется. 
-- Продемонстрируйте цикличность генерации значений последовательностью S4.

create sequence S4
start with 1
increment by 1
maxvalue 10
cycle
cache 5
noorder;

select S4.nextval from dual;

--6 	Получите список всех последовательностей в словаре базы данных, владельцем которых является пользователь XXX. 

select object_name, object_type from user_objects where object_type like 'SEQUENCE';
select * from user_sequences;

-- 7	Создайте таблицу T1, имеющую столбцы N1, N2, N3, N4, типа NUMBER (20), 
-- кэшируемую и расположенную в буферном пуле KEEP. 
-- С помощью оператора INSERT добавьте 7 строк, вводимое значение для столбцов должно формироваться с помощью последовательностей S1, S2, S3, S4

create table T1 (
  n1 number(20),
  n2 number(20),
  n3 number(20),
  n4 number(20)
) storage(buffer_pool keep) tablespace ts_svv;
--drop table T1;
--ЛЕРА ПОУДАЛЯЙ ВСЕ ПОСЛЕДОВАТЕЛЬНОСТИ ПОЖАЛУЙСТА и пересоздай
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



-- 8	Создайте кластер ABC, имеющий hash-тип (размер 200) и содержащий 2 поля: X (NUMBER (10)), V (VARCHAR2(12)).
create cluster ABC 
(
  X number(10),
  V varchar2(12)
) hashkeys 200 tablespace ts_svv;
--drop cluster ABC;

-- 9	Создайте таблицу A, имеющую столбцы XA (NUMBER (10)) и VA (VARCHAR2(12)), 
-- принадлежащие кластеру ABC, а также еще один произвольный столбец.
create table A (
 xa number(10),
 va varchar2(12),
 za number(5)
)  cluster ABC(xa, va);
insert into A values(54321, 'hehehe', 123);
--drop table A;


-- 10	Создайте таблицу B, имеющую столбцы XB (NUMBER (10)) и VB (VARCHAR2(12)),
-- принадлежащие кластеру ABC, а также еще один произвольный столбец.
create table B (
 xb number(10),
 vb varchar2(12),
 zb char(5)
)  cluster ABC(xb, vb);
insert into B values(12345, 'hehehe', 'ha');
--drop table B;
-- 11 такой же, че его делать

-- 12	Найдите созданные таблицы и кластер в представлениях словаря Oracle
select table_name, tablespace_name, cluster_name from dba_tables where tablespace_name like 'TS_SVV';

-- 13	Создайте частный синоним для таблицы XXX.A и продемонстрируйте его применение.
create synonym syn_a for svv_pdbadmin.A;
select * from syn_a;
--drop synonym syn_a;
-- 14	Создайте публичный синоним для таблицы XXX.B и продемонстрируйте его применение.
create public synonym syn_b for svv_pdbadmin.B;
select * from syn_b;
--drop public synonym syn_b;
-- 15	Создайте две произвольные таблицы A и B (с первичным и внешним ключами), 
-- заполните их данными, создайте представление V1, основанное на SELECT... FOR A inner join B. Продемонстрируйте его работоспособность.

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

-- 16	На основе таблиц A и B создайте материализованное представление MV, 
-- которое имеет периодичность обновления 2 минуты. Продемонстрируйте его работоспособность.

create materialized view MV tablespace ts_svv
build immediate
refresh complete start with (sysdate) next  (sysdate+1/1440)
as select count(*) from Alphabet inner join Words
on Alphabet.id like Words.let_id;

select * from MV;
insert into Words values (2, 'Bee');
commit;
--падажжи 2 минутки
select * from MV;
select to_char(sysdate,'hh:mi') from dual;

--drop materialized view MV;












