CREATE VIEW v4 AS
SELECT a, b FROM t1
UNION
SELECT b AS 'x', a AS 'y' FROM t1
ORDER BY x, y;
SELECT b FROM v4 ORDER BY b LIMIT 4;