SELECT
a.x,
avg(a.y),
NOT EXISTS ( SELECT b.x, avg(b.y)
FROM t34 AS b
GROUP BY b.x
HAVING avg(a.y) > avg(b.y)),
EXISTS ( SELECT c.x, avg(c.y)
FROM t34 AS c
GROUP BY c.x
HAVING avg(a.y) > avg(c.y))
FROM t34 AS a
GROUP BY a.x
ORDER BY a.x;