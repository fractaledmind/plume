CREATE TABLE t4(x);
INSERT INTO t4 VALUES(1);
INSERT INTO t4 VALUES(2);
INSERT INTO t4 SELECT 2+x FROM t4;