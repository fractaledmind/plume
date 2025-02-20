CREATE TABLE t1(x COLLATE NOCASE PRIMARY KEY) WITHOUT rowid;
CREATE TRIGGER tt1 AFTER DELETE ON t1
WHEN EXISTS ( SELECT 1 FROM t2 WHERE old.x = y )
BEGIN
INSERT INTO t1 VALUES(old.x);
END;
CREATE TABLE t2(y REFERENCES t1);
INSERT INTO t1 VALUES('A');
INSERT INTO t1 VALUES('B');
INSERT INTO t2 VALUES('a');
INSERT INTO t2 VALUES('b');

SELECT * FROM t1;
SELECT * FROM t2;