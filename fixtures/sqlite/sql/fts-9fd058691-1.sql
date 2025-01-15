UPDATE fts SET tags = 'two' WHERE rowid = 2;
SELECT * FROM fts WHERE tags MATCH 'two';