SELECT a, sum(d) OVER (
ORDER BY d
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) FROM t1