SELECT a FROM (SELECT * FROM t1 ORDER BY a LIMIT 2)
UNION ALL SELECT a FROM (SELECT a FROM t1 ORDER BY a LIMIT 5)
ORDER BY 1
LIMIT $::ii;