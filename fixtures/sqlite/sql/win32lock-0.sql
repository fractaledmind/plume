PRAGMA cache_size=10;
CREATE TABLE t1(x,y);
INSERT INTO t1 VALUES(1,randomblob(100000));
INSERT INTO t1 VALUES(2,randomblob(50000));
INSERT INTO t1 VALUES(3,randomblob(25000));
INSERT INTO t1 VALUES(4,randomblob(12500));
SELECT x, length(y) FROM t1 ORDER BY rowid;