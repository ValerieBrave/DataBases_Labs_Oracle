grant alter system to c##svvcore;
--1.	Разработайте простейший анонимный блок PL/SQL (АБ), не содержащий операторов. 
begin
  null;
end;
--2.	Разработайте АБ, выводящий «Hello World!». Выполните его в SQLDev и SQL+.
begin
  dbms_output.put_line('Hello world!'); --SQLPLUS ставим . и /
end;
---3.	Продемонстрируйте работу исключения и встроенных функций sqlerrm, sqlcode.
declare
  x number(3) := 3;
  y number(3) := 0;
  z number(10,2);
begin
  dbms_output.put_line('x = '||x||', y = '||y);
  z:=x/y;
  dbms_output.put_line('z = '||z);
exception
  when others
  then
  dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;
--4.	Разработайте вложенный блок. Продемонстрируйте принцип обработки исключений во вложенных блоках.
declare
  x number(3) := 3;
  y number(3) := 0;
  z number(10,2);
begin
  dbms_output.put_line('x = '||x||', y = '||y);
    begin
      z:=x/y;
      
    end;
  dbms_output.put_line('z = '||z);
exception
  when others
  then
  dbms_output.put_line('outer block error = '||sqlerrm||', code = '||sqlcode);
end;
--5.	Выясните, какие типы предупреждения компилятора поддерживаются в данный момент.
show parameter plsql_warnings;
alter system set plsql_warnings = 'ENABLE:INFORMATIONAL';
--6.	Разработайте скрипт, позволяющий просмотреть все спецсимволы PL/SQL.
select keyword from SYS.v_$reserved_words
where length = 1 order by keyword;
--7.	Разработайте скрипт, позволяющий просмотреть все ключевые слова  PL/SQL.
select keyword from SYS.v_$reserved_words
where length > 1 order by keyword;
--8.	Разработайте скрипт, позволяющий просмотреть все параметры Oracle Server, связанные с PL/SQL. Просмотрите эти же параметры с помощью SQL+-команды show.
select name, value
from v$parameter
where name like '%plsql%';
--
show parameter plsql;

--9.	Разработайте анонимный блок, демонстрирующий (выводящий в выходной серверный поток результаты):
--объявление и инициализацию целых number-переменных;
--арифметические действия над двумя целыми number-переменных, включая деление с остатком;
--объявление и инициализацию number-переменных с фиксированной точкой;
--объявление и инициализацию number-переменных с фиксированной точкой и отрицательным масштабом (округление);
--объявление и инициализацию BINARY_FLOAT-переменной;
--объявление и инициализацию BINARY_DOUBLE-переменной;
--объявление number-переменных с точкой и применением символа E (степень 10) при инициализации/присвоении;
--объявление и инициализацию BOOLEAN-переменных. 
declare
  num1 number(3) := 3;
  num2 number(3) := 5;
  num3 number(3); num4 number(3,2);
  num5 number(6, 4) := 25.1234;
  num6 number(6, 2) := 36.2255;
  float1 binary_float := 12.3333345;
  double1 binary_double := 13.123456789876;
  num7 number := 10000.505e+2;
  bool1 boolean := true;
begin
  num3 := num1+num2;
  num4 := num2/num1;
  dbms_output.put_line('num1 = '||num1||', num2 = '||num2||', num1+num2='||num3||', num2/num1='||num4);
  dbms_output.put_line('num5 = '||num5);
  dbms_output.put_line('flooring num6 = '||num6);
  dbms_output.put_line('binary float float1 = '||float1);
  dbms_output.put_line('binary double double1 = '||double1);
  dbms_output.put_line('num7 = '||num7);
  if bool1 then dbms_output.put_line('bool1 = true'); end if;
  if not bool1 then dbms_output.put_line('bool1 = false'); end if;
exception
  when others
  then
  dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--10.	Разработайте анонимный блок PL/SQL содержащий объявление констант (VARCHAR2, CHAR, NUMBER). Продемонстрируйте  возможные операции с константами.  
declare
  vch2 constant varchar2(25) := 'vch2';
  ch constant char(3) := 'sss';
  z  number not null := 5;
  
begin
  vch2 :='he';
  z :=null;
exception
  when others
  then
  dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--11.	Разработайте АБ, содержащий объявления с опцией %TYPE. Продемонстрируйте действие опции.
declare
  subject c##svvcore.subject.subject%type;
  pulpit c##svvcore.pulpit.pulpit%type;
begin
  subject := 'ЯП';
  dbms_output.put_line('subject: '||subject);
  pulpit := '12345678910';
  dbms_output.put_line('pulpit: '||pulpit);
  exception
  when others
  then
  dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;

--12.	Разработайте АБ, содержащий объявления с опцией %ROWTYPE. Продемонстрируйте действие опции.
declare
  pulpit_row c##svvcore.pulpit%rowtype;
begin
  pulpit_row.pulpit := 'ПОИТ';
  pulpit_row.pulpit_name := 'Программное обеспечение информационных технологий';
  pulpit_row.faculty := 'ФИТ';
  dbms_output.put_line('pulpit_row.pulpit: '||pulpit_row.pulpit);
  dbms_output.put_line('pulpit_row.pulpit_name: '||pulpit_row.pulpit_name);
  dbms_output.put_line('pulpit_row.faculty: '||pulpit_row.faculty);
  exception
  when others
  then
  dbms_output.put_line('error = '||sqlerrm||', code = '||sqlcode);
end;
--13.	Разработайте АБ, демонстрирующий все возможные конструкции оператора IF .
declare
  x integer :=20;
begin
  if 5 > x then dbms_output.put_line('5 > '||x); end if;
  if 5 > x then dbms_output.put_line('5 > '||x);
  else dbms_output.put_line('5 <= '||x); end if;
   if 5 > x then dbms_output.put_line('5 > '||x);
   elsif x > 25 then dbms_output.put_line('25 < '||x);
   elsif x = 20 then dbms_output.put_line('x = 20'); end if;
end;

--14.	Разработайте АБ, демонстрирующий работу оператора CASE.
declare
  x integer := 15;
begin
  case x
  when 10 then dbms_output.put_line('x = 10');
  when 14 then dbms_output.put_line('x = 14');
  when 15 then dbms_output.put_line('x = 15');
  end case;
  ---
  case
  when x > 20 then  dbms_output.put_line('x > 20');
  when x between 13 and 20 then dbms_output.put_line('13 < x < 20');
  else dbms_output.put_line('else');
  end case;
end;

--15.	Разработайте АБ, демонстрирующий работу оператора LOOP.
--16.	Разработайте АБ, демонстрирующий работу оператора WHILE.
--17.	Разработайте АБ, демонстрирующий работу оператора FOR.
declare
  x integer := 0;
begin
  loop
    x := x+1;
    dbms_output.put_line('loop: x = '||x);
  exit when x > 5;
  end loop;
  ---
  for k in 1..5
  loop
    dbms_output.put_line('for: k = '||k);
  end loop;
  ---
  while (x > 0)
  loop
    x := x-1;
    dbms_output.put_line('while: x = '||x);
  end loop;
end;



















