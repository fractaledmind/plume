SELECT (SELECT 1 FROM t1 WHERE a=0 UNION SELECT 2 FROM t1 WHERE b=0)