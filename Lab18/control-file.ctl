LOAD DATA
	INFILE data.txt	 --имя файла с данными
  REPLACE 
	INTO TABLE LOAD_DATA 	--имя таблицы  
  when (t2 = "freh")
	FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
	(
	t1,
	t2 "upper(:t2)",
	t3
	)