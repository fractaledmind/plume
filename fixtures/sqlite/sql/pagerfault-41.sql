PRAGMA page_size = 1024;
PRAGMA cache_size = 5;

BEGIN;
CREATE TABLE t2(a UNIQUE, b UNIQUE);
INSERT INTO t2 VALUES( a_string(800), a_string(800) );
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
INSERT INTO t2 SELECT a_string(800), a_string(800) FROM t2;
COMMIT;