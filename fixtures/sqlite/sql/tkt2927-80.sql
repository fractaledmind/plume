SELECT abs(a), abs(b) FROM t1
INTERSECT
SELECT abs(a), abs(b) FROM t1
ORDER BY 1