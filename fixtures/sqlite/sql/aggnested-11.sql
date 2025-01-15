SELECT value1, (SELECT sum(value2=value1) FROM t2)
FROM t1;