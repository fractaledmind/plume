SELECT a.x, avg(a.y) AS avg1
FROM t34 AS a
GROUP BY a.x
HAVING NOT EXISTS( SELECT b.x, avg(b.y) AS avg2
FROM t34 AS b
GROUP BY b.x
HAVING avg1 > avg2);