SELECT round(percent_rank() OVER win, 2),
round(cume_dist() OVER win, 2)
FROM t1
WINDOW win AS (ORDER BY a)