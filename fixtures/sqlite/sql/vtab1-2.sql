CREATE TABLE real_abc(a PRIMARY KEY, b, c);
CREATE VIRTUAL TABLE echo_abc USING echo(real_abc);