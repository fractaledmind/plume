CREATE TABLE t2(x TEXT COLLATE NOCASE);
INSERT INTO t2 SELECT * FROM t1 ORDER BY rowid;
CREATE INDEX i2 ON t2(x COLLATE NOCASE);