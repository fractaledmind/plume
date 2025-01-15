DELETE FROM child;
DELETE FROM parent;
INSERT INTO parent VALUES(-1);
INSERT INTO child VALUES(-1);
UPDATE parent SET x = 22;
SELECT * FROM parent ORDER BY rowid; SELECT 'xxx' ; SELECT a FROM child;