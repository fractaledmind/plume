SELECT a, sum(d) OVER (
ORDER BY d
ROWS BETWEEN 1 PRECEDING AND 1000 FOLLOWING
) FROM t1