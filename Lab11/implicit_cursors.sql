--1. Разработайте АБ, демонстрирующий работу оператора SELECT с точной выборкой. 
--select * from teacher;
declare
  teacher_info teacher%rowtype;
  b1 boolean;
  b2 boolean;
  b3 boolean;
  n integer;
begin
  select * into teacher_info from teacher where pulpit like '%ОВ%' ;
  b1 := sql%found;
  b2 := sql%isopen;
  b3 := sql%notfound;
  n := sql%rowcount;
  
  if b1 then dbms_output.put_line('found = true');
  else dbms_output.put_line('found = false');
  end if;
  if b2 then dbms_output.put_line('isopen = true');
  else dbms_output.put_line('isopen = false');
  end if;
  if b3 then dbms_output.put_line('notfound = true');
  else dbms_output.put_line('notfound = false');
  end if;
  dbms_output.put_line('rowcount = '||n);
  dbms_output.put_line('teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  exception
  when others then
    dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;
--2. Разработайте АБ, демонстрирующий работу оператора SELECT с неточной точной выборкой. 
--Используйте конструкцию WHEN OTHERS секции исключений и встроенную функции SQLERRM, SQLCODE для диагностирования неточной выборки. 
--3. Разработайте АБ, демонстрирующий работу конструкции WHEN TO_MANY_ROWS секции исключений для диагностирования неточной выборки. 
declare
  teacher_info teacher%rowtype;
begin
  select * into teacher_info from teacher;
  dbms_output.put_line('teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  exception
  when too_many_rows then dbms_output.put_line('TOO MANY ROWS error = '||sqlerrm||', code = '||sqlcode);
  when others then
    dbms_output.put_line('OTHER error = '||sqlerrm||', code = '||sqlcode);
end;

--4. Разработайте АБ, демонстрирующий возникновение и обработку исключения NO_DATA_FOUND. 
declare
  teacher_info teacher%rowtype;
begin
  select * into teacher_info from teacher where pulpit like 'ssss';
  dbms_output.put_line('teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  exception
  when no_data_found then dbms_output.put_line('NO DATA FOUND error = '||sqlerrm||', code = '||sqlcode);
  when others then
    dbms_output.put_line('OTHER error = '||sqlerrm||', code = '||sqlcode);
end;

--5. Разработайте АБ, демонстрирующий применение оператора UPDATE совместно с операторами COMMIT/ROLLBACK. 

declare
  teacher_info teacher%rowtype;
begin
  select * into teacher_info from teacher where pulpit like '%ОВ%' ;
  dbms_output.put_line('BEFORE UPDATE teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  
  savepoint before_upd;
  
  update teacher set teacher_name = 'Гыгы'
  where teacher like '%РВКЧ%';
  select * into teacher_info from teacher where pulpit like '%ОВ%' ;
  dbms_output.put_line('AFTER UPDATE teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  
  rollback to before_upd;
  
  select * into teacher_info from teacher where pulpit like '%ОВ%' ;
  dbms_output.put_line('AFTER ROLLBACK teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
end;

--6. Продемонстрируйте оператор UPDATE, вызывающий нарушение целостности в базе данных. Обработайте возникшее исключение.
declare
  teacher_info teacher%rowtype;
begin
  select * into teacher_info from teacher where pulpit like '%ОВ%' ;
  dbms_output.put_line('BEFORE UPDATE teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  
  savepoint before_upd;
  
  update teacher set pulpit = 'Гыгы'
  where teacher like '%РВКЧ%';
  select * into teacher_info from teacher where pulpit like '%ОВ%' ;
  dbms_output.put_line('AFTER UPDATE teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  
  rollback to before_upd;
  
  select * into teacher_info from teacher where pulpit like '%ОВ%' ;
  dbms_output.put_line('AFTER ROLLBACK teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  
  exception
  when others then
    dbms_output.put_line('OTHER error = '||sqlerrm||', code = '||sqlcode);
end;


--7. Разработайте АБ, демонстрирующий применение оператора INSERT совместно с операторами COMMIT/ROLLBACK.

declare
  teacher_info teacher%rowtype;
begin
  
  savepoint before_ins;
  
  insert into teacher (teacher, teacher_name, pulpit) values ('СМЛВА', 'Смелова Валерия Владимировна', 'ИСиТ');
  
  select * into teacher_info from teacher where teacher like '%СМЛВА%' ;
  dbms_output.put_line('AFTER INSERT teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  
  rollback to before_ins;
  select * into teacher_info from teacher where teacher like '%СМЛВА%' ;
  dbms_output.put_line('AFTER ROLLBACK teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  
  exception
  when no_data_found then dbms_output.put_line('NO DATA FOUND error = '||sqlerrm||', code = '||sqlcode);
  when others then
    dbms_output.put_line('OTHER error = '||sqlerrm||', code = '||sqlcode);
end;


--8. Продемонстрируйте оператор INSERT, вызывающий нарушение целостности в базе данных. Обработайте возникшее исключение.

begin
  insert into teacher (teacher, teacher_name, pulpit) values ('СМЛВА', 'Смелова Валерия Владимировна', 'ssssss');
  exception
  when others then
    dbms_output.put_line('OTHER error = '||sqlerrm||', code = '||sqlcode);
end;

--9. Разработайте АБ, демонстрирующий применение оператора DELETE совместно с операторами COMMIT/ROLLBACK.
declare
  teacher_info teacher%rowtype;
begin
  select * into teacher_info from teacher where teacher like '%РВКЧ%' ;
  
  savepoint before_del;
  
  delete teacher where teacher like '%РВКЧ%';
  
  dbms_output.put_line('after delete teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  select * into teacher_info from teacher where teacher like '%РВКЧ%' ;
      
  exception
  when no_data_found then 
    dbms_output.put_line('NO DATA FOUND error = '||sqlerrm||', code = '||sqlcode);
    rollback to before_del;
    select * into teacher_info from teacher where teacher like '%РВКЧ%' ;
    dbms_output.put_line('AFTER ROLLBACK teacher_info: '||teacher_info.teacher||', '||teacher_info.teacher_name || ', '|| teacher_info.pulpit);
  when others then
    dbms_output.put_line('OTHER error = '||sqlerrm||', code = '||sqlcode);
end;

--10. Продемонстрируйте оператор DELETE, вызывающий нарушение целостности в базе данных. Обработайте возникшее исключение.
begin
  delete faculty where faculty like '%ТОВ%';
  exception
  when others then
    dbms_output.put_line('OTHER error = '||sqlerrm||', code = '||sqlcode);
end;