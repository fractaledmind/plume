SELECT b, sum(b) OVER (
RANGE BETWEEN CURRENT ROW AND CURRENT ROW
) FROM t2 ORDER BY b;