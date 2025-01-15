PRAGMA page_size = 1024;
PRAGMA locking_mode = exclusive;
PRAGMA auto_vacuum = 'incremental';
BEGIN;
CREATE TABLE a(i integer, b blob);