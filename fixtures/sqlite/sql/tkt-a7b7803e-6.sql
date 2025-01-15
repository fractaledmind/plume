SELECT (M.a=99) AS x, M.b, (N.b='first') AS y, N.b
FROM t1 M JOIN t1 N ON x AND y
ORDER BY M.a, N.a