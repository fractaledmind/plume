CREATE TABLE main(id INT PRIMARY KEY) WITHOUT rowid;
CREATE TABLE sub(id INT REFERENCES main(id));
INSERT INTO main VALUES(1);
INSERT INTO main VALUES(2);
INSERT INTO sub VALUES(2);