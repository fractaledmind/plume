SELECT value1, (SELECT sum(value2=value1) FROM t2)
FROM t1
WHERE value1 IN (SELECT max(value1) FROM t1 GROUP BY id1);