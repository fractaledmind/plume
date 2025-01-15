CREATE TABLE x2_rules(ruleset, cFrom, cTo, cost);
INSERT INTO x2_rules VALUES(0, 'a', 'x', 1);
INSERT INTO x2_rules VALUES(0, 'b', 'x', 2);
INSERT INTO x2_rules VALUES(0, 'c', 'x', 3);
CREATE VIRTUAL TABLE x2 USING fuzzer(x2_rules);