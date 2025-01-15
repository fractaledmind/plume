SELECT
lead(y) OVER win,
lead(y, 2) OVER win,
lead(y, 3, -1) OVER win
FROM t1
WINDOW win AS (ORDER BY x)