SELECT * FROM t1 WHERE a = (SELECT count(*) FROM t1)