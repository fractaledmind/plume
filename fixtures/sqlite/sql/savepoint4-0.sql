PRAGMA cache_size=10;
BEGIN;
CREATE TABLE t1(x TEXT);
INSERT INTO t1 VALUES(randstr(10,400));
INSERT INTO t1 VALUES(randstr(10,400));
INSERT INTO t1 SELECT randstr(10,400) FROM t1;
INSERT INTO t1 SELECT randstr(10,400) FROM t1;
INSERT INTO t1 SELECT randstr(10,400) FROM t1;
INSERT INTO t1 SELECT randstr(10,400) FROM t1;
INSERT INTO t1 SELECT randstr(10,400) FROM t1;
INSERT INTO t1 SELECT randstr(10,400) FROM t1;
INSERT INTO t1 SELECT randstr(10,400) FROM t1;
INSERT INTO t1 SELECT randstr(10,400) FROM t1;
INSERT INTO t1 SELECT randstr(10,400) FROM t1;
COMMIT;
SELECT count(*) FROM t1;