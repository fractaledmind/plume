BEGIN EXCLUSIVE;
CREATE TABLE t1(x);
INSERT INTO t1 VALUES(1);
INSERT INTO t1 VALUES(2);
INSERT INTO t1 VALUES(3);
INSERT INTO t1 VALUES(4);
SELECT x FROM t1 ORDER BY x;
COMMIT;