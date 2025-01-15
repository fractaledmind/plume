SELECT percentile_disc($in*0.01) WITHIN GROUP(ORDER BY x)
FROM t1