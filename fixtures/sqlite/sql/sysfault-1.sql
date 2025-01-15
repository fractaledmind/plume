CREATE TABLE t1(a, b, c, PRIMARY KEY(a));
INSERT INTO t1 VALUES('abc', 'def', 'ghi');
ATTACH 'test.db2' AS 'aux';
CREATE TABLE aux.t2(x);
INSERT INTO t2 VALUES(1);