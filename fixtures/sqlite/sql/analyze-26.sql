PRAGMA writable_schema=on;
UPDATE sqlite_master SET sql='nonsense' WHERE name='sqlite_stat1';