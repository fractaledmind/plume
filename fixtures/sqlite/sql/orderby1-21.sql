BEGIN;
DROP TABLE album;
DROP TABLE track;
CREATE TABLE album(
aid INTEGER PRIMARY KEY,
title TEXT UNIQUE NOT NULL
);
CREATE TABLE track(
tid INTEGER PRIMARY KEY,
aid INTEGER NOT NULL REFERENCES album,
tn INTEGER NOT NULL,
name TEXT,
UNIQUE(aid ASC, tn DESC)
);
INSERT INTO album VALUES(1, '1-one'), (2, '2-two'), (3, '3-three');
INSERT INTO track VALUES
(NULL, 1, 1, 'one-a'),
(NULL, 2, 2, 'two-b'),
(NULL, 3, 3, 'three-c'),
(NULL, 1, 3, 'one-c'),
(NULL, 2, 1, 'two-a'),
(NULL, 3, 1, 'three-a');
ANALYZE;
COMMIT;