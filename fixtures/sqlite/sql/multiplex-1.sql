CREATE TABLE t1(a, b);
INSERT INTO t1 VALUES(1, randomblob($g_chunk_size));
INSERT INTO t1 VALUES(2, randomblob($g_chunk_size));