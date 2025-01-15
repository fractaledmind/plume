-- triggerC.test
-- 
-- execsql {
--     BEGIN;
--       DELETE FROM t7 WHERE a = 1;
--       SELECT rowid, * FROM t7;
--       SELECT * FROM t8;
--     ROLLBACK;
-- }
BEGIN;
DELETE FROM t7 WHERE a = 1;
SELECT rowid, * FROM t7;
SELECT * FROM t8;
ROLLBACK;