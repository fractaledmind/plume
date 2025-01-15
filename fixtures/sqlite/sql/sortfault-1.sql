WITH r(x,y) AS (
SELECT 100, $::str
UNION ALL
SELECT x-1, $::str FROM r
LIMIT 100
)
SELECT count(x), length(y) FROM r GROUP BY y COLLATE utf16bin, (x%5)