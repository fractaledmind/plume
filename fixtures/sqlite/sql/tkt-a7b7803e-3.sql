SELECT (a=99) AS x, (t1.b='first') AS y, *
FROM t1
WHERE x OR y
ORDER BY a