LOAD DATA
	INFILE data.txt	 --��� ����� � �������
  REPLACE 
	INTO TABLE LOAD_DATA 	--��� �������  
  when (t2 = "freh")
	FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
	(
	t1,
	t2 "upper(:t2)",
	t3
	)