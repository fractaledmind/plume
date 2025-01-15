PRAGMA cache_size = 1;
DELETE FROM t1 WHERE rowid%4;
PRAGMA integrity_check;