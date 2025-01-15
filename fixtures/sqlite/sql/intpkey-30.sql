UPDATE t1 SET c='www' WHERE c='world';
SELECT rowid, a, c FROM t1 WHERE c=='www';