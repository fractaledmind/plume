CREATE TABLE t3(a,b,c COLLATE NOCASE);
INSERT INTO t3 SELECT * FROM t1;
INSERT INTO t3 SELECT * FROM t2;
INSERT INTO t3 SELECT * FROM t1;
INSERT INTO t3 SELECT * FROM t2;
INSERT INTO t3 SELECT * FROM t1;
INSERT INTO t3 SELECT * FROM t2;
SELECT count(*) FROM t3;