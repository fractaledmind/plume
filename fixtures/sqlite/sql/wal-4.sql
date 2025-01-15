PRAGMA cache_size = 10;
PRAGMA wal_checkpoint;
BEGIN;
SAVEPOINT s;
INSERT INTO t1 SELECT randomblob(900), randomblob(900) FROM t1;
ROLLBACK TO s;
COMMIT;