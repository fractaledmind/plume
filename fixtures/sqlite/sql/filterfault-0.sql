SELECT sum(a) FILTER (WHERE b<5),
count() FILTER (WHERE d!=c)
FROM t1 GROUP BY c ORDER BY 1;