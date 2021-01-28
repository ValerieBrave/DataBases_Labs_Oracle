--#1
----------------------
create table SVV_t1 (x1 number(4) primary key, s1 varchar2(50));
insert into SVV_t1 (x1, s1) values (100, 'hundred ');
insert into SVV_t1 (x1, s1) values (101, 'hundred and one');
insert into SVV_t1 (x1, s1) values (14, 'fourteen ');
insert into SVV_t1 (x1, s1) values (102, 'hundred and two');
insert into SVV_t1 (x1, s1) values (1000, 'thousand');
----------------------
create table SVV_T (x number(4) , s varchar2(50), FOREIGN KEY(x) REFERENCES SVV_t1(x1));
--#2
insert into SVV_T (x, s) values (100, 'hello ');
insert into SVV_T (x, s) values (101, 'world ');
insert into SVV_T (x, s) values (102, '!!!');
commit;
--
select * from SVV_t;
select * from SVV_t1;

--#3
update SVV_t
set s='bye'
where x like 100 or x like 101;
commit;
--#4
select * from SVV_t where SVV_t.x > 100;
--
select sum(x) from SVV_t;
select count(*) from SVV_t;
--#5
delete from SVV_t
where x like 102;
commit;
--rollback;
--#6


--#7
select x, s1, s from SVV_t inner join SVV_t1 on SVV_t.x like SVV_t1.x1;
--левый джойн возвращает соответствующие сцепленные строки и оставшиеся строки из левого операнда
select x, s1, s from SVV_t1 left join SVV_t on SVV_t.x like SVV_t1.x1;


--#8
drop table SVV_t;
drop table SVV_t1;
