SELECT a, sum(d) OVER (
ORDER BY d
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
) FROM t1