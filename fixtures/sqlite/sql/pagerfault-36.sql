PRAGMA page_size = 1024;
PRAGMA journal_mode = truncate;
PRAGMA auto_vacuum = full;
PRAGMA locking_mode=exclusive;
CREATE TABLE t1(a, b);
INSERT INTO t1 VALUES(1, 2);
PRAGMA page_size = 4096;