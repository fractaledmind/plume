PRAGMA journal_mode=WAL;
PRAGMA wal_autocheckpoint=OFF;
PRAGMA journal_size_limit=12000;
CREATE TABLE t1(x);
INSERT INTO t1 VALUES(randomblob(50000));
UPDATE t1 SET x=randomblob(50000);