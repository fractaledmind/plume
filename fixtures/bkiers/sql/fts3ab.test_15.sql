-- fts3ab.test
-- 
-- execsql {SELECT rowid FROM t4 WHERE plusone MATCH 'one'}
SELECT rowid FROM t4 WHERE plusone MATCH 'one'