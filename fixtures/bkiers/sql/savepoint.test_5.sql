-- savepoint.test
-- 
-- execsql {
--     SAVEPOINT sp1;
--     SAVEPOINT sp2;
--     RELEASE sp2;
-- }
SAVEPOINT sp1;
SAVEPOINT sp2;
RELEASE sp2;