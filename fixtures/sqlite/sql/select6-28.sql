SELECT a,b,a+b FROM (SELECT avg(x) as 'a', y as 'b' FROM t1 GROUP BY b)
ORDER BY a