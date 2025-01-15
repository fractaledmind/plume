WITH c(name,data) AS (
SELECT '1', randomblob(1000000) UNION ALL
SELECT '2', randomblob(1000000) UNION ALL
SELECT '3', randomblob(1000000)
)
SELECT writefile('test.zip', zipfile(name, data) ) FROM c;