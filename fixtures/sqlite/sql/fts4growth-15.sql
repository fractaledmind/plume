INSERT INTO x2(docid, content) SELECT docid, words FROM t1 WHERE rowid=$r