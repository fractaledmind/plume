BEGIN;
DELETE FROM t4;
COMMIT;
SELECT count(*) FROM t1;