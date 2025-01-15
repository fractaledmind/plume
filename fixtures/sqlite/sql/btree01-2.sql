DELETE FROM t1;
WITH RECURSIVE
c(i) AS (VALUES(1) UNION ALL SELECT i+1 FROM c WHERE i<30)
INSERT INTO t1(a,b) SELECT i, zeroblob(6500) FROM c;
UPDATE t1 SET b=zeroblob(6499) WHERE (a%3)==0;
UPDATE t1 SET b=zeroblob(6499) WHERE (a%3)==1;
UPDATE t1 SET b=zeroblob(6499) WHERE (a%3)==2;
UPDATE t1 SET b=zeroblob(64000) WHERE a=$::i;
PRAGMA integrity_check;