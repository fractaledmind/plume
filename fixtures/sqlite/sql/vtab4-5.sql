BEGIN;
INSERT INTO secho SELECT * FROM techo;
DELETE FROM techo;
COMMIT;