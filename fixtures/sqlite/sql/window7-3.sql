SELECT a, sum(b) OVER (
ORDER BY a GROUPS BETWEEN 0 PRECEDING AND 0 FOLLOWING
) FROM t3 ORDER BY 1;