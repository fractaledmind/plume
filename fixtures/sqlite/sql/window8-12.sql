SELECT sum(b) OVER (
ORDER BY a NULLS LAST ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
) FROM t1 ORDER BY 1 NULLS LAST;