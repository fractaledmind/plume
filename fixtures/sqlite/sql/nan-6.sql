DELETE FROM t1;
INSERT INTO t1 VALUES(0.5);
PRAGMA auto_vacuum=OFF;
PRAGMA page_size=1024;
VACUUM;