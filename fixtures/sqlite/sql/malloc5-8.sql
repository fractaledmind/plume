BEGIN;
UPDATE abc SET c = randstr(100,100)
WHERE rowid = 1 OR rowid = (SELECT max(rowid) FROM abc);