BEGIN;
INSERT INTO t1 (rowid, content) VALUES(12, 'third world');
COMMIT;
SELECT rowid FROM t1 WHERE t1 MATCH 'third';