SELECT c, sum(c) OVER win1 FROM t1
WINDOW win1 AS (ORDER BY b)