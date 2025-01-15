SELECT sum(a), sum(length(b)) FROM t1;
PRAGMA integrity_check;
PRAGMA journal_mode;
PRAGMA page_count;