UPDATE t1 SET x=12345 WHERE rowid=5;
SELECT percentile(x, 0), percentile(x, 50), percentile(x,100) FROM t1