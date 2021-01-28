--execute as system
grant create trigger to c##svvcore;
grant alter any trigger to c##svvcore;
grant drop any trigger to c##svvcore;

--execute as c##svvcore;
create table t15
(
  t_id integer not null primary key,
  t_val nvarchar2(32),
  t_num integer
);
drop table t15;
insert into t15(t_id, t_val, t_num) values (13, 'fre', 1);

--3.	Создайте BEFORE – триггер уровня оператора на события INSERT, DELETE и UPDATE. 
--4.	Этот и все последующие триггеры должны выдавать сообщение на серверную консоль (DMS_OUTPUT) со своим собственным именем. 
--6.	Примените предикаты INSERTING, UPDATING и DELETING.
create or replace trigger before_iud_1
before insert or update or delete on t15
begin
  if inserting then
    dbms_output.put_line('before_iud_1 INSERT');
  elsif updating then
    dbms_output.put_line('before_iud_1 UPDATE');
  elsif deleting then
    dbms_output.put_line('before_iud_1 DELETE');
  end if;
end;

drop trigger before_iud_1;

insert into t15(t_id, t_val, t_num) values (10, 'fry', 2);
--insert into t15(t_id, t_val, t_num) values (11, 'fre', 2);
update t15 set t_val='fry xxx' where t_id =10;
delete t15 where t_id =10;

--5.	Создайте BEFORE-триггер уровня строки на события INSERT, DELETE и UPDATE.
create or replace trigger row_before_iud_1
before insert or update or delete on t15
for each row
begin
  if inserting then
    dbms_output.put_line('row_before_iud_1 INSERT');
  elsif updating then
    dbms_output.put_line('row_before_iud_1 UPDATE');
  elsif deleting then
    dbms_output.put_line('row_before_iud_1 DELETE');
  end if;
end;
select * from t15;
insert into t15(t_id, t_val, t_num) values (10, 'fry', 2);
update t15 set t_val='fry xxx' where t_id =10;
delete t15 where t_id =10;

--7.	Разработайте AFTER-триггеры уровня оператора на события INSERT, DELETE и UPDATE.
create or replace trigger after_insert_1
after insert on t15
  begin
    dbms_output.put_line('after_insert_1');
  end;
  
create or replace trigger after_update_1
after update on t15
  begin
    dbms_output.put_line('after_update_1');
  end;
  
create or replace trigger after_delete_1
after delete on t15
  begin
    dbms_output.put_line('after_delete_1');
  end;

--8.	Разработайте AFTER-триггеры уровня строки на события INSERT, DELETE и UPDATE.
create or replace trigger row_after_insert_1
after insert on t15
for each row
  begin
    dbms_output.put_line('row_after_insert_1');
  end;
  
create or replace trigger row_after_update_1
after update on t15
for each row
  begin
    dbms_output.put_line('row_after_update_1');
  end;
  
create or replace trigger row_after_delete_1
after delete on t15
for each row
  begin
    dbms_output.put_line('row_after_delete_1');
  end;

--9.	Создайте таблицу с именем AUDIT. Таблица должна содержать поля: OperationDate, 
--OperationType (операция вставки, обновления и удаления),
--TriggerName(имя триггера),
--Data (строка с значениями полей до и после операции).
create table "AUDIT"
(
  OperationDate date,
  OperationType nvarchar2(10),
  TriggerName nvarchar2(30),
  Data_change nvarchar2(100)
);

--10.	Измените триггеры таким образом, чтобы они регистрировали все операции с исходной таблицей в таблице AUDIT.
--new + old только для for each row

drop trigger before_iud_1;
drop trigger row_before_iud_1;
drop trigger after_insert_1;
drop trigger after_update_1;
drop trigger after_delete_1;
drop trigger row_after_insert_1;
drop trigger row_after_update_1;
drop trigger row_after_delete_1;


create or replace trigger before_iud_1
before insert or update or delete on t15
begin
  if inserting then
    insert into "AUDIT"(operationdate, operationtype, triggername)  values (sysdate, 'INSERT', 'before_iud_1');
    end if;
  if updating then
    insert into "AUDIT"(operationdate, operationtype, triggername)  values (sysdate, 'UPDATE', 'before_iud_1');
    end if;
  if deleting then
    insert into "AUDIT"(operationdate, operationtype, triggername)  values (sysdate, 'DELETE', 'before_iud_1');
    --values(sysdate, 'DELETE', 'before_iud_1', concat(:old.t_val, ' deleted'))
  end if;
