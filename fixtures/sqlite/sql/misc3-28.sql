SELECT count(a) FROM t3 WHERE b IN (SELECT b FROM t3 ORDER BY a+1);