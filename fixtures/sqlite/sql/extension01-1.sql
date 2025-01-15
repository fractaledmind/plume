DELETE FROM t1;
INSERT INTO t1 VALUES(2, readfile(NULL)),(3, readfile('file2.txt'));
SELECT a, b, typeof(b) FROM t1;