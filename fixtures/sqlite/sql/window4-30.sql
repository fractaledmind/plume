SELECT
lead(y) OVER win, lead(y) OVER win
FROM t1
WINDOW win AS (ORDER BY x)