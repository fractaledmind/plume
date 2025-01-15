PRAGMA auto_vacuum = 0;
PRAGMA page_size = 2048;
CREATE TABLE t1(x);
INSERT INTO t1 VALUES(randomblob(1200));
PRAGMA page_count;