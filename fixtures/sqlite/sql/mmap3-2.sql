PRAGMA mmap_size=250000;
DROP TABLE t2;
SELECT name FROM sqlite_master WHERE type='table' ORDER BY 1;
PRAGMA quick_check;
PRAGMA mmap_size;