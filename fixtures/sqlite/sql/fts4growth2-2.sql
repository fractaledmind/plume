INSERT INTO x1(docid, content)
SELECT docid, words FROM t1 WHERE (rowid%4)==$val+0;