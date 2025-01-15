CREATE TABLE t1(a INTEGER PRIMARY KEY AUTOINCREMENT, b TEXT);
INSERT INTO t1(b) VALUES('one');
PRAGMA writable_schema=on;
UPDATE sqlite_master SET
sql=replace(sql,'sqlite_','x_'),
name='x_sequence',
tbl_name='x_sequence'
WHERE name='sqlite_sequence';