BEGIN;
CREATE TABLE A (id INTEGER PRIMARY KEY AUTOINCREMENT, val TEXT);
INSERT INTO A VALUES(1,'123');
INSERT INTO A VALUES(2,'456');
CREATE TABLE B (id INTEGER PRIMARY KEY AUTOINCREMENT, val TEXT);
INSERT INTO B VALUES(1,1);
INSERT INTO B VALUES(2,2);
CREATE TABLE A_B (B_id INTEGER NOT NULL, A_id INTEGER);
INSERT INTO A_B VALUES(1,1);
INSERT INTO A_B VALUES(2,2);
COMMIT;