CREATE TABLE t1(a INTEGER PRIMARY KEY AUTOINCREMENT, b TEXT);
INSERT INTO t1(b) VALUES('one');
CREATE TABLE fake(name TEXT PRIMARY KEY,seq) WITHOUT ROWID;