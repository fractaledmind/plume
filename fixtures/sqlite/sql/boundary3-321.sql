SELECT t2.a FROM t1 JOIN t2 USING(a)
WHERE t1.rowid > 65536 ORDER BY t2.a