CREATE TABLE t7(x INTEGER, y REAL, PRIMARY KEY(x AUTOINCREMENT));
INSERT INTO t7(y) VALUES(123);
INSERT INTO t7(y) VALUES(234);
DELETE FROM t7;
INSERT INTO t7(y) VALUES(345);
SELECT * FROM t7;