PRAGMA auto_vacuum=OFF;
PRAGMA page_size=2048;
BEGIN;
CREATE TABLE abc AS SELECT 1 AS a, 2 AS b, 3 AS c;
COMMIT;