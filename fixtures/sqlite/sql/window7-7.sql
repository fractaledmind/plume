SELECT a, sum(b) OVER (
ORDER BY a RANGE BETWEEN 2 PRECEDING AND 1 FOLLOWING
) FROM t3 ORDER BY 1;