WITH x AS (
WITH y(b) AS (SELECT 10)
SELECT * FROM y UNION ALL SELECT * FROM y
)
SELECT * FROM x