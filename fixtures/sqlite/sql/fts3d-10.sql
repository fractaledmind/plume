ALTER TABLE xyz RENAME TO ott;
SELECT name FROM sqlite_master WHERE name GLOB '???_*' ORDER BY 1;