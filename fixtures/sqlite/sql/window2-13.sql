SELECT a, sum(d) OVER (
ORDER BY d
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) FROM t1