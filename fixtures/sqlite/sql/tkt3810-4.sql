ATTACH ':memory:' AS aux1;
CREATE TABLE aux1.t1(x);
CREATE TEMP TRIGGER r1 DELETE ON t1 BEGIN SELECT *; END;
CREATE VIEW t1 AS SELECT *;