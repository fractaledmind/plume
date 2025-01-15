PRAGMA synchronous = NORMAL;
PRAGMA cache_size = 10;
CREATE TABLE t1(x, y, UNIQUE(x, y));
BEGIN;