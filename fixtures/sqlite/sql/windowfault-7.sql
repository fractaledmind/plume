SELECT a, sum(b) OVER win1 FROM t1
WINDOW win1 AS (PARTITION BY a ),
win2 AS (PARTITION BY b )
ORDER BY a;