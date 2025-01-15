WITH r(x,y) AS (
SELECT 300, $::str2
UNION ALL
SELECT x-1, $::str2 FROM r
LIMIT 300
)
SELECT count(x), length(y) FROM r GROUP BY y, (x%5)