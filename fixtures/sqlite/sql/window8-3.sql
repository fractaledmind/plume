SELECT sum(b) OVER (
ORDER BY a RANGE BETWEEN 5 PRECEDING AND 10 FOLLOWING
) FROM t1 ORDER BY 1;