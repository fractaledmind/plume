SELECT percentile_cont($in*0.01) WITHIN GROUP(ORDER BY x)
FROM t2