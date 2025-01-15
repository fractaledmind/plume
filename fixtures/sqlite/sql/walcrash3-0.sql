PRAGMA page_size = 512;
PRAGMA journal_mode = WAL;
PRAGMA wal_autocheckpoint = 128;
CREATE TABLE t1(a PRIMARY KEY, b);
INSERT INTO t1 VALUES(randomblob(25), randomblob(200));