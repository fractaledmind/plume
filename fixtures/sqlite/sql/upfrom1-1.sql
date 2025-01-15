UPDATE t2 SET b = chng.b, c = chng.c FROM chng WHERE chng.a = t2.a;
SELECT * FROM t2 ORDER BY a;