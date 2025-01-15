CREATE TABLE t1(a, b);
CREATE INDEX i1 ON t1(b);
INSERT INTO t1 VALUES(zeroblob(100), zeroblob(100));