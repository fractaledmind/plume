PRAGMA reverse_unordered_selects=1;
SELECT * FROM t1 WHERE a>0 ORDER BY rowid;