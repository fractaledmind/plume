SELECT a AS x, b||c AS y
FROM t1
WHERE y='aaabbb'
GROUP BY x, y