PRAGMA auto_vacuum = 1;
CREATE TABLE t1(x PRIMARY KEY);
INSERT INTO t1 VALUES(randomblob(1200));
PRAGMA page_count;