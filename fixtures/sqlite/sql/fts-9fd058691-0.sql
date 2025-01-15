UPDATE fts SET tags = 'tag1' WHERE rowid = 1;
SELECT * FROM fts WHERE tags MATCH 'tag1';