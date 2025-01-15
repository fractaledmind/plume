INSERT INTO t3(x, y, langid)
SELECT x, y, (docid%9)*4 FROM t1 WHERE docid=$docid;