INSERT INTO t1(t1) VALUES('optimize');
SELECT substr(hex(root), 1, 2) FROM t1_segdir;