SELECT dense_rank() OVER win FROM t2
WINDOW win AS (ORDER BY c IS NULL)