SELECT a,b,c FROM t3 UNION SELECT x,y,z FROM t2
ORDER BY c COLLATE BINARY DESC,a,b