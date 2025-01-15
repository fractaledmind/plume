UPDATE t3 SET c$i='b$i';
SELECT * FROM t3_changes ORDER BY rowid DESC LIMIT 1;