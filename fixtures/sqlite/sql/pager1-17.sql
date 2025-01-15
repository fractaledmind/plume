PRAGMA locking_mode = exclusive;
PRAGMA journal_mode = persist;
CREATE TABLE one(two, three);
INSERT INTO one VALUES('a', 'b');