SELECT t1.a FROM t1 JOIN t2 ON t1.rowid <= t2.r
WHERE t2.a=37
ORDER BY t1.rowid