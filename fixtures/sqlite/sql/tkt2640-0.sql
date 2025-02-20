CREATE TABLE persons(person_id, name);
INSERT INTO persons VALUES(1,'fred');
INSERT INTO persons VALUES(2,'barney');
INSERT INTO persons VALUES(3,'wilma');
INSERT INTO persons VALUES(4,'pebbles');
INSERT INTO persons VALUES(5,'bambam');
CREATE TABLE directors(person_id);
INSERT INTO directors VALUES(5);
INSERT INTO directors VALUES(3);
CREATE TABLE writers(person_id);
INSERT INTO writers VALUES(2);
INSERT INTO writers VALUES(3);
INSERT INTO writers VALUES(4);
SELECT DISTINCT p.name
FROM persons p, directors d
WHERE d.person_id=p.person_id
AND NOT EXISTS (
SELECT person_id FROM directors d1 WHERE d1.person_id=p.person_id
EXCEPT
SELECT person_id FROM writers w
);