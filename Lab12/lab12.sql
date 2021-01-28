--1. Добавьте в таблицу TEACHERS два столбца BIRTHDAY и SALARY, заполните их значениями.
alter table teacher
add BIRTHDAY date;
alter table teacher
add SALARY number;
---
update teacher 
set birthday = '6-12-1965'
where teacher like '%КЛСНВ%';
update teacher 
set birthday = '25-11-1970'
where teacher like '%ЛЩНК%';
update teacher 
set birthday = '15-10-1951'
where teacher like '%ДДК%';
update teacher 
set birthday = '11-10-1950'
where teacher like '%УРБ%';
update teacher 
set birthday = '25-12-1975'
where teacher like '%РМНК%';
update teacher 
set birthday = '7-1-1980'
where teacher like '%ГРН%';
update teacher 
set birthday = '15-8-1971'
where teacher like '%ЖЛК%';

select * from teacher;
delete teacher where teacher like '%?%';
--2. Получите список преподавателей в виде Фамилия И.О.
declare
  cursor fio_cur is select teacher_name from teacher;
  fiostr teacher.teacher_name%type;
  t integer :=0;
  del integer := 0;
  i teacher.teacher_name%type;
  o teacher.teacher_name%type;
begin
  select count(*) into t from teacher;
  for fio in fio_cur
  loop
    del := instr(fio.teacher_name, ' ');
    fiostr:= substr(fio.teacher_name, del, length(fio.teacher_name)-del+1);
    i:= substr(fiostr, 1, 2);
    --
    fiostr := ltrim(fiostr);
    del := instr(fiostr, ' ');
    fiostr:= substr(fiostr, del, length(fiostr)-del+1);
    o := substr(fiostr, 1, 2);
    dbms_output.put_line('И.О : '|| i ||'. '|| o ||'.');
  end loop;
end;
--3. Получите список преподавателей, родившихся в понедельник.
  select * from teacher
  where TO_CHAR(birthday, 'DAY') like '%ПОНЕДЕЛЬНИК%';

--4. Создайте представление, в котором поместите список преподавателей, которые родились в следующем месяце.
create view next_month_celebrate 
as select * from teacher
where extract(month from birthday) like extract(month from sysdate)+1;
  
select * from next_month_celebrate;
--5. Создайте представление, в котором поместите количество преподавателей, которые родились в каждом месяце.

create view month_statistics as
select  extract(month from teacher.birthday) month, count(*) teachers from teacher where birthday is not null
group by extract(month from teacher.birthday)

select * from month_statistics;
select extract(year from teacher.birthday) from teacher;
--6. Создать курсор и вывести список преподавателей, у которых в следующем году юбилей.
declare
  type curtype is ref cursor;
  cur curtype;
  teacher_n teacher.teacher_name%type;
  teacher_b teacher.birthday%type;
  jubilee integer:=0;
begin
  open cur for select teacher_name, birthday
                from teacher
                where mod( extract(year from sysdate)+1-extract(year from teacher.birthday), 10) like 0;
  fetch cur into teacher_n, teacher_b;
  while (cur%found)
  loop
    jubilee :=extract(year from sysdate)+1-extract(year from teacher_b);
    dbms_output.put_line(teacher_n||' - '||jubilee);
    fetch cur into teacher_n, teacher_b;
  end loop;
end;

--7. Создать курсор и вывести среднюю заработную плату по кафедрам с округлением вниз до целых,
-- вывести средние итоговые значения для каждого факультета и для всех факультетов в целом.
update teacher 
set salary = 1056.5692
where teacher like '%КЛСНВ%';
update teacher 
set salary = 531.992
where teacher like '%ЛЩНК%';
update teacher 
set salary = 892.433
where teacher like '%ДДК%';
update teacher 
set salary = 997.3
where teacher like '%УРБ%';
update teacher 
set salary = 1101.666
where teacher like '%РМНК%';
update teacher 
set salary = 450.252425
where teacher like '%ГРН%';
update teacher 
set salary = 755.00005
where teacher like '%ЖЛК%';

declare
  cursor cur_sal is select trunc(salary, 0) from teacher where salary is not null;
  sal teacher.salary%type;
begin
  open cur_sal;
  fetch cur_sal into sal;
  while (cur_sal%found)
  loop
    dbms_output.put_line(sal);
    fetch cur_sal into sal;
  end loop;
  select avg(salary) into sal from teacher where salary is not null;
  dbms_output.put_line('avg = '||sal);
  dbms_output.put_line('ceil avg = '||ceil(sal));
  dbms_output.put_line('round avg = '||round(sal, 2));
  dbms_output.put_line('trunc avg = '||trunc(sal, 2));
  sal := floor(sal);
  dbms_output.put_line('floor avg = '||sal);
end;

--8. Создайте собственный тип PL/SQL-записи (record) и продемонстрируйте работу с ним.
-- Продемонстрируйте работу с вложенными записями. 
--Продемонстрируйте и объясните операцию присвоения. 
declare
  type word_record is record (
    word varchar2(20),
    len integer
  );
  type alphabet_record is record (
    id integer,
    letter char(1),
    word word_record
  );
  
  my_let alphabet_record;
  my_word word_record;
begin
  my_word.word := 'Apple';
  my_word.len := length('Apple');
  dbms_output.put_line('my word: '||my_word.word||', '||my_word.len);
  --
  my_let.id :=1;
  my_let.letter :='A';
  my_let.word := my_word;
  dbms_output.put_line('my letter: '||my_let.id||', '||my_let.letter||', '||my_let.word.word||', '||my_let.word.len);
end;










