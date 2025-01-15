SELECT a, abs(b) FROM t1
EXCEPT
SELECT abs(a), abs(b) FROM t1