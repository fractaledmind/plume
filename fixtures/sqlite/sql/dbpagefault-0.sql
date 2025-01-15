CREATE VIRTUAL TABLE t1 USING sqlite_dbpage();
UPDATE t1 SET data=zeroblob(1024) WHERE pgno=1 AND schema='aux';