SELECT sum(a) OVER win FROM t1
WINDOW win AS (ROWS BETWEEN 10 PRECEDING AND x'ABCD' FOLLOWING)