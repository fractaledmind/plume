WITH x(i, j) AS (
SELECT 1, randomblob(100)
UNION ALL
SELECT i+1, randomblob(100) FROM x WHERE i<10000
)
SELECT * FROM x ORDER BY j;