SELECT 0 FROM (SELECT * FROM t1 LIMIT 3)
EXCEPT SELECT 9 FROM (SELECT a FROM t1 LIMIT 4)
ORDER BY 1
LIMIT $::ii;