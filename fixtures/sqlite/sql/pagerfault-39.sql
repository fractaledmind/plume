PRAGMA page_size = 512;

PRAGMA journal_mode = wal;
PRAGMA wal_autocheckpoint = 0;
PRAGMA cache_size = 100000;

BEGIN;
CREATE TABLE t2(a UNIQUE, b UNIQUE);
INSERT INTO t2 VALUES( a_string(800), a_string(800) );
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
COMMIT;
CREATE TABLE t1(a PRIMARY KEY, b);