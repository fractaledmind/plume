PRAGMA cache_size = 10;
CREATE TABLE t1(x, y, z);
CREATE INDEX t1x ON t1(x);
WITH s(i) AS (
SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<1000
)
INSERT INTO t1 SELECT hex(randomblob(20)), hex(randomblob(500)), i FROM s;