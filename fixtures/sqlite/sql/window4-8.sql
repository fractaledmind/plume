DROP TABLE IF EXISTS t7;
CREATE TABLE t7(id INTEGER PRIMARY KEY, a INTEGER, b INTEGER);
INSERT INTO t7(id, a, b) VALUES
(1, 1, 2), (2, 1, NULL), (3, 1, 4),
(4, 3, NULL), (5, 3, 8), (6, 3, 1);