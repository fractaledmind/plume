BEGIN;
CREATE VIEW IF NOT EXISTS v1 AS SELECT a,b FROM t1;
SELECT * FROM v1 ORDER BY a;