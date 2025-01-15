DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
CREATE TABLE t1(a INTEGER PRIMARY KEY ON CONFLICT ABORT, b);
CREATE TABLE t2(x INTEGER PRIMARY KEY ON CONFLICT ABORT, y);
INSERT INTO t1 VALUES(1,2);
INSERT INTO t2 VALUES(-99,100);
INSERT INTO t2 VALUES(1,3);
SELECT * FROM t1;