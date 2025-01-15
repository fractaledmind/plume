INSERT INTO c8 SELECT x FROM c4;
INSERT INTO c8 VALUES('Alpha'),('ALPHA'),('foxtrot');
DELETE FROM c4;
PRAGMA foreign_key_check;