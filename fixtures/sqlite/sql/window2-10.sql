SELECT a, sum(d) OVER (
PARTITION BY b
ORDER BY d
ROWS BETWEEN 0 PRECEDING AND 0 FOLLOWING
) FROM t1