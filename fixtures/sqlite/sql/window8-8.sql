SELECT sum(b) OVER (
ORDER BY a DESC RANGE BETWEEN 5 FOLLOWING AND 10 FOLLOWING
) FROM t1 ORDER BY 1 NULLS LAST;