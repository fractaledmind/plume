CREATE TABLE t1(a, b);
CREATE TABLE t2(a, b);
INSERT INTO t1 VALUES('one'  , 1);
INSERT INTO t1 VALUES('two'  , 5);
INSERT INTO t1 VALUES('two'  , 2);
INSERT INTO t1 VALUES('three', 3);
PRAGMA count_changes = 1;