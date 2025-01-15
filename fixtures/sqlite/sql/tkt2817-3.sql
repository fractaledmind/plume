CREATE TABLE main.tbl(a, b, c);
CREATE INDEX main.tbli ON tbl(a, b, c);
INSERT INTO main.tbl SELECT a, b, c FROM temp.tmp;