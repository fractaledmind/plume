CREATE TABLE t2c(
x INTEGER CONSTRAINT x_one CONSTRAINT x_two
CHECK( typeof(coalesce(x,0))=='integer' )
CONSTRAINT x_two CONSTRAINT x_three,
y INTEGER, z INTEGER,
CONSTRAINT u_one UNIQUE(x,y,z) CONSTRAINT u_two
);