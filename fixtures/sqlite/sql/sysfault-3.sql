INSERT INTO t1 VALUES(randomblob(10000), randomblob(10000));
SELECT length(a) + length(b) FROM t1;
COMMIT;