CREATE TABLE t1(a, b);
INSERT INTO t1 VALUES(1, 2);
PRAGMA journal_mode = WAL;
INSERT INTO t1 VALUES(3, 4);
SELECT * FROM t1;
CREATE TEMP TABLE t2(x);
INSERT INTO t2 VALUES('y');