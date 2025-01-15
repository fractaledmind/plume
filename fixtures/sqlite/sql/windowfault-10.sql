WITH v(a, b, row_number) AS (
SELECT a, b, row_number() OVER (PARTITION BY a COLLATE nocase ORDER BY b) FROM t1
)
SELECT * FROM v WHERE a=2