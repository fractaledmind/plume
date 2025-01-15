WITH c(name,mtime,data) AS (
SELECT 'a.txt', 946684800, 'abc' UNION ALL
SELECT 'b.txt', 1000000000, 'abc' UNION ALL
SELECT 'c.txt', 1111111000, 'abc'
)
SELECT writefile('test1.zip', rt( zipfile(name, NULL, mtime, data) ) ),
writefile('test2.zip',   ( zipfile(name, NULL, mtime, data) ) )
FROM c;