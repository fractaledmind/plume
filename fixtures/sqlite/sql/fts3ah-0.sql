CREATE VIRTUAL TABLE t1 USING fts3(content);
INSERT INTO t1 (rowid, content) VALUES(1, $doc1);
INSERT INTO t1 (rowid, content) VALUES(2, $doc2);
INSERT INTO t1 (rowid, content) VALUES(3, $doc3);