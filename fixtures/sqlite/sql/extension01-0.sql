CREATE TABLE t1(a INTEGER PRIMARY KEY, b TEXT);
INSERT INTO t1 VALUES(1, readfile('./file1.txt'));
SELECT * FROM t1;