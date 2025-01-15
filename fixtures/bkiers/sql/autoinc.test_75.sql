-- autoinc.test
-- 
-- db eval {
--       CREATE VIEW va69637_2 AS SELECT * FROM ta69637_2;
--       CREATE TRIGGER ra69637_2 INSTEAD OF INSERT ON va69637_2 BEGIN
--         INSERT INTO ta69637_1(y) VALUES(new.z+10000);
--       END;
--       INSERT INTO va69637_2 VALUES(123);
--       SELECT * FROM ta69637_1;
-- }
CREATE VIEW va69637_2 AS SELECT * FROM ta69637_2;
CREATE TRIGGER ra69637_2 INSTEAD OF INSERT ON va69637_2 BEGIN
INSERT INTO ta69637_1(y) VALUES(new.z+10000);
END;
INSERT INTO va69637_2 VALUES(123);
SELECT * FROM ta69637_1;