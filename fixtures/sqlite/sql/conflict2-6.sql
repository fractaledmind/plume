-- Create a database object (pages 2, 3 of the file)
BEGIN;
CREATE TABLE abc(a PRIMARY KEY, b, c) WITHOUT rowid;
INSERT INTO abc VALUES(1, 2, 3);
INSERT INTO abc VALUES(4, 5, 6);
INSERT INTO abc VALUES(7, 8, 9);
COMMIT;