CREATE TABLE t1(a,b);
WITH RECURSIVE c(x) AS (VALUES(1) UNION ALL SELECT x+1 FROM c WHERE x<100)
INSERT INTO t1(a,b) SELECT x, printf('%d-x%.*c',x,x,'x') FROM c;
PRAGMA integrity_check;