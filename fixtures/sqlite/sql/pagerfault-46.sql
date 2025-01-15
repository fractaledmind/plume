CREATE TABLE t1(x PRIMARY KEY, y);
INSERT INTO t1 VALUES(randomblob(200), randomblob(200));
INSERT INTO t1 SELECT randomblob(200), randomblob(200) FROM t1;
INSERT INTO t1 SELECT randomblob(200), randomblob(200) FROM t1;
INSERT INTO t1 SELECT randomblob(200), randomblob(200) FROM t1;