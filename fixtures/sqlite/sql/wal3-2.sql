BEGIN;
INSERT INTO t1 SELECT a_string(800) FROM t1 LIMIT 100;
ROLLBACK;
PRAGMA integrity_check;