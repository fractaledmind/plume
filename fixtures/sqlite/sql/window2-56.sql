SELECT avg(x) OVER (ORDER BY y) AS z FROM t1 ORDER BY z;