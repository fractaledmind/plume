PRAGMA page_size = 1024;
PRAGMA journal_mode = WAL;
PRAGMA wal_autocheckpoint=128;
PRAGMA journal_size_limit=16384;
CREATE TABLE t1(a, b, PRIMARY KEY(a, b));