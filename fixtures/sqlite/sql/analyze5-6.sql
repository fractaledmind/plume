UPDATE t1 SET x=NULL;
UPDATE t1 SET x=rowid
WHERE rowid IN (SELECT rowid FROM t1 ORDER BY random() LIMIT 5);
ANALYZE;