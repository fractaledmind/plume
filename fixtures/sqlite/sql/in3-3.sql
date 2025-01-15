SELECT rowid
FROM t1
WHERE rowid IN (SELECT rowid FROM t1 WHERE rowid IN (1, 2));