SELECT a+b, a-b, a, b FROM t1
UNION ALL
SELECT a+b, a-b, abs(a), abs(b) FROM t1