SELECT t1.a FROM t1 JOIN t2 ON t1.rowid < t2.r
WHERE t2.a=57
ORDER BY t1.rowid DESC