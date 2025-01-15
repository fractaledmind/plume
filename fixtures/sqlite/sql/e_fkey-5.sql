PRAGMA foreign_keys = OFF;
PRAGMA legacy_alter_table = ON;
ALTER TABLE p RENAME TO parent;
SELECT sql FROM sqlite_master WHERE name = 'c';