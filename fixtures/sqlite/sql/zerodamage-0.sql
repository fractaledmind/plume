PRAGMA page_size=1024;
PRAGMA journal_mode=DELETE;
PRAGMA cache_size=5;
CREATE VIRTUAL TABLE nums USING wholenumber;
CREATE TABLE t1(x, y);
INSERT INTO t1 SELECT value, randomblob(100) FROM nums
WHERE value BETWEEN 1 AND 400;