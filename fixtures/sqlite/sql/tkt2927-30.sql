SELECT abs(a), abs(b) FROM t1
UNION
SELECT a, abs(b) FROM t1
ORDER BY 1