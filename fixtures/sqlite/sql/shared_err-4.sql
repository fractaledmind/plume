INSERT INTO t1 SELECT 'string' || a, b FROM t1 WHERE 0 = (a%7);