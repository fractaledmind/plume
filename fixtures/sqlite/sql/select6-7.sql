SELECT q, p, r
FROM (SELECT count(*) as p , y as q FROM t1 GROUP BY y) AS a,
(SELECT max(x) as r, y as s FROM t1 GROUP BY y) as b
WHERE q=s ORDER BY s