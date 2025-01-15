BEGIN;
UPDATE t4 SET y='lots of data for the row where x=' || x
|| ' and y=' || y || ' - even more data to fill space';
COMMIT;
SELECT count(*) FROM t4;