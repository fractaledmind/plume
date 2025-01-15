WITH r(x,y) AS (
SELECT 1, $::str
UNION ALL
SELECT x+1, $::str FROM r
LIMIT 200
)
SELECT count(x), length(y) FROM r GROUP BY (x%5)