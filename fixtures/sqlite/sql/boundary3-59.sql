SELECT t2.a FROM t2 NATURAL JOIN t1
WHERE t1.rowid > 4294967296 ORDER BY t1.a DESC