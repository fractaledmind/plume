CREATE TABLE t1(
a INTEGER PRIMARY KEY,
b INTEGER
REFERENCES t1 ON DELETE CASCADE
REFERENCES t2,
c TEXT,
FOREIGN KEY (b,c) REFERENCES t2(x,y) ON UPDATE CASCADE
);