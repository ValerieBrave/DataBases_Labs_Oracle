--��������� � �������
select * from v$sga;
--����� ������ ������� sga
select sum(value) from v$sga;
--������� ������ ��������� sga -  ������� (granule) - ��� ���������� ������� ����������� ������� ����������� ������
select component, current_size, granule_size from v$sga_dynamic_components where current_size >0;

--	���������� ����� ��������� ��������� ������ � SGA.
select sum(max_size), sum(current_size) from v$sga_dynamic_components;

--	���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.
select component, current_size from v$sga_dynamic_components where
component like '%DEFAULT%' or component like '%KEEP%' or component like '%RECYCLE%';

--	�������� �������, ������� ����� ���������� � ��� ���P. ����������������� ������� �������.
--	�������� �������, ������� ����� ������������ � ���� default. ����������������� ������� �������. 
create table XXX (k int) storage(buffer_pool keep);
create table YYY (k int) storage(buffer_pool recycle);
create table ZZZ (k int) storage(buffer_pool default);

insert into XXX values(1);
insert into YYY values(1);  --����� ������� ��������
insert into ZZZ values(1);

select segment_name, segment_type,  buffer_pool from user_segments 
where segment_name in ('XXX', 'YYY', 'ZZZ');

drop table XXX;
drop table YYY;
drop table ZZZ;

--	������� ������ ������ �������� �������.
show parameter log_buffer;

--	������� 10 ����� ������� �������� � ����������� ����.
--	������� ������ ��������� ������ � ������� ����.
select  pool, name, bytes from v$sgastat where pool like 'large pool' order by bytes;

--	�������� �������� ������� ���������� � ���������. 
select * from v$session;
select osuser, schemaname, server from v$session;
--	���������� ������ ������� ���������� � ��������� (dedicated, shared).
--	*������� ����� ����� ������������ ������� � ���� ������.--?
