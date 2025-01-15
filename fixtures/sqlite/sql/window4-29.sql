SELECT lead(y, 3, -1) OVER win FROM t1
WINDOW win AS (ORDER BY x)