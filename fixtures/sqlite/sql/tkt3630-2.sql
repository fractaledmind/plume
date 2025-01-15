ALTER TABLE temp2 ADD COLUMN d;
ALTER TABLE temp2 RENAME TO temp2rn;
SELECT name FROM temp.sqlite_master WHERE name LIKE 'temp2%';