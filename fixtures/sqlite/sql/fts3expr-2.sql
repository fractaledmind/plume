CREATE VIRTUAL TABLE test USING fts3 (keyword);
INSERT INTO test VALUES ('abc');
SELECT * FROM test WHERE keyword MATCH '""';