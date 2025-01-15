CREATE TABLE t1(a INTEGER PRIMARY KEY AUTOINCREMENT, b TEXT);
INSERT INTO t1(b) VALUES('one');
PRAGMA writable_schema=on;
UPDATE sqlite_master SET
sql='CREATE TABLE sqlite_sequence(x,y INTEGER PRIMARY KEY)'
WHERE name='sqlite_sequence';