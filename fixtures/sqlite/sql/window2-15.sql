SELECT a, sum(d) OVER (
ORDER BY d
ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
) FROM t1