BEGIN;
INSERT INTO ft VALUES('abc' || $i);
INSERT INTO ft VALUES('abc' || $i || 'x' );
INSERT INTO ft VALUES('abc' || $i || 'xx' );
COMMIT