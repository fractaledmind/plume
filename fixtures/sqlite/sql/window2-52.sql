SELECT
rank() OVER win AS rank,
cume_dist() OVER win AS cume_dist FROM t1
WINDOW win AS (ORDER BY 1);