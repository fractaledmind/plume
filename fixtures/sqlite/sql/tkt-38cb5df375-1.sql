SELECT * FROM (SELECT * FROM t1 ORDER BY a)
UNION ALL SELECT 9 FROM (SELECT a FROM t1)
LIMIT $::ii;