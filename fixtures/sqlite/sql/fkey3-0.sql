PRAGMA foreign_keys=ON;
CREATE TABLE t1(x INTEGER PRIMARY KEY);
INSERT INTO t1 VALUES(100);
INSERT INTO t1 VALUES(101);
CREATE TABLE t2(y INTEGER REFERENCES t1 (x));
INSERT INTO t2 VALUES(100);
INSERT INTO t2 VALUES(101);
SELECT 1, x FROM t1;
SELECT 2, y FROM t2;