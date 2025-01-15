PRAGMA writable_schema=on;
UPDATE sqlite_master SET rootpage=$root2
WHERE name='sqlite_sequence';
UPDATE sqlite_master SET rootpage=$root1
WHERE name='fake';