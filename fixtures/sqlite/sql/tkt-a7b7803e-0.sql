CREATE TABLE t1(a,b);
INSERT INTO t1 VALUES(0,'first'),(99,'fuzzy');
SELECT (t1.a==0) AS x, b
FROM t1
WHERE a=0 OR x;