CREATE VIEW v3 AS SELECT a FROM t1 UNION SELECT b FROM t1 ORDER BY b;
SELECT * FROM v3 LIMIT 4;