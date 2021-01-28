--структура и размеры
select * from v$sga;
--общий размер области sga
select sum(value) from v$sga;
--размеры гранул компонент sga -  Гранула (granule) - это выделяемый участок непрерывной области виртуальной памяти
select component, current_size, granule_size from v$sga_dynamic_components where current_size >0;

--	Определите объем доступной свободной памяти в SGA.
select sum(max_size), sum(current_size) from v$sga_dynamic_components;

--	Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.
select component, current_size from v$sga_dynamic_components where
component like '%DEFAULT%' or component like '%KEEP%' or component like '%RECYCLE%';

--	Создайте таблицу, которая будут помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.
--	Создайте таблицу, которая будут кэшироваться в пуле default. Продемонстрируйте сегмент таблицы. 
create table XXX (k int) storage(buffer_pool keep);
create table YYY (k int) storage(buffer_pool recycle);
create table ZZZ (k int) storage(buffer_pool default);

insert into XXX values(1);
insert into YYY values(1);  --чтобы сегмент появился
insert into ZZZ values(1);

select segment_name, segment_type,  buffer_pool from user_segments 
where segment_name in ('XXX', 'YYY', 'ZZZ');

drop table XXX;
drop table YYY;
drop table ZZZ;

--	Найдите размер буфера журналов повтора.
show parameter log_buffer;

--	Найдите 10 самых больших объектов в разделяемом пуле.
--	Найдите размер свободной памяти в большом пуле.
select  pool, name, bytes from v$sgastat where pool like 'large pool' order by bytes;

--	Получите перечень текущих соединений с инстансом. 
select * from v$session;
select osuser, schemaname, server from v$session;
--	Определите режимы текущих соединений с инстансом (dedicated, shared).
--	*Найдите самые часто используемые объекты в базе данных.--?
