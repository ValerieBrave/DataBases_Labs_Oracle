--	�������� ������ ������ ������� ���������. 
select count(*) from v$bgprocess;
select name, description from v$bgprocess;


--	���������� ������� ��������, ������� �������� � �������� � ��������� ������.  
--paddr - ����� ������� ��������� ����� ������� �� ������� ������� PADDR ����� �������� 0!!!
select name, description from v$bgprocess where paddr!=hextoraw('00') order by name;

--	����������, ������� ��������� DBWn �������� � ��������� ������.
--Database Writer Process
SELECT spid, pname, username, program  FROM v$process WHERE pname LIKE 'DBW%';


--	���������� ������� (����� ����������� ����������).
select name, network_name, pdb from v$services;

--	�������� ��������� ��� ��������� ���������� � �� ��������.
show parameter dispatcher;

--	������� � ������ Windows-�������� ������, ����������� ������� LISTENER.

--	�������� �������� ������� ���������� � ���������. (dedicated, shared). 
select username, sid, serial#, server, status from v$session where username is not null;

--	����������������� � �������� ���������� ����� LISTENER.ORA. 
--	��������� ������� lsnrctl � �������� �� �������� �������. 
--  �������� ������ ����� ��������, ������������� ��������� LISTENER. 
