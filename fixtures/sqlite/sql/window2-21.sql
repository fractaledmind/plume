SELECT a, sum(d) OVER (
ORDER BY d
ROWS BETWEEN 1 FOLLOWING AND 2 FOLLOWING
) FROM t1