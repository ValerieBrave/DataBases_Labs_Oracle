--	Получите полный список фоновых процессов. 
select count(*) from v$bgprocess;
select name, description from v$bgprocess;


--	Определите фоновые процессы, которые запущены и работают в настоящий момент.  
--paddr - адрес объекта состояния Когда процесс не запущен столбец PADDR имеет значение 0!!!
select name, description from v$bgprocess where paddr!=hextoraw('00') order by name;

--	Определите, сколько процессов DBWn работает в настоящий момент.
--Database Writer Process
SELECT spid, pname, username, program  FROM v$process WHERE pname LIKE 'DBW%';


--	Определите сервисы (точки подключения экземпляра).
select name, network_name, pdb from v$services;

--	Получите известные вам параметры диспетчера и их значений.
show parameter dispatcher;

--	Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.

--	Получите перечень текущих соединений с инстансом. (dedicated, shared). 
select username, sid, serial#, server, status from v$session where username is not null;

--	Продемонстрируйте и поясните содержимое файла LISTENER.ORA. 
--	Запустите утилиту lsnrctl и поясните ее основные команды. 
--  Получите список служб инстанса, обслуживаемых процессом LISTENER. 
