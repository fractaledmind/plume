UPDATE t1 SET b=randomblob(501), c=randomblob(501) WHERE a=1;
INSERT INTO t1 VALUES(4, randomblob(500), randomblob(500));
INSERT INTO t1 VALUES(5, randomblob(500), randomblob(500));
INSERT INTO t1 VALUES(6, randomblob(500), randomblob(500));
BEGIN;