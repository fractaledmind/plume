CREATE TABLE t1(x integer primary key);
BEGIN;
INSERT INTO t1 VALUES(1);
INSERT INTO t1 VALUES(2);
INSERT INTO t1 SELECT x+2 FROM t1;
INSERT INTO t1 SELECT x+4 FROM t1;
INSERT INTO t1 SELECT x+8 FROM t1;
INSERT INTO t1 SELECT x+16 FROM t1;
INSERT INTO t1 SELECT x+32 FROM t1;
INSERT INTO t1 SELECT x+64 FROM t1;
INSERT INTO t1 SELECT x+128 FROM t1;
INSERT INTO t1 SELECT x+256 FROM t1;
INSERT INTO t1 SELECT x+512 FROM t1;
INSERT INTO t1 SELECT x+1024 FROM t1;
INSERT INTO t1 SELECT x+2048 FROM t1;
INSERT INTO t1 SELECT x+4096 FROM t1;
INSERT INTO t1 SELECT x+8192 FROM t1;
INSERT INTO t1 SELECT x+16384 FROM t1;
INSERT INTO t1 SELECT x+32768 FROM t1;
INSERT INTO t1 SELECT x+65536 FROM t1;
INSERT INTO t1 SELECT x+131072 FROM t1;
INSERT INTO t1 SELECT x+262144 FROM t1;
COMMIT;
SELECT count(*) FROM t1;