end;

-----
create or replace trigger row_before_iud_1
before insert or update or delete on t15
for each row
begin
  if inserting then
    dbms_output.put_line('row_before_iud_1 INSERT');
    insert into "AUDIT"(operationdate, operationtype, triggername, data_change)  
    values (sysdate, 'INSERT', 'row_before_iud_1', :new.t_val);
  elsif updating then
    dbms_output.put_line('row_before_iud_1 UPDATE');
    insert into "AUDIT"(operationdate, operationtype, triggername, data_change)  
    values (sysdate, 'UPDATE', 'row_before_iud_1', concat(concat(:old.t_val, '->'), :new.t_val)); 
  elsif deleting then
    dbms_output.put_line('row_before_iud_1 DELETE');
    insert into "AUDIT"(operationdate, operationtype, triggername, data_change)  
    values (sysdate, 'DELETE', 'row_before_iud_1', concat(:old.t_val, ' deleted'));
  end if;
end;
------
create or replace trigger after_insert_1
after insert on t15
  begin
    insert into "AUDIT"(operationdate, operationtype, triggername)  
    values (sysdate, 'INSERT', 'after_insert_1');
  end;
  
create or replace trigger after_update_1
after update on t15
  begin
    insert into "AUDIT"(operationdate, operationtype, triggername)  
    values (sysdate, 'UPDATE', 'after_update_1');
  end;
  
create or replace trigger after_delete_1
after delete on t15
  begin
    insert into "AUDIT"(operationdate, operationtype, triggername)  
    values (sysdate, 'DELETE', 'after_delete_1');
  end;
--------
create or replace trigger row_after_insert_1
after insert on t15
for each row
  begin
    dbms_output.put_line('row_after_insert_1');
    insert into "AUDIT"(operationdate, operationtype, triggername, data_change)  
    values (sysdate, 'INSERT', 'row_after_insert_1', :new.t_val);
  end;
  
create or replace trigger row_after_update_1
after update on t15
for each row
  begin
    dbms_output.put_line('row_after_update_1');
    insert into "AUDIT"(operationdate, operationtype, triggername, data_change)  
    values (sysdate, 'UPDATE', 'row_after_update_1', concat(concat(:old.t_val, '->'), :new.t_val)); 
  end;
  
create or replace trigger row_after_delete_1
after delete on t15
for each row
  begin
    dbms_output.put_line('row_after_delete_1');
    insert into "AUDIT"(operationdate, operationtype, triggername, data_change)  
     values (sysdate, 'DELETE', 'row_after_delete_1', concat(:old.t_val, ' deleted'));
  end;

--demo
select * from t15;
insert into t15(t_id, t_val, t_num) values (10, 'fry', 3);
update t15 set t_val='fry xxx' where t_id =10;
delete t15 where t_id =10;

select * from "AUDIT";
truncate table "AUDIT";

--11.	Выполните операцию, нарушающую целостность таблицы по первичному ключу. 
--Выясните, зарегистрировал ли триггер это событие. Объясните результат.
truncate table "AUDIT";

insert into t15(t_id, t_val, t_num) values (13, 'fry', 3); --duplicate

select * from "AUDIT";

--12.	 
--Добавьте триггер, запрещающий удаление исходной таблицы.
create or replace trigger tr_drop_table
before drop on SCHEMA
begin
  raise_application_error(-20000, 'Do not drop '||ORA_DICT_OBJ_TYPE||' '||ORA_DICT_OBJ_NAME);
end;

drop table t15;

drop trigger tr_drop_table;

--14.	Создайте представление над исходной таблицей. 
--Разработайте INSTEADOF INSERT-триггер. Триггер должен добавлять строку в таблицу.

create view t15_view as select t_id ua, t_val na from t15;

create or replace trigger tr_t15
instead of insert on t15_view
for each row
begin
  dbms_output.put_line('insert '||:new.ua);
  insert into t15(t_id, t_val) values (:new.ua, :new.na);
end;

insert into t15_view(ua, na) values (3, 'khe');
delete t15 where t_id = 3;
commit;
select * from t15_view;
select * from t15;









