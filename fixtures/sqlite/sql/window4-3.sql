SELECT x, percent_rank() OVER (PARTITION BY x ORDER BY x) FROM t2