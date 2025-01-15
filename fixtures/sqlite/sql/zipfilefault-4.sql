WITH c(n, d) AS (
SELECT 1, 'aaaaaaaaaaabbbbbbbbbbaaaaaaaaaabbbbbbbbbb'
)
SELECT name, data FROM zipfile(
(SELECT zipfile(n, d) FROM c)
);