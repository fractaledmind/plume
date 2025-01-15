PRAGMA mmap_size = 1000000;
PRAGMA cache_size = 5;
BEGIN;
INSERT INTO t1 SELECT a_string(200), a_string(300) FROM t1;
INSERT INTO t1 SELECT a_string(200), a_string(300) FROM t1;
INSERT INTO t1 SELECT a_string(200), a_string(300) FROM t1;
INSERT INTO t1 SELECT a_string(200), a_string(300) FROM t1;