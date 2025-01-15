DROP TABLE IF EXISTS tx;
CREATE TABLE tx(a INTEGER PRIMARY KEY);
INSERT INTO tx VALUES(1), (2), (3), (4), (5), (6);

DROP TABLE IF EXISTS map;
CREATE TABLE map(v INTEGER PRIMARY KEY, t TEXT);
INSERT INTO map VALUES
(1, 'odd'), (2, 'even'), (3, 'odd'),
(4, 'even'), (5, 'odd'), (6, 'even');