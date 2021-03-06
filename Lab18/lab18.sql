create table load_data
(
  t1 NUMBER,
  t2 NVARCHAR2(10),
  t3 DATE
);

select * from load_data;
truncate table  load_data;
drop table load_data;
--� �������
--sqlldr c##svvcore/c##svvcore CONTROL=control-file.ctl

--select � ���� ����� ��������
grant create any directory to c##svvcore;
CREATE OR REPLACE DIRECTORY lab18_dir AS 'D:\LERA\DB3course\Lab18';
grant read, write on directory lab18_dir to c##svvcore;

  create or replace procedure ExportData
  is
    l_file        UTL_FILE.file_type; --��� �����������
    l_file_name   VARCHAR2 (60) := 'data_exported.txt'; --��� �����
    cursor my_select is select t1, t2 from load_data;
    row_t1 load_data.t1%type;  --��� �������
    row_t2 load_data.t2%type;
    one_row_string varchar2(200); --��� ������ � ����
  begin
    l_file := UTL_FILE.fopen ('LAB18_DIR', l_file_name, 'w');
    open my_select;
    fetch my_select into row_t1, row_t2;
    while my_select%found loop
      one_row_string := concat(concat(to_char(row_t1), ';'), concat(row_t2, ';'));
      UTL_FILE.put_line (l_file, one_row_string);
      fetch my_select into row_t1, row_t2;
    end loop;
    close my_select;
    UTL_FILE.fclose (l_file);
  end ExportData;

begin
  ExportData();
end;





