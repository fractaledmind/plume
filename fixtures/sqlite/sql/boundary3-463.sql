SELECT t1.a FROM t1 JOIN t2 ON t1.rowid > CAST(t2.r AS real)
WHERE t2.a=50
ORDER BY t1.rowid DESC