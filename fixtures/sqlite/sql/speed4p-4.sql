SELECT (SELECT t FROM t1 WHERE rowid = $v),
(SELECT t FROM t2 WHERE rowid = $v),
(SELECT t FROM t3 WHERE rowid = $v)