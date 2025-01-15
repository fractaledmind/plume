PRAGMA page_size=4096;
PRAGMA journal_mode=WAL;
CREATE TABLE t1(a);
INSERT INTO t1 VALUES(19);
CREATE INDEX t1a ON t1(a);
PRAGMA integrity_check;