PRAGMA page_size=1024;
PRAGMA temp_store=MEMORY;
BEGIN;
CREATE TABLE t1(x INTEGER PRIMARY KEY, y TEXT);
WITH RECURSIVE c(x) AS (VALUES(1) UNION SELECT x+1 FROM c WHERE x<$::i)
INSERT INTO t1(x,y) SELECT x*10, printf('%04d%.800c',x,'*') FROM c;
SAVEPOINT one;
SELECT count(*) FROM t1;
WITH RECURSIVE c(x) AS (VALUES(1) UNION SELECT x+1 FROM c WHERE x<$::i)
INSERT INTO t1(x,y) SELECT x*10+1, printf('%04d%.800c',x,'*') FROM c;
ROLLBACK TO one;
SELECT count(*) FROM t1;
SAVEPOINT twoB;
WITH RECURSIVE c(x) AS (VALUES(1) UNION SELECT x+1 FROM c WHERE x<10)
INSERT INTO t1(x,y) SELECT x*10+2, printf('%04d%.800c',x,'*') FROM c;
ROLLBACK TO twoB;
RELEASE one;
COMMIT;