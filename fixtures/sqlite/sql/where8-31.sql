SELECT c FROM t1 WHERE a > (SELECT d FROM t2 WHERE e = b) OR a = 5