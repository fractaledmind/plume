SELECT a FROM (SELECT * FROM t1 ORDER BY a)
EXCEPT SELECT a FROM (SELECT a FROM t1 ORDER BY a LIMIT $::ii)
ORDER BY a DESC
LIMIT $::jj;