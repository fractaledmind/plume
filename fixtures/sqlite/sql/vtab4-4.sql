CREATE TABLE sreal(a, b, c UNIQUE);
CREATE VIRTUAL TABLE secho USING echo(sreal);