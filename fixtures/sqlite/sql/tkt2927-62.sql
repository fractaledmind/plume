SELECT abs(a), abs(b) FROM t1
EXCEPT
SELECT a, abs(b) FROM t1