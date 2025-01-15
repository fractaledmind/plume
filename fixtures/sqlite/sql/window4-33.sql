SELECT row_number() OVER win,
nth_value(d,2) OVER win,
lead(d) OVER win
FROM t1
WINDOW win AS (ORDER BY a)