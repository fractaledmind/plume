BEGIN;
create TABLE abc(a, b, c, PRIMARY KEY(a, b));
INSERT INTO abc VALUES(1, 1, 1);