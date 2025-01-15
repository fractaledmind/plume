CREATE TABLE t1(a, b UNIQUE, c UNIQUE);
INSERT INTO t1 VALUES(1, randomblob(500), randomblob(500));
INSERT INTO t1 VALUES(2, randomblob(500), randomblob(500));
PRAGMA journal_mode = wal;
INSERT INTO t1 VALUES(3, randomblob(500), randomblob(500));
BEGIN;
SELECT a FROM t1;