SELECT a AS x, b||c AS y
FROM t1
WHERE b||c='aaabbb'
GROUP BY x, y