CREATE TABLE p(a UNIQUE);
CREATE TABLE c(b REFERENCES p(a));
BEGIN;
ALTER TABLE p RENAME TO parent;
SELECT sql FROM sqlite_master WHERE name = 'c';
ROLLBACK;