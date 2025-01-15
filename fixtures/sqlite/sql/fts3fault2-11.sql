CREATE VIRTUAL TABLE t6 USING fts4(x,order=DESC);
INSERT INTO t6(docid, x) VALUES(-1,'a b');
INSERT INTO t6(docid, x) VALUES(1, 'b');