BEGIN;
INSERT INTO t1 VALUES( randomblob(4000) );
DELETE FROM t1;