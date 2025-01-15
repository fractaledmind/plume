-- in.test
-- 
-- execsql { 
--     CREATE TABLE t7(a, b, c NOT NULL);
--     INSERT INTO t7 VALUES(1,    1, 1);
--     INSERT INTO t7 VALUES(2,    2, 2);
--     INSERT INTO t7 VALUES(3,    3, 3);
--     INSERT INTO t7 VALUES(NULL, 4, 4);
--     INSERT INTO t7 VALUES(NULL, 5, 5);
-- }
CREATE TABLE t7(a, b, c NOT NULL);
INSERT INTO t7 VALUES(1,    1, 1);
INSERT INTO t7 VALUES(2,    2, 2);
INSERT INTO t7 VALUES(3,    3, 3);
INSERT INTO t7 VALUES(NULL, 4, 4);
INSERT INTO t7 VALUES(NULL, 5, 5);