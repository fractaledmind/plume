SELECT max(value1), (SELECT count(*) FROM t2 WHERE value2=value1)
FROM t1
GROUP BY id1;