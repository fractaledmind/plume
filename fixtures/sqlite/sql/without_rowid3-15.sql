PRAGMA foreign_keys = off;
ALTER TABLE t2 ADD COLUMN h DEFAULT 'text' REFERENCES t1;
PRAGMA foreign_keys = on;
SELECT sql FROM sqlite_schema WHERE name='t2';