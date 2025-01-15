PRAGMA cache_size = 2000;
PRAGMA mmap_size = 0;
SELECT x FROM t3 ORDER BY rowid;
SELECT x FROM t3 ORDER BY x;