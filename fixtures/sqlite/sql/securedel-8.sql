DETACH db2;
ATTACH 'test2.db' AS db2;
PRAGMA db2.secure_delete;