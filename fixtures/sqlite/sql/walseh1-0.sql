PRAGMA cache_size = 5;
BEGIN;
WITH s(i) AS (
SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<50
)
INSERT INTO t1 SELECT randomblob(500), randomblob(500) FROM s;