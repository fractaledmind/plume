WITH map2 AS (
SELECT * FROM map
)
SELECT sum(a) OVER (
PARTITION BY (
SELECT t FROM map2 WHERE v=a
) ORDER BY a
) FROM tx;