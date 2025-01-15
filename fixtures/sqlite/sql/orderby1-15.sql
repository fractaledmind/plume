BEGIN;
DROP TABLE album;
DROP TABLE track;
CREATE TABLE album(
aid INT PRIMARY KEY,
title TEXT NOT NULL
);
CREATE INDEX album_i1 ON album(title, aid);
CREATE TABLE track(
aid INTEGER NOT NULL REFERENCES album,
tn INTEGER NOT NULL,
name TEXT,
UNIQUE(aid, tn)
);
INSERT INTO album VALUES(1, '1-one'), (20, '2-two'), (3, '3-three');
INSERT INTO track VALUES
(1,  1, 'one-a'),
(20, 2, 'two-b'),
(3,  3, 'three-c'),
(1,  3, 'one-c'),
(20, 1, 'two-a'),
(3,  1, 'three-a');
ANALYZE;
COMMIT;