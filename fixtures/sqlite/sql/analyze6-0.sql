CREATE TABLE cat(x INT, yz TEXT);
CREATE UNIQUE INDEX catx ON cat(x);
/* Give cat 16 unique integers */
INSERT INTO cat(x) VALUES(1);
INSERT INTO cat(x) VALUES(2);
INSERT INTO cat(x) SELECT x+2 FROM cat;
INSERT INTO cat(x) SELECT x+4 FROM cat;
INSERT INTO cat(x) SELECT x+8 FROM cat;

CREATE TABLE ev(y INT);
CREATE INDEX evy ON ev(y);
/* ev will hold 32 copies of 16 integers found in cat */
INSERT INTO ev SELECT x FROM cat;
INSERT INTO ev SELECT x FROM cat;
INSERT INTO ev SELECT y FROM ev;
INSERT INTO ev SELECT y FROM ev;
INSERT INTO ev SELECT y FROM ev;
INSERT INTO ev SELECT y FROM ev;
ANALYZE;
SELECT count(*) FROM cat;
SELECT count(*) FROM ev;