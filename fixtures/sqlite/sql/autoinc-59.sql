CREATE TABLE fake_sequence(name TEXT PRIMARY KEY,seq) WITHOUT ROWID;
PRAGMA writable_schema=on;
UPDATE sqlite_master SET
sql=replace(sql,'fake_','sqlite_'),
name='sqlite_sequence',
tbl_name='sqlite_sequence'
WHERE name='fake_sequence';