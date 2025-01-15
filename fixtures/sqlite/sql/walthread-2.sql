BEGIN;
INSERT INTO t1 VALUES(randomblob(101 + $::E(pid)));
INSERT INTO t1 VALUES(randomblob(101 + $::E(pid)));
INSERT INTO t1 SELECT md5sum(x) FROM t1;
COMMIT;