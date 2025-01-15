CREATE INDEX t1i1 ON t1(a,b);
SELECT b, typeof(b) FROM t1 WHERE a=3;