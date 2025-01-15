INSERT INTO echo_abc SELECT a||'.v2', b, c FROM echo_abc;
SELECT last_insert_rowid();