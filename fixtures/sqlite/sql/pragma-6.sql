PRAGMA temp.cache_size = 1;
CREATE TEMP TABLE IF NOT EXISTS a(b);
DELETE FROM a;
INSERT INTO a VALUES(randomblob(1000));
INSERT INTO a SELECT * FROM a;
INSERT INTO a SELECT * FROM a;
INSERT INTO a SELECT * FROM a;
INSERT INTO a SELECT * FROM a;
INSERT INTO a SELECT * FROM a;
INSERT INTO a SELECT * FROM a;
INSERT INTO a SELECT * FROM a;
INSERT INTO a SELECT * FROM a;