CREATE TABLE t1(a TEXT COLLATE BINARY);
ALTER TABLE t1 ADD COLUMN b INTEGER COLLATE NOCASE;
INSERT INTO t1 VALUES(1,'-2');
INSERT INTO t1 VALUES(5.4e-08,'5.4e-08');
SELECT typeof(a), a, typeof(b), b FROM t1;