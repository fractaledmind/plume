SELECT sum(a) OVER win FROM t1
WINDOW win AS (ROWS BETWEEN 'hello' PRECEDING AND 10 FOLLOWING)