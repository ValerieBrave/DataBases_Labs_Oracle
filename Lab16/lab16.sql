grant create tablespace to c##svvcore;
create tablespace data00
        datafile 'D:\LERA\DB3course\Lab16\data00.dbf'
        size 1m autoextend on;
      
create tablespace data01
        datafile 'D:\LERA\DB3course\Lab16\data01.dbf'
        size 1m autoextend on;
        
create tablespace data02
        datafile 'D:\LERA\DB3course\Lab16\data02.dbf'
        size 1m autoextend on;

create tablespace data03
        datafile 'D:\LERA\DB3course\Lab16\data03.dbf'
        size 1m autoextend on;
        
create tablespace data04
        datafile 'D:\LERA\DB3course\Lab16\data04.dbf'
        size 1m autoextend on;
        
        
--1.	Создайте таблицу T_RANGE c диапазонным секционированием. Используйте ключ секционирования типа NUMBER. 
create table t_range
(
  t_key number,
  t_value nvarchar2(20)
)
partition by range(t_key)
(
  partition tkey_up_to_5 values less than (5) tablespace data00,
  partition tkey_up_to_10 values less than (10) tablespace data01,
  partition tkey_up_to_15 values less than (15) tablespace data02,
  partition tkey_up_to_20 values less than (20) tablespace data03,
  partition tkey_max values less than (30) tablespace data04
);

--2.	Создайте таблицу T_INTERVAL c интервальным секционированием. Используйте ключ секционирования типа DATE.
create table t_interval 
(
  x1 NUMBER, 
  x2 DATE
)
partition by range(x2)
interval(NUMTOYMINTERVAL(1, 'MONTH')) store in (data00)
(
  PARTITION p0 VALUES LESS THAN (TO_DATE('1-1-2006', 'DD-MM-YYYY')),
  PARTITION p1 VALUES LESS THAN (TO_DATE('1-1-2007', 'DD-MM-YYYY')),
  PARTITION p2 VALUES LESS THAN (TO_DATE('1-1-2008', 'DD-MM-YYYY')),
  PARTITION p3 VALUES LESS THAN (TO_DATE('1-1-2009', 'DD-MM-YYYY'))
);

--3.	Создайте таблицу T_HASH c хэш-секционированием. Используйте ключ секционирования типа VARCHAR2.
create table t_hash 
(
  x1 NUMBER, 
  x2 NVARCHAR2(10)
)
partition by hash (x2)
partitions 4
store in (data00, data01, data02, data03);

--4.	Создайте таблицу T_LIST со списочным секционированием. Используйте ключ секционирования типа CHAR.
create table t_list (x1 NUMBER, x2 CHAR)
partition by list (x2)
(
  partition t_list1 values('A', 'F'),
  partition t_list2 values('G', 'M'),
  partition t_list_others values(default)
);

--5.	Введите с помощью операторов INSERT данные в таблицы T_RANGE, T_INTERVAL, T_HASH, T_LIST. 
--Данные должны быть такими, чтобы они разместились по всем секциям. Продемонстрируйте это с помощью SELECT запроса. 
insert into T_RANGE(t_key, t_value) values (4, 'four');
insert into T_RANGE(t_key, t_value) values (9, 'nine');
insert into T_RANGE(t_key, t_value) values (14, 'fourteen');
insert into T_RANGE(t_key, t_value) values (19, 'nineteen');
insert into T_RANGE(t_key, t_value) values (24, 'twenty four');

select * from T_RANGE partition(tkey_up_to_5);
select * from T_RANGE partition(tkey_up_to_10);
select * from T_RANGE partition(tkey_up_to_15);
select * from T_RANGE partition(tkey_up_to_20);
select * from T_RANGE partition(tkey_max);

select * from user_TAB_PARTITIONS where table_name = 'T_RANGE';
-----
insert into T_INTERVAL(x1, x2) values (1, TO_DATE('1-1-2005', 'DD-MM-YYYY'));
insert into T_INTERVAL(x1, x2) values (1, TO_DATE('1-1-2006', 'DD-MM-YYYY'));
insert into T_INTERVAL(x1, x2) values (1, TO_DATE('1-1-2007', 'DD-MM-YYYY'));
insert into T_INTERVAL(x1, x2) values (1, TO_DATE('1-9-2008', 'DD-MM-YYYY'));

select * from T_INTERVAL partition (p0);
select * from T_INTERVAL partition (p1);
select * from T_INTERVAL partition (p2);
select * from T_INTERVAL partition (p3);

insert into T_INTERVAL(x1, x2) values (1, TO_DATE('1-9-2009', 'DD-MM-YYYY'));

select * from user_TAB_PARTITIONS where table_name = 'T_INTERVAL';
-------
insert into T_HASH(x1, x2) values(1, 'test1');
insert into T_HASH(x1, x2) values(2, 'test2');
insert into T_HASH(x1, x2) values(3, 'test3');
insert into T_HASH(x1, x2) values(4, 'test4');

select * from user_TAB_PARTITIONS where table_name='T_HASH';

select * from T_HASH partition (SYS_P1475);
select * from T_HASH partition (SYS_P1417);
select * from T_HASH partition (SYS_P1418);
select * from T_HASH partition (SYS_P1419);

----------
insert into T_LIST(x1, x2) values(1, 'A');
insert into T_LIST(x1, x2) values(1, 'G');
insert into T_LIST(x1, x2) values(1, 'Y');

select * from T_LIST partition(t_list1);
select * from T_LIST partition(t_list2);
select * from T_LIST partition(t_list_others);

select * from user_TAB_PARTITIONS where table_name='T_LIST';

--6.	Продемонстрируйте процесс перемещения строк между 
--секциями, при изменении (оператор UPDATE) ключа секционирования.

select * from T_RANGE partition(tkey_up_to_5);
select * from T_RANGE partition(tkey_up_to_10);

alter table T_RANGE enable row movement;
update t_range set t_key = 8 where t_value = 'four';

--7.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE MERGE.
select * from user_TAB_PARTITIONS where table_name='T_LIST';

ALTER TABLE T_LIST MERGE PARTITIONS 
t_list1, t_list2 into partition t_list12; 

--8.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE SPLIT.
select * from user_TAB_PARTITIONS where table_name='T_LIST';

alter table t_list split partition t_list12 values ('A','G') into
(partition t_list1 ,
partition t_list2 );

--9.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE EXCHANGE.

create table MY_T_RANGE 
(
  table_key NUMBER,
  table_value NVARCHAR2(20)
);
drop table my_t_range;
alter table t_range exchange partition tkey_up_to_15 with table my_t_range without validation;

select * from user_TAB_PARTITIONS where table_name='MY_T_RANGE';
select * from user_TAB_PARTITIONS where table_name='T_RANGE';

drop table t_range;
drop table t_interval;
drop table t_hash;
drop table t_list;







