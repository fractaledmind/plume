CREATE TABLE t3_data(l, x, y);
INSERT INTO t3_data(rowid, l, x, y) SELECT docid, l, x, y FROM t2;
DROP TABLE t2;