CREATE TABLE t1(x UNIQUE);
INSERT INTO t1 VALUES(1);
INSERT INTO t1 VALUES(2);
INSERT INTO t1 SELECT x+2 FROM t1;
INSERT INTO t1 SELECT x+4 FROM t1;
INSERT INTO t1 SELECT x+8 FROM t1;