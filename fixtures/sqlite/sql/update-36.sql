UPDATE t2 SET rowid=rowid+10000;
UPDATE t2 SET rowid=rowid-9999;
SELECT count(*) FROM t2 WHERE a=rowid;