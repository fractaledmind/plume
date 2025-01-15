WITH r(x,y) AS (
SELECT 1, randomblob(100)
UNION ALL
SELECT x+1, randomblob(100) FROM r
LIMIT 1000
)
SELECT count(x), length(y) FROM r GROUP BY (x%5)