DELETE FROM x2 WHERE docid=$id;
INSERT INTO x2(docid, content) SELECT $id, words FROM t1 WHERE docid=$id;