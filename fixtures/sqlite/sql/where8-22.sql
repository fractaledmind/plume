SELECT a, d FROM t1, t2 WHERE (a = 2 OR a = 3) AND (d = +a OR e = 'sixteen')
ORDER BY +a, +d;