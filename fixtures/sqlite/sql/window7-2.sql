SELECT a, sum(b) OVER (
ORDER BY a GROUPS BETWEEN CURRENT ROW AND CURRENT ROW
) FROM t3 ORDER BY 1;