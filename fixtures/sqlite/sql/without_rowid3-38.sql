CREATE TABLE t1(a INT PRIMARY KEY, b, c, UNIQUE(b, c)) WITHOUT rowid;
CREATE TABLE t2(e REFERENCES t1, f);
CREATE TABLE t3(g, h, i, FOREIGN KEY (h, i) REFERENCES t1(b, c));