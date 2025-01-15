PRAGMA page_size = 1024;
PRAGMA cache_size = 10;
CREATE TABLE t1(a, b);
CREATE INDEX i1 ON t1(b, a);
WITH x(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM x WHERE i<100)
INSERT INTO t1 SELECT randomblob(100), randomblob(100) FROM x;