DROP TABLE IF EXISTS t5;
CREATE TABLE t5(
a INT NOT NULL ON CONFLICT FAIL,
b TEXT,
c TEXT,
PRIMARY KEY(a,b)
) WITHOUT ROWID;