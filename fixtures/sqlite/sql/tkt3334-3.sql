SELECT a FROM (SELECT a FROM t1 ORDER BY b LIMIT 3) WHERE a=1;