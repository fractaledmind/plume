WITH c(n, d) AS (
VALUES('a.txt', '1234567890') UNION ALL
VALUES('dir', NULL)
)
SELECT zipfile(n, d) IS NULL FROM c;