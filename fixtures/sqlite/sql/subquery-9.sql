CREATE TABLE t34(x,y);
INSERT INTO t34 VALUES(106,4), (107,3), (106,5), (107,5);
SELECT a.x, avg(a.y)
FROM t34 AS a
GROUP BY a.x
HAVING NOT EXISTS( SELECT b.x, avg(b.y)
FROM t34 AS b
GROUP BY b.x
HAVING avg(a.y) > avg(b.y));