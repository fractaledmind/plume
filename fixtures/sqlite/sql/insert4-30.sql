DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
CREATE TABLE t1(a INTEGER PRIMARY KEY ON CONFLICT ABORT, b);
CREATE TABLE t2(x INTEGER PRIMARY KEY ON CONFLICT ABORT, y);
INSERT INTO t2 VALUES(1,3);
INSERT INTO t1 SELECT * FROM t2;
SELECT * FROM t1;