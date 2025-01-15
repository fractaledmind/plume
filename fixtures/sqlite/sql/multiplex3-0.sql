CREATE TABLE t1(a PRIMARY KEY, b);
INSERT INTO t1 VALUES(randomblob(15), randomblob(2000));
INSERT INTO t1 SELECT randomblob(15), randomblob(2000) FROM t1;    --   2
INSERT INTO t1 SELECT randomblob(15), randomblob(2000) FROM t1;    --   4
INSERT INTO t1 SELECT randomblob(15), randomblob(2000) FROM t1;    --   8
INSERT INTO t1 SELECT randomblob(15), randomblob(2000) FROM t1;    --  16
INSERT INTO t1 SELECT randomblob(15), randomblob(2000) FROM t1;    --  32
INSERT INTO t1 SELECT randomblob(15), randomblob(2000) FROM t1;    --  64
INSERT INTO t1 SELECT randomblob(15), randomblob(2000) FROM t1;    -- 128
INSERT INTO t1 SELECT randomblob(15), randomblob(2000) FROM t1;    -- 256
INSERT INTO t1 SELECT randomblob(15), randomblob(2000) FROM t1;    -- 512