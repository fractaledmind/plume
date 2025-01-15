SELECT row_number() OVER win,
rank() OVER win,
dense_rank() OVER win
FROM t1
WINDOW win AS (PARTITION BY c<7 ORDER BY a)