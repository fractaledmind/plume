SELECT a, sum(d) OVER (
ORDER BY d/2
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) FROM t1