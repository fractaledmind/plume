SELECT a, sum(d) OVER (
ORDER BY d
ROWS BETWEEN CURRENT ROW AND CURRENT ROW
) FROM t1