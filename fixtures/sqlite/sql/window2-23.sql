SELECT a, sum(d) OVER (
PARTITION BY b
ORDER BY d
ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING
) FROM t1