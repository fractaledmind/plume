PRAGMA mmap_size(0);
CREATE TABLE t3(a,b,c);
SELECT name FROM sqlite_master WHERE type='table' ORDER BY 1;
PRAGMA quick_check;
PRAGMA mmap_size;