CREATE TABLE t2b(
x INTEGER CHECK( typeof(coalesce(x,0))=='integer' ) CONSTRAINT one,
y TEXT PRIMARY KEY constraint two,
z INTEGER,
UNIQUE(x,z) constraint three
);