CREATE TABLE t1(a PRIMARY KEY, b REFERENCES t1 ON DELETE CASCADE);
INSERT INTO t1 VALUES(1, NULL);
INSERT INTO t1 VALUES(2, 1);
INSERT INTO t1 VALUES(3, 2);
INSERT INTO t1 VALUES(4, 3);
INSERT INTO t1 VALUES(5, 4);
SELECT count(*) FROM t1;