SELECT b, sum(b) OVER (
ORDER BY b
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) FROM t2 ORDER BY b;