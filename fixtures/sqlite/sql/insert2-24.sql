INSERT INTO t2 SELECT (SELECT a FROM t2), 4;
SELECT * FROM t2;