BEGIN TRANSACTION;
INSERT INTO t1 (rowid, content) VALUES(6, 'another world');
INSERT INTO t1 (rowid, content) VALUES(7, 'another test');
SELECT rowid FROM t1 WHERE t1 MATCH 'world';
COMMIT TRANSACTION;