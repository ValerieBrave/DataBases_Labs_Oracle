--1.	�������� ��������� ����, ��������������� ������� TEACHER � ����������� ������ ������� LOOP-�����. 
--��������� ������ ������ ���� �������� � ����������, ����������� � ����������� ����� %TYPE.
declare
  cursor cur_teacher is select teacher_name from teacher;
  t_name teacher.teacher_name%type;
begin
  open cur_teacher;
  dbms_output.put_line('rowcount = '|| cur_teacher%rowcount);
  loop
    fetch cur_teacher into t_name;
    exit when cur_teacher%notfound;
    dbms_output.put_line(t_name);
  end loop;
  dbms_output.put_line('rowcount = '|| cur_teacher%rowcount);
  close cur_teacher;
exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;


--2.	�������� ��, ��������������� ������� SUBJECT � ����������� ������ ������� � WHILE-�����. 
--��������� ������ ������ ���� �������� � ������ (RECORD), ����������� � ����������� ����� %ROWTYPE.
declare
  cursor cur_subject is select SUBJECT, SUBJECT_NAME, PULPIT from subject;
  r_sub subject%rowtype;
begin
  open cur_subject;
  dbms_output.put_line('rowcount = '|| cur_subject%rowcount);
  fetch cur_subject into r_sub;
  while cur_subject%found
  loop
    dbms_output.put_line(cur_subject%rowcount||' '|| r_sub.subject||' '||r_sub.subject_name||' '||r_sub.pulpit );
    fetch cur_subject into r_sub;
  end loop;
  dbms_output.put_line('rowcount = '|| cur_subject%rowcount);
  close cur_subject;
exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--3.	�������� ��, ��������������� ��� ������� (������� PULPIT) � ������� ���� �������������� (TEACHER)
-- ����������� ���������� (JOIN) PULPIT � TEACHER � � ����������� ������ ������� � FOR-�����.
declare
  cursor cur_tp is select pulpit_name, teacher_name from pulpit inner join teacher on pulpit.pulpit like teacher.pulpit;
  pulp pulpit.pulpit_name%type;
  teach teacher.teacher_name%type;
  nrows integer;
begin
  open cur_tp;
  select count(*) into nrows from pulpit inner join teacher on pulpit.pulpit like teacher.pulpit;
  --dbms_output.put_line(nrows);
  for i in 1..nrows
    loop
      fetch cur_tp into pulp, teach;
      dbms_output.put_line(pulp||'--- '||teach);
    end loop;
    close cur_tp;
exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--4.	�������� ��, ��������������� ��������� ������ ���������: ��� ��������� (������� AUDITORIUM)
-- � ������������ ������ 20, �� 21-30, �� 31-60, �� 61 �� 80, �� 81 � ����.
-- ��������� ������ � �����������.

declare
  cursor cur_au(mini auditorium.auditorium_capacity%type, maxi auditorium.auditorium_capacity%type) is
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity between mini and maxi;
  aum auditorium%rowtype;
begin
  for aum in cur_au(0, 20)
    loop
    dbms_output.put_line(aum.auditorium||'---'||aum.auditorium_capacity);
    end loop;
exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--5.	�������� A�. �������� ��������� ���������� � ������� ���������� ���� refcursor. 

declare
  type curtype is ref cursor return auditorium_type%rowtype;
  cur curtype;
  aud_row auditorium_type%rowtype;
  
begin
  open cur for select * from auditorium_type;
  fetch cur into aud_row;
  while(cur%found)
    loop
      dbms_output.put_line(aud_row.AUDITORIUM_TYPE||' '||aud_row.AUDITORIUM_TYPENAME);
      fetch cur into aud_row;
    end loop;
  close cur;
exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--6.	�������� A�. ����������������� ������� ��������� ���������?
declare
  cursor curs_aut is select auditorium_type,
                            cursor (
                                    select auditorium
                                    from auditorium aum
                                    where aut.auditorium_type like aum.auditorium_type
                                    )
                      from auditorium_type aut;
  curs_aum sys_refcursor;
  aut auditorium_type.auditorium_type%type;
  aum auditorium.auditorium%type;
  txt varchar2(1000);
