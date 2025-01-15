INSERT INTO c7 SELECT x FROM c3;
INSERT INTO c7 VALUES('Alpha'),('alpha'),('foxtrot');
DELETE FROM c3;
PRAGMA foreign_key_check;