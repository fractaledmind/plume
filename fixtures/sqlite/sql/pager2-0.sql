SELECT COALESCE(max(i), 0) FROM t1;
PRAGMA integrity_check;