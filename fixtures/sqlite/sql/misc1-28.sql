CREATE TABLE t7(x INTEGER, y TEXT, z);
INSERT INTO t7 VALUES(0,0,1);
INSERT INTO t7 VALUES(0.0,0,2);
INSERT INTO t7 VALUES(0,0.0,3);
INSERT INTO t7 VALUES(0.0,0.0,4);
SELECT DISTINCT x, y FROM t7 ORDER BY z;