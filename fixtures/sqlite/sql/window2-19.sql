SELECT a, sum(d) OVER (
PARTITION BY b
ORDER BY d
ROWS BETWEEN UNBOUNDED PRECEDING AND 2 PRECEDING
) FROM t1