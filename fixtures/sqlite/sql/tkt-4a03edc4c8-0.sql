CREATE TABLE t1(
a INTEGER PRIMARY KEY ON CONFLICT REPLACE,
b UNIQUE ON CONFLICT FAIL
);
INSERT INTO t1 VALUES(1, 1);
INSERT INTO t1 VALUES(2, 2);