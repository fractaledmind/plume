CREATE TABLE t201(x INTEGER PRIMARY KEY, y UNIQUE, z);
CREATE INDEX t201z ON t201(z);
ANALYZE;