SELECT t3.* FROM t3, (SELECT max(a), max(b) FROM t4)