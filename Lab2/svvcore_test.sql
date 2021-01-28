create table uni_group(
  id number(2) primary key,
  course number(2),
  spec varchar2(10),
  faculty varchar(20),
  students number(2)
);
insert into uni_group(id, course, spec, faculty, students) values(1, 3, 'ISIT', 'FIT', 25);
insert into uni_group(id, course, spec, faculty, students) values(4, 3, 'POIT', 'FIT', 26);
insert into uni_group(id, course, spec, faculty, students) values(5, 3, 'POIT', 'FIT', 29);
insert into uni_group(id, course, spec, faculty, students) values(7, 3, 'POIBMS', 'FIT', 20);
commit;
drop table uni_group;
-----
create view groups_view as
select id, course, faculty from uni_group;
drop view groups_view;
-----

select * from groups_view;

----#11--create table in ts_svv as c##svvcore
create table ts_tab(n number(2), l varchar2(2)) tablespace ts_svv;
insert into ts_tab(n,l) values(1, 'A');
insert into ts_tab(n,l) values(2, 'B');
insert into ts_tab(n,l) values(3, 'C');
commit;

drop table ts_tab;
