DROP VIEW v1;
CREATE VIEW v1 AS SELECT a AS 'xyz', b+c AS 'pqr', c-b FROM t1;
SELECT * FROM v1 LIMIT 1