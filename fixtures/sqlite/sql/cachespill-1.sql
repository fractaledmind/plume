PRAGMA cache_spill = 0;
BEGIN;
WITH s(i) AS (
SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<200
) INSERT INTO t1 SELECT randomblob(900) FROM s;