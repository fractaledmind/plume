SELECT a, sum(d) OVER (
ORDER BY d
ROWS BETWEEN 1000 PRECEDING AND 1 FOLLOWING
) FROM t1