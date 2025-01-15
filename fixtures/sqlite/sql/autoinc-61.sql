CREATE TABLE t1(a INTEGER PRIMARY KEY AUTOINCREMENT, b TEXT);
INSERT INTO t1(b) VALUES('one');
PRAGMA writable_schema=on;
UPDATE sqlite_master SET
sql='CREATE VIRTUAL TABLE sqlite_sequence USING sqlite_dbpage'
WHERE name='sqlite_sequence';