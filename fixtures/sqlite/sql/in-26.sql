CREATE TABLE t6(a,b NUMERIC);
INSERT INTO t6 VALUES(1,2);
INSERT INTO t6 VALUES(2,3);
SELECT * FROM t6 WHERE b IN (2);