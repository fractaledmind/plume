DELETE FROM x1
WHERE docid IN (SELECT docid FROM t1 WHERE (rowid-1)%4==$val+0);