------execute as system
GRANT CREATE DATABASE LINK TO c##svvcore;
GRANT CREATE PUBLIC DATABASE LINK,
   DROP PUBLIC DATABASE LINK TO c##svvcore;
grant create session to c##svvcore;

-----execute as c##svvcore
CREATE DATABASE LINK svvpdblink 
   CONNECT TO svv_pdbadmin
   IDENTIFIED BY "svv_PDBadmin0"
   USING 'SVV_PDB';
select * from USER_DB_LINKS;
drop database link svvpdblink;


select * from uni_group@svvpdblink;
insert into uni_group@svvpdblink(id, course, spec, faculty, students)
values (10, 3, 'DEIVI', 'FIT', 23);
commit;
update uni_group@svvpdblink set faculty = 'FIT xxx' where id = 10;
delete uni_group@svvpdblink where id =10;

-----------------execute as c##svvcore
CREATE PUBLIC DATABASE LINK public_svvpdblink 
  CONNECT TO svv_pdbadmin
  IDENTIFIED BY "svv_PDBadmin0"
  USING 'SVV_PDB';
drop public database link public_svvpdblink;
------execute as c##svvcore + system + sys
select * from uni_group@public_svvpdblink;
