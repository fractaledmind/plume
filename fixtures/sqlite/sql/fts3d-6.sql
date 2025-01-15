ALTER TABLE fts RENAME TO xyz;
SELECT name FROM sqlite_master WHERE name GLOB '???_*' ORDER BY 1;