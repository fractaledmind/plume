PRAGMA auto_vacuum = 0;
PRAGMA journal_mode = WAL;
CREATE TABLE data(x);
INSERT INTO data VALUES('need xShmOpen to see this');
PRAGMA wal_checkpoint;