CREATE TABLE t1(a INT PRIMARY KEY, b, c, UNIQUE(b, c)) WITHOUT rowid;
CREATE TABLE t2(e REFERENCES t1 ON UPDATE CASCADE ON DELETE CASCADE, f);
CREATE TABLE t3(g, h, i,
FOREIGN KEY (h, i)
REFERENCES t1(b, c) ON UPDATE CASCADE ON DELETE CASCADE
);