CREATE TABLE one(a INT PRIMARY KEY, b) WITHOUT rowid;
CREATE TABLE two(b, c REFERENCES one);
INSERT INTO one VALUES(101, 102);