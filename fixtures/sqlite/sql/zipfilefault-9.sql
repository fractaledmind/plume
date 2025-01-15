WITH c(n, d) AS (
VALUES('a.txt', $big)
)
SELECT zipfile(n, NULL, NULL, d, 0) IS NULL FROM c;