SELECT 9 FROM (SELECT * FROM t1)
UNION ALL SELECT a FROM (SELECT a FROM t1 ORDER BY a LIMIT 3)
LIMIT $::ii;