PRAGMA cache_size = 10;
BEGIN;
UPDATE t1 SET b = randomblob(400);
UPDATE t1 SET a = randomblob(201);