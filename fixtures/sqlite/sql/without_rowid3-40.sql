CREATE TABLE t1(a INTEGER PRIMARY KEY, b, c, UNIQUE(c, b)) WITHOUT rowid;
CREATE TABLE t2(e REFERENCES t1 ON UPDATE SET NULL ON DELETE SET NULL, f);
CREATE TABLE t3(g, h, i,
FOREIGN KEY (h, i)
REFERENCES t1(b, c) ON UPDATE SET NULL ON DELETE SET NULL
);