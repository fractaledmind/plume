SELECT (SELECT 1 FROM t1 WHERE a=0 UNION ALL SELECT 2 FROM t1 WHERE b=4)