begin
  open curs_aut;
  fetch curs_aut into aut, curs_aum;
  while(curs_aut%found)
  loop
    txt := rtrim(aut)||': ';
    loop
      fetch curs_aum into aum;
      exit when curs_aum%notfound;
      txt := txt || ',' || rtrim(aum);
    end loop;
    dbms_output.put_line(txt);
    fetch curs_aut into aut, curs_aum;
  end loop;
  close curs_aut;
exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--7.	�������� A�. ��������� ����������� ���� ��������� (������� AUDITORIUM) ������������ �� 40 �� 80 �� 10%.
-- ����������� ����� ������ � �����������, ���� FOR, ����������� UPDATE CURRENT OF. 
declare
  cursor cur_au(mini auditorium.auditorium_capacity%type, maxi auditorium.auditorium_capacity%type) is
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity between mini and maxi for update;
    aum auditorium.auditorium%type;
    cty auditorium.auditorium_capacity%type;
begin
  open cur_au(40, 80);
  fetch cur_au into aum, cty;
  while(cur_au%found)
  loop
    cty := cty * 0.9;
    update auditorium
    set auditorium_capacity = cty
    where current of cur_au;
    dbms_output.put_line(aum || ' ' || cty);
    fetch cur_au into aum, cty;
  end loop;
  close cur_au;
  rollback;
exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--8.	�������� A�. ������� ��� ��������� (������� AUDITORIUM) ������������ �� 0 �� 20.
-- ����������� ����� ������ � �����������, ���� WHILE, ����������� UPDATE CURRENT OF. 
declare
  cursor cur_au(mini auditorium.auditorium_capacity%type, maxi auditorium.auditorium_capacity%type) is
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity between mini and maxi for update;
    aum auditorium.auditorium%type;
    cty auditorium.auditorium_capacity%type;
begin
  open cur_au(0, 20);
  fetch cur_au into aum, cty;
  savepoint before_del;
  while(cur_au%found)
  loop
    delete auditorium
    where current of cur_au;
    dbms_output.put_line('delited '|| aum);
    fetch cur_au into aum, cty;
  end loop;
  close cur_au;
  -----
  open cur_au(0, 20);
  fetch cur_au into aum, cty;
  if cur_au%rowcount like 0 then
    rollback to before_del;
    dbms_output.put_line('rollback!');
    close cur_au;
    open cur_au(0, 20);
    fetch cur_au into aum, cty;
    while(cur_au%found)
      loop
        dbms_output.put_line('restored: '|| aum ||'---'||cty);
        fetch cur_au into aum, cty;
      end loop;
      close cur_au;
  end if;
exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--9.	�������� A�. ����������������� ���������� ������������� ROWID � ���������� UPDATE � DELETE. 
--������ ������ where current of
declare
  cursor cur_au(mini auditorium.auditorium_capacity%type, maxi auditorium.auditorium_capacity%type) is
    select auditorium, auditorium_capacity, rowid 
    from auditorium
    where auditorium_capacity between mini and maxi for update;
    cty auditorium.auditorium_capacity%type;
begin
  for xxx in cur_au(40, 80)
  loop
    cty := xxx.auditorium_capacity * 0.9;
    update auditorium
    set auditorium_capacity = cty
    where rowid like xxx.rowid;
  end loop;
-----
  for xxx in cur_au(40, 80)
  loop
    dbms_output.put_line('updated  '|| xxx.auditorium|| ' '||xxx.auditorium_capacity);
  end loop;
----
  rollback;
  dbms_output.put_line('rollback!');
  for xxx in cur_au(40, 80)
  loop
    dbms_output.put_line('restored  '|| xxx.auditorium|| ' '||xxx.auditorium_capacity);
  end loop;
exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--10.	������������ � ����� ����� ���� �������������� (TEACHER), �������� �������� �� ��� (�������� ������ ������ -------------). 
declare
  cursor cur_teacher is select teacher_name from teacher;
  i integer := 1;
begin
  for xxx in cur_teacher
    loop
      dbms_output.put_line(xxx.teacher_name);
      if mod(i, 3) like 0 then dbms_output.put_line('-------------');
      end if;
    i := i+1;
    end loop;
end;
