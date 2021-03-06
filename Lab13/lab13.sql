--1. ������������ ��������� ��������� 
--GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), 
--���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.

declare
  procedure get_teachers (pcode teacher.pulpit%type)
  is
  teacher_info teacher%rowtype;
  cursor teach_cur is select * from teacher where pulpit like pcode;
  begin
    open teach_cur;
    fetch teach_cur into teacher_info;
    while (teach_cur%found)
    loop
      dbms_output.put_line('teacher: '||teacher_info.teacher_name||', pulpit: '||teacher_info.pulpit);
      fetch teach_cur into teacher_info;
    end loop;
  end get_teachers;
begin
  get_teachers('%����%');
end;


--2. ������������ ��������� ������� 
--GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--RETURN NUMBER
--������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ������� �������� ����� � ���������. 
--������������ ��������� ���� � ����������������� ���������� ���������.

declare
  n integer :=0;
  function get_num_teachers(pcode teacher.pulpit%type)
  return number
  is
  num integer :=0;
  begin
    select count(*) into num from teacher where pulpit like pcode;
    return num;
  end get_num_teachers;

begin
  n:=get_num_teachers('%��%');
  dbms_output.put_line('teachers of pulpit = '||n);
end;

--3. ������������ ���������:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����),
-- ���������� �� ����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--��������� ������ �������� ������ ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� � ���������. 
--������������ ��������� ���� � ����������������� ���������� ���������.

declare
  procedure get_teachers(fac pulpit.faculty%type)
  is
    teacher_name teacher.teacher_name%type;
    pulpit teacher.pulpit%type;
    facu faculty.faculty%type;
    cursor fact_teachers is select teacher_name, teacher.pulpit, pulpit.faculty
                            from teacher inner join pulpit
                            on teacher.pulpit like pulpit.pulpit 
                            where pulpit.faculty like fac ;
  begin
    open fact_teachers;
    fetch fact_teachers into teacher_name, pulpit, facu;
    while(fact_teachers%found)
    loop
      dbms_output.put_line(teacher_name||', '||pulpit||', '||facu);
      fetch fact_teachers into teacher_name, pulpit, facu;
    end loop;
  end get_teachers;
begin
  get_teachers('%���%');
end;

declare
  procedure get_subjects(pcode subject.pulpit%type)
  is
    sub subject.subject%type;
    cursor pulp_subs is select subject
                            from subject  
                            where subject.pulpit like pcode ;
  begin
    open pulp_subs;
    fetch pulp_subs into sub;
    while(pulp_subs%found)
    loop
      dbms_output.put_line(sub);
      fetch pulp_subs into sub;
    end loop;
  end get_subjects;
begin
  get_subjects('%����%');
end;



--4. ������������ ��������� ������� 
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--RETURN NUMBER
--������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ����������, �������� ����� � ���������. 
--������������ ��������� ���� � ����������������� ���������� ���������.
--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER ������� ������ �������� ���������� ��������� �� ������� SUBJECT, 
--������������ �� ��������, �������� ����� ������� ���������. ������������ ��������� ���� � ����������������� ���������� ���������. 
declare
  n integer :=0;
  function get_num_teachers(fcode faculty.faculty%type)
  return number
  is
  num integer :=0;
  begin
    select count(*) into num from teacher inner join pulpit
                            on teacher.pulpit like pulpit.pulpit 
                            where pulpit.faculty like fcode ;
    return num;
  end get_num_teachers;

begin
  n:=get_num_teachers('%���%');
  dbms_output.put_line('teachers of faculty = '||n);
end;



declare
  n integer :=0;
  function get_num_subjects(pcode teacher.pulpit%type)
  return number
  is
  num integer :=0;
  begin
    select count(*) into num from subject where pulpit like pcode ;
    return num;
  end get_num_subjects;

begin
  n:=get_num_subjects('%����%');
  dbms_output.put_line('subjects on pulpit = '||n);
end;


--5. ������������ ����� TEACHERS, ���������� ��������� � �������:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER 
--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
grant create any procedure to c##svvcore;

create package teachers_pack as
procedure GET_TEACHERS (fac pulpit.faculty%type);
procedure GET_SUBJECTS (pcode subject.pulpit%type);
function GET_NUM_TEACHERS (fcode faculty.faculty%type) RETURN NUMBER;
function GET_NUM_SUBJECTS (pcode teacher.pulpit%type) RETURN NUMBER;
end teachers_pack;



create or replace package body teachers_pack as
--------------------------
procedure get_teachers(fac pulpit.faculty%type)
  is
    teacher_name teacher.teacher_name%type;
    pulpit teacher.pulpit%type;
    facu faculty.faculty%type;
    cursor fact_teachers is select teacher_name, teacher.pulpit, pulpit.faculty
                            from teacher inner join pulpit
                            on teacher.pulpit like pulpit.pulpit 
                            where pulpit.faculty like fac ;
  begin
    open fact_teachers;
    fetch fact_teachers into teacher_name, pulpit, facu;
    while(fact_teachers%found)
    loop
      dbms_output.put_line(teacher_name||', '||pulpit||', '||facu);
      fetch fact_teachers into teacher_name, pulpit, facu;
    end loop;
  end get_teachers;
----------------------------
procedure get_subjects(pcode subject.pulpit%type)
  is
    sub subject.subject%type;
    cursor pulp_subs is select subject
                            from subject  
                            where subject.pulpit like pcode ;
  begin
    open pulp_subs;
    fetch pulp_subs into sub;
    while(pulp_subs%found)
    loop
      dbms_output.put_line(sub);
      fetch pulp_subs into sub;
    end loop;
  end get_subjects;
  ---------------------------
  function get_num_teachers(fcode faculty.faculty%type)
  return number
  is
  num integer :=0;
  begin
    select count(*) into num from teacher inner join pulpit
                            on teacher.pulpit like pulpit.pulpit 
                            where pulpit.faculty like fcode ;
    return num;
  end get_num_teachers;
----------------------------
function get_num_subjects(pcode teacher.pulpit%type)
  return number
  is
  num integer :=0;
  begin
    select count(*) into num from subject where pulpit like pcode ;
    return num;
  end get_num_subjects;
-------------------------------
end teachers_pack;

drop package teachers_pack;
--6. ������������ ��������� ���� � ����������������� ���������� �������� � ������� ������ TEACHERS.
begin
dbms_output.put_line('teachers_pack.get_teachers:');
teachers_pack.get_teachers('%����%');
dbms_output.put_line('teachers_pack.get_subjects:');
teachers_pack.get_subjects('%����%');
dbms_output.put_line('teachers_pack.get_num_teachers:');
dbms_output.put_line(teachers_pack.get_num_teachers('%����%'));
dbms_output.put_line('teachers_pack.get_num_subjects:');
dbms_output.put_line(teachers_pack.get_num_subjects('%����%'));
end;

